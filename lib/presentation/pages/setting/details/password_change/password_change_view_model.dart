import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// 비밀번호 변경 화면의 상태 관리 및 비즈니스 로직을 담당하는 ViewModel
///
/// 역할:
/// 1. 비밀번호 변경 폼 관리
/// 2. 유효성 검증
/// 3. Firebase Auth를 통한 비밀번호 변경
/// 4. 이메일로 비밀번호 재설정 링크 전송
class PasswordChangeViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ===== 폼 컨트롤러 =====
  /// 현재 비밀번호 입력 컨트롤러
  /// 사용 위치: password_change_view.dart의 현재 비밀번호 TextField
  final TextEditingController currentPasswordController =
      TextEditingController();

  /// 새 비밀번호 입력 컨트롤러
  /// 사용 위치: password_change_view.dart의 새 비밀번호 TextField
  final TextEditingController newPasswordController = TextEditingController();

  /// 새 비밀번호 확인 입력 컨트롤러
  /// 사용 위치: password_change_view.dart의 새 비밀번호 확인 TextField
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // ===== 상태 관리 =====
  /// 비밀번호 변경 중 여부
  bool _isChanging = false;

  bool get isChanging => _isChanging;

  /// 이메일 전송 중 여부
  bool _isSendingEmail = false;

  bool get isSendingEmail => _isSendingEmail;

  /// 비밀번호 표시/숨김 상태
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool get isCurrentPasswordVisible => _isCurrentPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  /// 변경 가능 여부 (모든 필드 입력되었는지)
  bool get canChange =>
      currentPasswordController.text.isNotEmpty &&
      newPasswordController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty;

  // ================================================================
  // 비밀번호 표시/숨김 토글
  // ================================================================

  /// 현재 비밀번호 표시/숨김 토글
  ///
  /// 사용 위치: password_change_view.dart의 현재 비밀번호 필드 아이콘
  void toggleCurrentPasswordVisibility() {
    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
    notifyListeners();
  }

  /// 새 비밀번호 표시/숨김 토글
  ///
  /// 사용 위치: password_change_view.dart의 새 비밀번호 필드 아이콘
  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible = !_isNewPasswordVisible;
    notifyListeners();
  }

  /// 새 비밀번호 확인 표시/숨김 토글
  ///
  /// 사용 위치: password_change_view.dart의 새 비밀번호 확인 필드 아이콘
  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  // ================================================================
  // 유효성 검증 메서드
  // ================================================================

  /// 새 비밀번호 유효성 검증
  ///
  /// 규칙:
  /// - 8자 이상
  /// - 영문, 숫자 포함
  ///
  /// @return 에러 메시지 (유효하면 null)
  String? validateNewPassword() {
    final password = newPasswordController.text;

    if (password.isEmpty) {
      return null; // 비어있으면 에러 표시 안 함
    }

    if (password.length < 8) {
      return "비밀번호는 8자 이상이어야 합니다.";
    }

    // 영문 포함 확인
    if (!password.contains(RegExp(r'[a-zA-Z]'))) {
      return "영문을 포함해야 합니다.";
    }

    // 숫자 포함 확인
    if (!password.contains(RegExp(r'[0-9]'))) {
      return "숫자를 포함해야 합니다.";
    }

    return null; // 유효함
  }

  /// 새 비밀번호 확인 유효성 검증
  ///
  /// 규칙:
  /// - 새 비밀번호와 일치해야 함
  ///
  /// @return 에러 메시지 (유효하면 null)
  String? validateConfirmPassword() {
    final confirm = confirmPasswordController.text;

    if (confirm.isEmpty) {
      return null; // 비어있으면 에러 표시 안 함
    }

    if (confirm != newPasswordController.text) {
      return "비밀번호가 일치하지 않습니다.";
    }

    return null; // 유효함
  }

  /// 전체 폼 유효성 검증
  ///
  /// @return true: 유효함, false: 유효하지 않음
  bool validateForm() {
    return currentPasswordController.text.isNotEmpty &&
        validateNewPassword() == null &&
        validateConfirmPassword() == null;
  }

  // ================================================================
  // 비밀번호 변경 메서드
  // ================================================================

  /// 비밀번호 변경
  ///
  /// 동작 순서:
  /// 1. 폼 유효성 검증
  /// 2. 현재 비밀번호로 재인증 (Firebase 요구사항)
  /// 3. 새 비밀번호로 업데이트
  /// 4. 성공 메시지 표시 & 화면 닫기
  ///
  /// 에러 처리:
  /// - 현재 비밀번호 틀림: 에러 메시지
  /// - 네트워크 에러: 에러 메시지
  /// - 기타 에러: 에러 메시지
  ///
  /// 사용 위치: password_change_view.dart의 변경 버튼
  ///
  /// @param context SnackBar 및 Navigation용
  Future<void> changePassword(BuildContext context) async {
    // 1단계: 유효성 검증
    if (!validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("입력값을 확인해주세요."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("로그인 정보가 없습니다."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 2단계: 로딩 시작
    _isChanging = true;
    notifyListeners();

    try {
      // 3단계: 현재 비밀번호로 재인증
      // Firebase는 보안상 비밀번호 변경 전 재인증 요구
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      // 4단계: 새 비밀번호로 업데이트
      await user.updatePassword(newPasswordController.text);

      // 5단계: 로딩 종료
      _isChanging = false;
      notifyListeners();

      // 6단계: 성공 처리
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("비밀번호가 변경되었습니다."),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      _isChanging = false;
      notifyListeners();

      String errorMessage;

      // Firebase 에러 코드별 메시지
      switch (e.code) {
        case 'wrong-password':
          errorMessage = "현재 비밀번호가 올바르지 않습니다.";
          break;
        case 'weak-password':
          errorMessage = "새 비밀번호가 너무 약합니다.";
          break;
        case 'requires-recent-login':
          errorMessage = "보안을 위해 다시 로그인해주세요.";
          break;
        default:
          errorMessage = "비밀번호 변경 중 오류가 발생했습니다.";
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      _isChanging = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("비밀번호 변경 중 오류가 발생했습니다."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // ================================================================
  // 이메일로 비밀번호 재설정 링크 전송
  // ================================================================

  /// 이메일로 비밀번호 재설정 링크 전송
  ///
  /// 동작:
  /// 1. Firebase Auth에 비밀번호 재설정 이메일 요청
  /// 2. 이메일 전송 완료 메시지 표시
  ///
  /// 장점:
  /// - 현재 비밀번호 몰라도 됨
  /// - 이메일 확인 후 안전하게 재설정
  ///
  /// 사용 위치: password_change_view.dart의 "이메일로 재설정" 버튼
  ///
  /// @param context SnackBar용
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("로그인 정보가 없습니다."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    _isSendingEmail = true;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: user.email!);

      _isSendingEmail = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${user.email}로 비밀번호 재설정 링크를 보냈습니다."),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      _isSendingEmail = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("이메일 전송 중 오류가 발생했습니다."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // ================================================================
  // 리소스 정리
  // ================================================================

  /// ViewModel dispose 시 호출
  ///
  /// 동작: TextField 컨트롤러 정리 (메모리 누수 방지)
  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
