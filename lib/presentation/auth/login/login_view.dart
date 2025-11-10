import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tago_driver/data/models/login_data.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailCtrl = TextEditingController();
  final pwCtrl = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailCtrl.dispose();
    pwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // 배경 색상 보간
          final bgColor1 =
              Color.lerp(
                Color(0xFF1a1a2e),
                Color(0xFF16213e),
                _animation.value,
              )!;
          final bgColor2 =
              Color.lerp(
                Color(0xFF16213e),
                Color(0xFF0f3460),
                _animation.value,
              )!;
          final bgColor3 =
              Color.lerp(
                Color(0xFF0f3460),
                Color(0xFF1a1a3e),
                _animation.value,
              )!;

          // 장식 원 색상 보간
          final circleColor1 =
              Color.lerp(Colors.blue, Colors.purple, _animation.value)!;
          final circleColor2 =
              Color.lerp(Colors.purple, Colors.pink, _animation.value)!;

          return Stack(
            children: [
              // 배경 - 전체 화면을 차지
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [bgColor1, bgColor2, bgColor3],
                    ),
                  ),
                ),
              ),

              // 배경 장식 원들
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        circleColor1.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -150,
                left: -100,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        circleColor2.withOpacity(0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 메인 콘텐츠 - SafeArea 적용
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 타이틀 영역
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "TAGO Driver",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -1,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "택시 탑승자를 찾아보세요",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white60,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 40),

                        // Glassmorphic 로그인 카드
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // 이메일 입력
                                  _buildGlassInput(
                                    label: "이메일",
                                    hint: "you@psu.edu",
                                    controller: emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    icon: Icons.email_outlined,
                                  ),
                                  SizedBox(height: 20),

                                  // 비밀번호 입력
                                  _buildGlassInput(
                                    label: "비밀번호",
                                    hint: "••••••••",
                                    controller: pwCtrl,
                                    obscure: true,
                                    icon: Icons.lock_outline,
                                  ),
                                  SizedBox(height: 32),

                                  // 로그인 버튼
                                  _buildAnimatedGlassButton(
                                    text: vm.isLoading ? "로그인 중..." : "로그인",
                                    isLoading: vm.isLoading,
                                    onPressed: () => _handleLogin(context),
                                  ),

                                  SizedBox(height: 16),

                                  // 회원가입 버튼
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/signup');
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text(
                                      "아직 계정이 없나요? 회원가입하기",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 32),

                        // 버전 정보
                        Text(
                          "tago v0.1 preview",
                          style: TextStyle(fontSize: 12, color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGlassInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType? keyboardType,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller,
                obscureText: obscure,
                keyboardType: keyboardType,
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 16),
                  prefixIcon: Icon(icon, color: Colors.white60, size: 22),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedGlassButton({
    required String text,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // 부드러운 색상 보간
        final color1 =
            Color.lerp(Color(0xFF3b82f6), Color(0xFF8b5cf6), _animation.value)!;
        final color2 =
            Color.lerp(Color(0xFF8b5cf6), Color(0xFFec4899), _animation.value)!;

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                gradient:
                    isLoading
                        ? LinearGradient(
                          colors: [
                            Colors.grey.withOpacity(0.4),
                            Colors.grey.withOpacity(0.3),
                          ],
                        )
                        : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color1.withOpacity(0.8),
                            color2.withOpacity(0.8),
                          ],
                        ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow:
                    isLoading
                        ? []
                        : [
                          BoxShadow(
                            color: color1.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isLoading ? null : onPressed,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child:
                        isLoading
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final vm = context.read<LoginViewModel>();
    final result = await vm.login(emailCtrl.text.trim(), pwCtrl.text.trim());

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
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }
}
