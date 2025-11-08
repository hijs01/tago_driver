import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tago_driver/data/models/login_data.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/presentation/common/primaryButton.dart';
import 'package:tago_driver/presentation/common/textInputfield.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';

class LoginScreen extends StatefulWidget {
  final Color? titleColor;
  final Color? subtitleColor;

  const LoginScreen({
    super.key,
    this.titleColor = Colors.white,
    this.subtitleColor = Colors.white70,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final pwCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    pwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return AppScaffold(
      // 공통 테마
      backgroundColor: Colors.black,
      scrollable: true,

      // ✅ AppBar 추가 (Scaffold처럼 직접 넘김)
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "TAGO Driver 로그인",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      // ✅ Footer (하단 버전 정보)
      footer: Text(
        "tago v0.1 preview",
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),

      // ✅ Body (실제 화면 내용)
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 상단 설명 텍스트
          Text(
            "택시 탑승자를 찾아보세요.",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "학교 → 공항 / 공항 → 학교\n 정보를 보며 쉽고 안전하게 운행하세요.",
            style: TextStyle(
              fontSize: 14,
              color: widget.subtitleColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // 이메일 입력
          Textinputfield(
            label: "이메일",
            hint: "you@psu.edu",
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // 비밀번호 입력
          Textinputfield(
            label: "비밀번호",
            hint: "abc1234",
            controller: pwCtrl,
            obscure: true,
          ),
          const SizedBox(height: 24),

          // 로그인 버튼
          PrimaryButton(
            text: vm.isLoading ? "로그인 중..." : "로그인",
            disabled: vm.isLoading,
            onPressed: () async {
              final vm = context.read<LoginViewModel>();
              final result = await vm.login(
                emailCtrl.text.trim(),
                pwCtrl.text.trim(),
              );

              if (!mounted) return;

              if (result.success) {
                Navigator.pushReplacementNamed(context, '/main');
              } else {
                String message = "로그인에 실패했습니다.";

                switch (result.error ?? LoginError.unknown) {
                  case LoginError.userNotFound:
                    message = "해당 이메일로 가입된 계정을 찾을 수 없습니다.";
                    break;
                  case LoginError.wrongPassword:
                    message = "비밀번호가 올바르지 않습니다.";
                    break;
                  case LoginError.invalidEmail:
                    message = "이메일 형식이 올바르지 않습니다.";
                    break;
                  case LoginError.cancelled:
                    message = "로그인을 취소했어요.";
                    break;
                  default:
                    message = "알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요";
                    break;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          ),
          SizedBox(height: 16,),

          // 회원가입 이동 버튼
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text(
                "아직 계정 없나요? 회원가입 하기 >",
                style: TextStyle(
                  color: widget.subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
