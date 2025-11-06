import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tago_driver/data/models/logIn_data.dart';
import 'package:tago_driver/data/models/user.dart';
import 'package:tago_driver/data/services/user_services.dart';



class SignUpViewModel extends ChangeNotifier {
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserServices _userServices = UserServices();

  AppUser? currentUser;

  //1. 이메일 비밀번호 회원가입

  Future<LoginResult> signUp (String name, String email, String pw) async {
    if (name.isEmpty || email.isEmpty || pw.isEmpty) {
      return LoginResult.fail(LoginError.invalidEmail);
    }
    isLoading = true;
    notifyListeners();

    try{
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: pw);
      final user = credential.user;

      if (user == null) {
        return LoginResult.fail(LoginError.unknown);
      }

      final uid = user.uid;
      final appUser = AppUser(uid: uid, email: email, name: name, role: 'driver');
      await _userServices.saveUser(appUser);

      currentUser = appUser;

      return LoginResult.ok(appUser);
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.code} / ${e.message}");
      switch (e.code) {
        case 'weak-password':
          return LoginResult.fail(LoginError.weakPassword);
        case 'email-already-in-use':
          return LoginResult.fail(LoginError.emailInUse);
        default:
          return LoginResult.fail(LoginError.unknown);
      }
    }catch (e) {
      debugPrint("Unknown sign up error: $e");
      return LoginResult.fail(LoginError.unknown);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}