import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tago_driver/presentation/auth/signUp/signUp_view_model.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/common/primaryButton.dart';
import 'package:tago_driver/presentation/common/textInputfield.dart';
import 'package:tago_driver/data/models/logIn_data.dart'; // LoginError, LoginResult

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final pwCtrl = TextEditingController();
  final pwConfirmCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    pwCtrl.dispose();
    pwConfirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 상태 등 변화를 반영하기 위해 watch 사용
    final vm = context.watch<SignUpViewModel>();

    return AppScaffold(
      backgroundColor: Colors.black,
      scrollable: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title:  Text(
            "TAGO 계정을 만들어볼까요?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ✅ 이름 입력
          Textinputfield(
            label: "이름",
            hint: "예: 홍길동",
            controller: nameCtrl,
          ),
          const SizedBox(height: 16),

          // 이메일
          Textinputfield(
            label: "이메일",
            hint: "abc123@gmail.com",
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // 비밀번호
          Textinputfield(
            label: "비밀번호",
            hint: "abc1234",
            controller: pwCtrl,
            obscure: true,
          ),
          const SizedBox(height: 16),

          // 비밀번호 확인
          Textinputfield(
            label: "비밀번호 확인",
            hint: "abc1234",
            controller: pwConfirmCtrl,
            obscure: true,
          ),
          const SizedBox(height: 24),

          // 회원가입 버튼
          PrimaryButton(
            text: vm.isLoading ? "가입 중..." : "회원가입",
            disabled: vm.isLoading,
            onPressed: () async {
              // 1) 비밀번호 일치 여부 체크
              if (pwCtrl.text.trim() != pwConfirmCtrl.text.trim()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("비밀번호가 서로 일치하지 않습니다."),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }

              // 2) 실제 회원가입 호출
              final result = await vm.signUp(
                nameCtrl.text.trim(),
                emailCtrl.text.trim(),
                pwCtrl.text.trim(),
              );

              if (!mounted) return;

              if (result.success) {
                // 가입 성공 시 메인으로 이동
                Navigator.pushReplacementNamed(context, '/main');
              } else {
                // 에러 타입에 따라 메시지 분기
                String message = "회원가입에 실패했습니다.";

                switch (result.error) {
                  case LoginError.invalidEmail:
                    message = "이메일 형식이 올바르지 않습니다.";
                    break;
                  case LoginError.weakPassword:
                    message = "비밀번호가 너무 약합니다. 6자 이상으로 설정해주세요.";
                    break;
                  case LoginError.emailInUse:
                    message = "이미 사용 중인 이메일입니다.";
                    break;
                  default:
                    message =
                        "알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.";
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
        ],
      ),
    );
  }
}