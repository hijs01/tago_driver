import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/setting/details/password_change/password_change_view_model.dart';

/// 비밀번호 변경 화면
///
/// 기능:
/// 1. 현재 비밀번호 확인
/// 2. 새 비밀번호 입력
/// 3. 새 비밀번호 확인
/// 4. 실시간 유효성 검증
/// 5. 비밀번호 변경 실행
/// 6. (대안) 이메일로 재설정 링크 받기
///
/// 사용 위치: settings_view.dart의 "비밀번호 변경"
class PasswordChangeView extends StatefulWidget {
  const PasswordChangeView({super.key});

  @override
  State<PasswordChangeView> createState() => _PasswordChangeViewState();
}

class _PasswordChangeViewState extends State<PasswordChangeView> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PasswordChangeViewModel>();

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "비밀번호 변경",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      scrollable: true,
      body: _buildContent(context, vm),
    );
  }

  /// 화면 콘텐츠
  ///
  /// 구성:
  /// 1. 안내 문구
  /// 2. 현재 비밀번호 입력
  /// 3. 새 비밀번호 입력
  /// 4. 새 비밀번호 확인 입력
  /// 5. 변경 버튼
  /// 6. 이메일로 재설정 버튼
  Widget _buildContent(BuildContext context, PasswordChangeViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 안내 문구
        _buildInfoBox(),

        const SizedBox(height: 32),

        // 현재 비밀번호
        _buildCurrentPasswordField(vm),

        const SizedBox(height: 20),

        // 새 비밀번호
        _buildNewPasswordField(vm),

        const SizedBox(height: 20),

        // 새 비밀번호 확인
        _buildConfirmPasswordField(vm),

        const SizedBox(height: 32),

        // 비밀번호 규칙 안내
        _buildPasswordRules(),

        const SizedBox(height: 32),

        // 변경 버튼
        _buildChangeButton(context, vm),

        const SizedBox(height: 16),

        // 구분선
        _buildDivider(),

        const SizedBox(height: 16),

        // 이메일로 재설정
        _buildResetByEmailButton(context, vm),

        const SizedBox(height: 40),
      ],
    );
  }

  /// 안내 문구
  Widget _buildInfoBox() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.lock_outline, color: Colors.blueAccent, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "보안을 위해 정기적으로 비밀번호를 변경하세요.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 현재 비밀번호 입력 필드
  Widget _buildCurrentPasswordField(PasswordChangeViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "현재 비밀번호",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        TextField(
          controller: vm.currentPasswordController,
          obscureText: !vm.isCurrentPasswordVisible,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: "현재 비밀번호를 입력하세요",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.white.withOpacity(0.5),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                vm.isCurrentPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.white.withOpacity(0.5),
              ),
              onPressed: vm.toggleCurrentPasswordVisibility,
            ),
          ),
          onChanged: (_) => vm.notifyListeners(),
        ),
      ],
    );
  }

  /// 새 비밀번호 입력 필드
  Widget _buildNewPasswordField(PasswordChangeViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "새 비밀번호",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        TextField(
          controller: vm.newPasswordController,
          obscureText: !vm.isNewPasswordVisible,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: "새 비밀번호를 입력하세요",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            prefixIcon: Icon(
              Icons.lock_reset,
              color: Colors.white.withOpacity(0.5),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                vm.isNewPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.white.withOpacity(0.5),
              ),
              onPressed: vm.toggleNewPasswordVisibility,
            ),
            errorText:
                vm.newPasswordController.text.isNotEmpty
                    ? vm.validateNewPassword()
                    : null,
          ),
          onChanged: (_) => vm.notifyListeners(),
        ),
      ],
    );
  }

  /// 새 비밀번호 확인 입력 필드
  Widget _buildConfirmPasswordField(PasswordChangeViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "새 비밀번호 확인",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        TextField(
          controller: vm.confirmPasswordController,
          obscureText: !vm.isConfirmPasswordVisible,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: "새 비밀번호를 다시 입력하세요",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            prefixIcon: Icon(
              Icons.check_circle_outline,
              color: Colors.white.withOpacity(0.5),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                vm.isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.white.withOpacity(0.5),
              ),
              onPressed: vm.toggleConfirmPasswordVisibility,
            ),
            errorText:
                vm.confirmPasswordController.text.isNotEmpty
                    ? vm.validateConfirmPassword()
                    : null,
          ),
          onChanged: (_) => vm.notifyListeners(),
        ),
      ],
    );
  }

  /// 비밀번호 규칙 안내
  Widget _buildPasswordRules() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "비밀번호 규칙",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildRuleItem("• 8자 이상"),
              _buildRuleItem("• 영문 포함"),
              _buildRuleItem("• 숫자 포함"),
            ],
          ),
        ),
      ),
    );
  }

  /// 규칙 항목
  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
      ),
    );
  }

  /// 변경 버튼
  Widget _buildChangeButton(BuildContext context, PasswordChangeViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
            vm.canChange && !vm.isChanging
                ? () => vm.changePassword(context)
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          disabledBackgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child:
            vm.isChanging
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : const Text(
                  "비밀번호 변경",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }

  /// 구분선
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white12)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "또는",
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ),
        Expanded(child: Divider(color: Colors.white12)),
      ],
    );
  }

  /// 이메일로 재설정 버튼
  Widget _buildResetByEmailButton(
    BuildContext context,
    PasswordChangeViewModel vm,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed:
            !vm.isSendingEmail
                ? () => vm.sendPasswordResetEmail(context)
                : null,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.blueAccent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child:
            vm.isSendingEmail
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.blueAccent,
                  ),
                )
                : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text(
                      "이메일로 재설정 링크 받기",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
