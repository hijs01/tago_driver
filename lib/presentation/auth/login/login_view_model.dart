import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:tago_driver/data/models/user.dart';
import 'package:tago_driver/data/services/user_services.dart';
import 'package:tago_driver/data/models/logIn_data.dart'; // LoginResult / LoginError 정의된 파일

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

      return LoginResult.ok(appUser);
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.code} / ${e.message}");

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
      debugPrint("Unknown login error: $e");
      return LoginResult.fail(LoginError.unknown);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 구글 로그인
  Future<LoginResult> loginWithGoogle() async {
    isLoading = true;
    notifyListeners();

    try {
      // 1) 구글 계정 선택
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // 유저가 로그인 창 닫고 취소한 경우
      if (googleUser == null) {
        return LoginResult.fail(LoginError.unknown);
      }

      // 2) 인증 토큰 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3) Firebase credential 생성
      final oauthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4) Firebase Auth로 로그인
      final userCredential =
          await _auth.signInWithCredential(oauthCredential);
      final user = userCredential.user;

      if (user == null) {
        return LoginResult.fail(LoginError.unknown);
      }

      // 5) Firestore에 유저 정보 동기화 (이메일 로그인과 동일한 패턴)
      AppUser? appUser = await _userServices.getUser(user.uid);
      if (appUser == null) {
        appUser = AppUser(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          role: 'driver',
        );
        await _userServices.saveUser(appUser);
      }

      currentUser = appUser;

      return LoginResult.ok(appUser);
    } on FirebaseAuthException catch (e) {
      debugPrint("Google FirebaseAuthException: ${e.code} / ${e.message}");
      // 필요하면 여기서도 코드별로 매핑 가능
      return LoginResult.fail(LoginError.unknown);
    } catch (e, st) {
      debugPrint("Google login error: $e");
      debugPrint("Stack: $st");
      return LoginResult.fail(LoginError.unknown);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}