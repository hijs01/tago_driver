import 'package:tago_driver/data/models/user.dart';

enum LoginError {
  userNotFound,
  wrongPassword,
  invalidEmail,
  weakPassword,
  emailInUse,
  cancelled,
  unknown,
}

class LoginResult {
  final bool success;
  final LoginError? error;
  final AppUser? user;

  const LoginResult({
    required this.success,
    this.error,
    this.user,
  });

  // 성공 결과
  factory LoginResult.ok(AppUser user) =>  LoginResult(success: true, user: user);

  // 실패 결과
  factory LoginResult.fail(LoginError error) =>
      LoginResult(success: false, error: error);
}