import 'package:flutter/material.dart';
import 'package:tago_driver/data/models/user.dart';
import 'package:tago_driver/data/services/user_services.dart';

/// 프로필 수정 화면의 상태 관리 및 비즈니스 로직을 담당하는 ViewModel
///
/// 역할:
/// 1. 현재 프로필 정보 관리 (이름, 이메일)
/// 2. 입력값 유효성 검증
/// 3. Firestore에 변경사항 저장
/// 4. 로딩 상태 관리
class ProfileEditViewModel extends ChangeNotifier {
  final UserServices _userService = UserServices();

  // ===== 현재 유저 정보 =====
  /// 수정 중인 유저 정보
  /// settings_view에서 전달받음
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  // ===== 입력 폼 컨트롤러 =====
  /// 이름 입력 컨트롤러
  /// 사용 위치: profile_edit_view.dart의 이름 TextField
  final TextEditingController nameController = TextEditingController();

  /// 이메일 입력 컨트롤러
  /// 사용 위치: profile_edit_view.dart의 이메일 TextField
  final TextEditingController emailController = TextEditingController();

  // ===== 상태 관리 =====
  /// 저장 중 여부
  /// true: 로딩 인디케이터 표시
  /// false: 일반 버튼 표시
  bool _isSaving = false;

  bool get isSaving => _isSaving;

  /// 변경사항이 있는지 여부
  /// true: 저장 버튼 활성화
  /// false: 저장 버튼 비활성화
  bool get hasChanges {
    if (_currentUser == null) return false;

    return nameController.text.trim() != _currentUser!.name ||
        emailController.text.trim() != _currentUser!.email;
  }

  // ================================================================
  // 초기화 메서드
  // ================================================================

  /// 프로필 수정 화면 진입 시 호출되는 초기화 메서드
  ///
  /// 동작:
  /// 1. 전달받은 유저 정보를 _currentUser에 저장
  /// 2. TextField 컨트롤러에 현재 값 설정
  ///
  /// 사용 위치: profile_edit_view.dart의 initState()
  ///
  /// @param user 현재 로그인한 유저 정보 (settings_view에서 전달)
  void initialize(AppUser user) {
    _currentUser = user;
    nameController.text = user.name;
    emailController.text = user.email;
    notifyListeners();
  }

  // ================================================================
  // 유효성 검증 메서드
  // ================================================================

  /// 이름 유효성 검증
  ///
  /// 규칙:
  /// - 비어있으면 안 됨
  /// - 공백만 있으면 안 됨
  /// - 2자 이상이어야 함
  ///
  /// @return 에러 메시지 (유효하면 null)
  String? validateName() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      return "이름을 입력해주세요.";
    }

    if (name.length < 2) {
      return "이름은 2자 이상이어야 합니다.";
    }

    return null; // 유효함
  }

  /// 이메일 유효성 검증
  ///
  /// 규칙:
  /// - 비어있으면 안 됨
  /// - 이메일 형식이어야 함 (xxx@xxx.xxx)
  ///
  /// @return 에러 메시지 (유효하면 null)
  String? validateEmail() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      return "이메일을 입력해주세요.";
    }

    // 간단한 이메일 정규식
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return "올바른 이메일 형식이 아닙니다.";
    }

    return null; // 유효함
  }

  /// 전체 폼 유효성 검증
  ///
  /// 동작:
  /// - 이름과 이메일 모두 유효해야 true
  ///
  /// @return true: 유효함, false: 유효하지 않음
  bool validateForm() {
    return validateName() == null && validateEmail() == null;
  }

  // ================================================================
  // 저장 메서드
  // ================================================================

  /// 프로필 변경사항을 Firestore에 저장하는 메서드
  ///
  /// 동작 순서:
  /// 1. 폼 유효성 검증
  /// 2. 로딩 상태 시작 (isSaving = true)
  /// 3. 새로운 AppUser 객체 생성
  /// 4. Firestore에 저장
  /// 5. 로딩 상태 종료
  /// 6. 성공 메시지 표시 & 화면 닫기
  ///
  /// 에러 처리:
  /// - 유효성 검증 실패: 에러 메시지 표시
  /// - Firestore 저장 실패: 에러 메시지 표시
  ///
  /// 사용 위치: profile_edit_view.dart의 저장 버튼
  ///
  /// @param context SnackBar 및 Navigation용
  Future<void> saveProfile(BuildContext context) async {
    // 1단계: 유효성 검증
    if (!validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validateName() ?? validateEmail() ?? "입력값을 확인해주세요."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_currentUser == null) return;

    // 2단계: 로딩 시작
    _isSaving = true;
    notifyListeners();

    try {
      // 3단계: 업데이트된 유저 객체 생성
      final updatedUser = AppUser(
        uid: _currentUser!.uid,
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        role: _currentUser!.role,
      );

      // 4단계: Firestore에 저장
      await _userService.saveUser(updatedUser);

      // 5단계: 로딩 종료
      _isSaving = false;
      notifyListeners();

      // 6단계: 성공 처리
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("프로필이 업데이트되었습니다."),
            backgroundColor: Colors.green,
          ),
        );

        // 화면 닫고 설정 화면으로 돌아가기
        Navigator.pop(context, updatedUser); // 업데이트된 유저 정보 반환
      }
    } catch (e) {
      // 에러 처리
      _isSaving = false;
      notifyListeners();

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
  // 리소스 정리
  // ================================================================

  /// ViewModel이 dispose될 때 호출
  ///
  /// 동작:
  /// - TextField 컨트롤러들 dispose (메모리 누수 방지)
  ///
  /// 사용 위치: profile_edit_view.dart의 dispose()
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
