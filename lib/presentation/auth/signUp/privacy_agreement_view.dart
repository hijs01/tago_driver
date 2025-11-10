import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tago_driver/presentation/auth/signUp/signUp_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/privacy/privacy_view.dart';

/// Privacy Policy Agreement Screen
///
/// Screen for agreeing to the privacy policy before sign up
/// Can only proceed to sign up form after agreement
class PrivacyAgreementView extends StatefulWidget {
  const PrivacyAgreementView({super.key});

  @override
  State<PrivacyAgreementView> createState() => _PrivacyAgreementViewState();
}

class _PrivacyAgreementViewState extends State<PrivacyAgreementView>
    with SingleTickerProviderStateMixin {
  bool _hasAgreed = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // 배경 색상 보간
          final bgColor1 = Color.lerp(
            const Color(0xFF1a1a2e),
            const Color(0xFF16213e),
            _animation.value,
          )!;
          final bgColor2 = Color.lerp(
            const Color(0xFF16213e),
            const Color(0xFF0f3460),
            _animation.value,
          )!;
          final bgColor3 = Color.lerp(
            const Color(0xFF0f3460),
            const Color(0xFF1a1a3e),
            _animation.value,
          )!;

          // 장식 원 색상 보간
          final circleColor1 =
              Color.lerp(Colors.blue, Colors.purple, _animation.value)!;
          final circleColor2 =
              Color.lerp(Colors.purple, Colors.pink, _animation.value)!;

          return Stack(
            children: [
              // 배경
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

              // 메인 콘텐츠
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                  child: Column(
                    children: [
                      // 타이틀 영역
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.privacy_tip_outlined,
                            color: Colors.white,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Privacy Policy",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Agreement is required to sign up",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white60,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // 개인정보 처리방침 요약 카드
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(24),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Key Points",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildSummaryItem(
                                  icon: Icons.info_outline,
                                  text: "Personal information is collected to provide services",
                                ),
                                const SizedBox(height: 12),
                                _buildSummaryItem(
                                  icon: Icons.security,
                                  text: "Collected information is securely protected",
                                ),
                                const SizedBox(height: 12),
                                _buildSummaryItem(
                                  icon: Icons.delete_outline,
                                  text: "Information is deleted immediately upon account deletion",
                                ),
                                const SizedBox(height: 12),
                                _buildSummaryItem(
                                  icon: Icons.rule,
                                  text: "We comply with relevant laws and regulations",
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PrivacyView(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "View Full Policy",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.blueAccent,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 동의 체크박스
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _hasAgreed = !_hasAgreed;
                                    });
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _hasAgreed
                                          ? const Color(0xFF3b82f6)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: _hasAgreed
                                            ? const Color(0xFF3b82f6)
                                            : Colors.white.withOpacity(0.5),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: _hasAgreed
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _hasAgreed = !_hasAgreed;
                                      });
                                    },
                                    child: Text(
                                      "I agree to the Privacy Policy\n(Required)",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Agree and Continue button
                      _buildAnimatedGlassButton(
                        text: "Agree and Continue",
                        isEnabled: _hasAgreed,
                        onPressed: _hasAgreed
                            ? () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpView(),
                                  ),
                                );
                              }
                            : null,
                      ),

                      const SizedBox(height: 16),

                      // Back button
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Back",
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
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.blueAccent,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedGlassButton({
    required String text,
    required bool isEnabled,
    required VoidCallback? onPressed,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // 부드러운 색상 보간
        final color1 = Color.lerp(
          const Color(0xFF3b82f6),
          const Color(0xFF8b5cf6),
          _animation.value,
        )!;
        final color2 = Color.lerp(
          const Color(0xFF8b5cf6),
          const Color(0xFFec4899),
          _animation.value,
        )!;

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                gradient: isEnabled
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color1.withOpacity(0.8),
                          color2.withOpacity(0.8),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(0.4),
                          Colors.grey.withOpacity(0.3),
                        ],
                      ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: color1.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onPressed,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isEnabled ? Colors.white : Colors.white54,
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
}

