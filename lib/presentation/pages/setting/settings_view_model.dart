import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tago_driver/data/models/user.dart';
import 'package:tago_driver/data/services/user_services.dart';

/// 설정 화면의 상태 관리 및 비즈니스 로직을 담당하는 ViewModel
///
/// 역할:
/// 1. Firestore에서 유저 데이터 로드 (이름, 이메일)
/// 2. SharedPreferences에서 로컬 설정 로드 (자주 가는 위치, 알림 설정)
/// 3. 프로필 업데이트 (Firestore)
/// 4. 로컬 설정 업데이트 (SharedPreferences)
/// 5. 로그아웃 및 회원 탈퇴 처리
class SettingsViewModel extends ChangeNotifier {
  // ===== 서비스 =====
  final UserServices _userService = UserServices();

  // ===== Firestore에서 가져온 유저 정보 =====
  /// 현재 로그인한 사용자의 정보 (Firestore에서 로드)
  /// null이면 로그인 안 됨 또는 로드 실패
  AppUser? _currentUser;

  /// 데이터 로딩 중인지 여부
  /// true: 로딩 중 (스피너 표시)
  /// false: 로딩 완료 (UI 표시)
  bool _isLoading = true;

  // ===== Getters (UI에서 접근) =====
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  /// 화면에 표시할 이름
  /// 유저 정보가 없으면 기본값 반환
  String get displayName => _currentUser?.name ?? '이름 없음';

  /// 화면에 표시할 이메일
  /// 유저 정보가 없으면 기본값 반환
  String get displayEmail => _currentUser?.email ?? '이메일 없음';

  // ===== SharedPreferences 로컬 데이터 =====
  /// 자주 가는 출발지 이름 (예: "East Halls")
  /// null이면 설정 안 됨
  String? favoriteDepartureName;

  /// 자주 가는 도착지 이름 (예: "Newark Airport")
  /// null이면 설정 안 됨
  String? favoriteArrivalName;

  /// 푸시 알림 활성화 여부
  /// 기본값: true (활성화)
  bool isPushEnabled = true;

  /// 선택된 언어 코드
  /// 'ko': 한국어, 'en': 영어
  /// 기본값: 'ko' (시스템 언어가 한국어면 한국어, 그 외는 영어로 fallback)
  String selectedLanguage = 'ko';

  // ================================================================
  // 초기화 메서드
  // ================================================================

  /// 설정 화면 진입 시 호출되는 초기화 메서드
  ///
  /// 동작:
  /// 1. 로딩 상태 true로 설정
  /// 2. Firestore에서 유저 정보 로드
  /// 3. SharedPreferences에서 로컬 설정 로드
  /// 4. 로딩 상태 false로 설정
  ///
  /// 사용 위치: settings_view.dart의 initState()
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    // Firestore와 SharedPreferences 동시에 로드 (병렬 처리로 속도 향상)
    await Future.wait([_loadUserFromFirestore(), _loadLocalSettings()]);

    _isLoading = false;
    notifyListeners();
  }

  /// Firestore에서 현재 로그인한 사용자의 정보를 가져오는 내부 메서드
  ///
  /// 동작:
  /// 1. Firebase Auth에서 현재 로그인한 사용자 확인
  /// 2. UserServices를 통해 Firestore에서 유저 문서 가져오기
  /// 3. _currentUser에 저장
  ///
  /// 사용 위치: initialize() 내부에서만 호출
  Future<void> _loadUserFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      _currentUser = await _userService.getUser(user.uid);
    } catch (e) {
      // 에러 발생 시 currentUser는 null로 유지
      // UI에서 "이름 없음" 표시됨
    }
  }

  /// SharedPreferences에서 로컬 설정을 읽어오는 내부 메서드
  ///
  /// 로드하는 데이터:
  /// - favorite_departure_name: 자주 가는 출발지 이름
  /// - favorite_arrival_name: 자주 가는 도착지 이름
  /// - push_notification_enabled: 푸시 알림 ON/OFF
  /// - selected_language: 언어 설정
  ///
  /// 사용 위치: initialize() 내부에서만 호출
  Future<void> _loadLocalSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      favoriteDepartureName = prefs.getString('favorite_departure_name');
      favoriteArrivalName = prefs.getString('favorite_arrival_name');
      isPushEnabled = prefs.getBool('push_notification_enabled') ?? true;
      
      // 시스템 언어 확인 (핸드폰 설정된 언어에 맞춰 자동 적용)
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final systemLanguageCode = systemLocale.languageCode;
      selectedLanguage = (systemLanguageCode == 'ko') ? 'ko' : 'en';
    } catch (e) {
      // 에러 발생 시 기본값 사용
    }
  }

  // ================================================================
  // 프로필 관련 메서드
  // ================================================================

  /// 사용자 프로필(이름, 이메일)을 업데이트하는 메서드
  ///
  /// 동작:
  /// 1. 새로운 AppUser 객체 생성
  /// 2. Firestore에 저장
  /// 3. 로컬 _currentUser 업데이트
  /// 4. 사용자에게 성공/실패 메시지 표시
  ///
  /// 사용 위치: profile_edit_page.dart의 저장 버튼
  ///
  /// @param name 새로운 이름
  /// @param email 새로운 이메일
  /// @param context SnackBar 표시용
  Future<void> updateProfile({
    required String name,
    required String email,
    required BuildContext context,
  }) async {
    if (_currentUser == null) return;

    try {
      final updatedUser = AppUser(
        uid: _currentUser!.uid,
        email: email,
        name: name,
        role: _currentUser!.role,
      );

      await _userService.saveUser(updatedUser);

      _currentUser = updatedUser;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("프로필이 업데이트되었습니다."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("프로필 업데이트 중 오류가 발생했습니다."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }





  // ================================================================
  // 알림 설정 관련 메서드
  // ================================================================

  /// 푸시 알림 ON/OFF를 토글하는 메서드
  ///
  /// 동작:
  /// 1. SharedPreferences에 새 값 저장
  /// 2. 로컬 변수 업데이트
  /// 3. UI 갱신
  ///
  /// 사용 위치: settings_view.dart의 푸시 알림 스위치
  ///
  /// @param value true: 알림 켜기, false: 알림 끄기
  Future<void> togglePushNotification(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('push_notification_enabled', value);

      isPushEnabled = value;
      notifyListeners();
    } catch (e) {
      // 저장 실패 시 로컬 변수는 이전 값 유지
    }
  }


  // ================================================================
  // 계정 관련 메서드
  // ================================================================

  /// 로그아웃 처리
  ///
  /// 동작:
  /// 1. Firebase Auth 로그아웃
  /// 2. 로그인 화면으로 이동 (기존 스택 모두 제거)
  ///
  /// 사용 위치: settings_view.dart의 로그아웃 버튼
  ///
  /// @param context 네비게이션용
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("로그아웃 중 오류가 발생했습니다."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  /// 회원 탈퇴 처리
  ///
  /// 동작:
  /// 1. Firestore 유저 문서 삭제
  /// 2. SharedPreferences 전체 삭제
  /// 3. Firebase Auth 계정 삭제
  ///
  /// ⚠️ 중요: Navigation은 이 메서드를 호출한 곳에서 처리!
  Future<void> deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // 1. Firestore 유저 문서 삭제
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // 2. SharedPreferences 전체 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 3. Firebase Auth 계정 삭제
      await user.delete();
    } catch (e) {
      debugPrint("회원 탈퇴 중 오류: $e");
      rethrow; // 에러를 다시 던져서 UI에서 처리할 수 있게
    }
  }
}
