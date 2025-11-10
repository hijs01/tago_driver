import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:tago_driver/data/models/user.dart';
import 'package:tago_driver/data/services/user_services.dart';
import 'package:tago_driver/data/models/login_data.dart'; // LoginResult / LoginError 정의된 파일

import 'package:tago_driver/data/services/notification_service.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserServices _userServices = UserServices();

  AppUser? currentUser; // 로그인한 유저 정보

  void setCurrentUser(AppUser user) {
    currentUser = user;
    notifyListeners();
  }

  /// Firestore에서 현재 로그인한 사용자의 정보를 가져오는 메서드
  Future<void> loadUserFromFirestore() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final appUser = await _userServices.getUser(user.uid);
      if (appUser != null) {
        currentUser = appUser;
        notifyListeners();
      }
    } catch (e) {
      // debugPrint("사용자 정보 로드 실패: $e");
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (_) {}
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    currentUser = null;
    notifyListeners();
  }

  /// 이메일/비밀번호 로그인
  Future<LoginResult> login(String email, String pw) async {
    if (email.isEmpty || pw.isEmpty) {
      return LoginResult.fail(LoginError.invalidEmail);
    }

    isLoading = true;
    notifyListeners();

    try {
      // 약간의 로딩 느낌 주고 싶으면 남겨두고, 아니면 지워도 됨
      await Future.delayed(const Duration(milliseconds: 300));

      // 1) Firebase Auth 로그인
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pw,
      );
      final user = credential.user;

      if (user == null) {
        return LoginResult.fail(LoginError.unknown);
      }

      final uid = user.uid;

      // 2) Firestore에서 유저 정보 가져오기
      AppUser? appUser = await _userServices.getUser(uid);

      // 3) 없으면 새로 만든 뒤 저장 (최초 로그인)
      if (appUser == null) {
        appUser = AppUser(
          uid: uid,
          email: user.email ?? email,
          name: '',
          role: 'driver',
        );
        await _userServices.saveUser(appUser);
      }

      // 4) ViewModel 메모리에 currentUser 보관
      currentUser = appUser;

      await _saveFCMToken(appUser.uid);

      return LoginResult.ok(appUser);
    } on FirebaseAuthException catch (e) {
      // debugPrint("FirebaseAuthException: ${e.code} / ${e.message}");

      // Firebase 에러코드를 우리 쪽 LoginError로 매핑
      switch (e.code) {
        case 'user-not-found':
          return LoginResult.fail(LoginError.userNotFound);
        case 'wrong-password':
          return LoginResult.fail(LoginError.wrongPassword);
        case 'invalid-email':
          return LoginResult.fail(LoginError.invalidEmail);
        default:
          return LoginResult.fail(LoginError.unknown);
      }
    } catch (e) {
      // debugPrint("Unknown login error: $e");
      return LoginResult.fail(LoginError.unknown);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // FCM 토큰 저장 헬퍼
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> _saveFCMToken(String userId) async {
    try {
      // print('📱 로그인 성공 - FCM 토큰 저장 시작');
      final notificationService = NotificationService();
      final token = await notificationService.getFCMToken(userId);

      if (token != null) {
        notificationService.listenToTokenRefresh(userId);
        // print('✅ 로그인: FCM 토큰 저장 완료');
      } else {
        // print('⚠️ 로그인: FCM 토큰이 null');
      }
    } catch (e, stackTrace) {
      // print('❌ 로그인: FCM 토큰 저장 실패: $e');
      // print('스택 트레이스: $stackTrace');
      // 로그인은 성공했으므로 에러를 throw하지 않음
    }
  }
}
