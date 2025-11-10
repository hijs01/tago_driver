import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tago_driver/presentation/auth/signUp/signUp_view_model.dart';
import 'package:tago_driver/data/models/logIn_data.dart'; // LoginError, LoginResult

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView>
    with SingleTickerProviderStateMixin {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final pwCtrl = TextEditingController();
  final pwConfirmCtrl = TextEditingController();
  final companyCodeCtrl = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  // 허용된 회사 확인 코드 목록
  final List<String> validCompanyCodes = ['admin123', 'psu2024', 'tago999'];

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
    nameCtrl.dispose();
    emailCtrl.dispose();
    companyCtrl.dispose();
    pwCtrl.dispose();
    pwConfirmCtrl.dispose();
    companyCodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SignUpViewModel>();

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
                child: Column(
                  children: [
                    // 뒤로가기 버튼
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 스크롤 가능한 컨텐츠
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            SizedBox(height: 12),

                            // 타이틀 영역 - 중앙 정렬
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "회원가입",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "TAGO 타고가실?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Glassmorphic 회원가입 카드
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // 이름 입력
                                      _buildGlassInput(
                                        label: "이름",
                                        hint: "예: 홍길동",
                                        controller: nameCtrl,
                                        icon: Icons.person_outline,
                                      ),
                                      SizedBox(height: 12),

                                      // 이메일 입력
                                      _buildGlassInput(
                                        label: "이메일",
                                        hint: "you@psu.edu",
                                        controller: emailCtrl,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        icon: Icons.email_outlined,
                                      ),
                                      SizedBox(height: 12),

                                      // 회사 이름 입력
                                      _buildGlassInput(
                                        label: "회사 이름",
                                        hint: "PSU Taxi",
                                        controller: companyCtrl,
                                        icon: Icons.business_outlined,
                                      ),
                                      SizedBox(height: 12),

                                      // 비밀번호 입력
                                      _buildGlassInput(
                                        label: "비밀번호",
                                        hint: "••••••••",
                                        controller: pwCtrl,
                                        obscure: true,
                                        icon: Icons.lock_outline,
                                      ),
                                      SizedBox(height: 12),

                                      // 비밀번호 확인 입력
                                      _buildGlassInput(
                                        label: "비밀번호 확인",
                                        hint: "••••••••",
                                        controller: pwConfirmCtrl,
                                        obscure: true,
                                        icon: Icons.lock_outline,
                                      ),
                                      SizedBox(height: 12),

                                      // 회사 확인 코드 입력
                                      _buildGlassInput(
                                        label: "회사 확인 코드",
                                        hint: "예: admin123",
                                        controller: companyCodeCtrl,
                                        icon: Icons.verified_user_outlined,
                                      ),
                                      SizedBox(height: 20),

                                      // 회원가입 버튼
                                      _buildAnimatedGlassButton(
                                        text: vm.isLoading ? "가입 중..." : "회원가입",
                                        isLoading: vm.isLoading,
                                        onPressed: () => _handleSignUp(context),
                                      ),

                                      SizedBox(height: 12),

                                      // 로그인 버튼
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                        ),
                                        child: Text(
                                          "이미 계정이 있나요? 로그인하기",
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

                            SizedBox(height: 16),

                            // 버전 정보
                            Text(
                              "tago v0.1 preview",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white38,
                              ),
                            ),

                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller,
                obscureText: obscure,
                keyboardType: keyboardType,
                style: TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 15),
                  prefixIcon: Icon(icon, color: Colors.white60, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
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
          borderRadius: BorderRadius.circular(14),
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
                borderRadius: BorderRadius.circular(14),
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
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    alignment: Alignment.center,
                    child:
                        isLoading
                            ? SizedBox(
                              width: 18,
                              height: 18,
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
                                fontSize: 15,
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

  Future<void> _handleSignUp(BuildContext context) async {
    final vm = context.read<SignUpViewModel>();

    // 1) 비밀번호 일치 여부 체크
    if (pwCtrl.text.trim() != pwConfirmCtrl.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("비밀번호가 서로 일치하지 않습니다."),
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    // 2) 회사 확인 코드 검증
    if (!validCompanyCodes.contains(companyCodeCtrl.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("유효하지 않은 회사 확인 코드입니다."),
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    // 3) 실제 회원가입 호출
    final result = await vm.signUp(
      nameCtrl.text.trim(),
      companyCtrl.text.trim(),
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

      switch (result.error ?? LoginError.unknown) {
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
          message = "알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.";
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
