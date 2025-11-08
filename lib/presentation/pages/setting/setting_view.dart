import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // BackdropFilter 사용
import 'package:tago_driver/data/models/user.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/setting/settings_view_model.dart';
import 'package:tago_driver/presentation/pages/setting/details/profile_edit/profile_edit_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/profile_edit/profile_edit_view_model.dart';
import 'package:tago_driver/presentation/pages/setting/details/password_change/password_change_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/password_change/password_change_view_model.dart';
import 'package:tago_driver/presentation/pages/setting/details/faq/faq_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/contact/contact_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/emergency_report/emergency_report_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/terms/terms_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/privacy/privacy_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/developer_info/developer_info_view.dart';

/// 설정 화면 - Liquid Glass 스타일
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    if (vm.isLoading) {
      return AppScaffold(
        // ===== 🔥 그라디언트 배경 추가 =====
        backgroundGradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
            Color(0xFF5A189A),
            Color(0xFF000000),
            Color(0xFF000000),
          ],
          stops: [0.0, 0.15, 0.3, 0.55, 1.0],
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return AppScaffold(
      // ===== 🔥 그라디언트 배경 =====
      backgroundGradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF89CFF0),
          Color(0xFF4169E1),
          Color(0xFF4169E1),
          Color(0xFF000000),
          Color(0xFF000000),
        ],
        stops: [0.0, 0.2, 0.2, 0.53, 1.0],
      ),
      scrollable: true,
      bodyPadding: const EdgeInsets.all(24),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // 설정 타이틀
          const Text(
            '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 32),

          // 프로필 카드
          _buildProfileCard(vm),

          const SizedBox(height: 32),

          // 푸시 알림
          _buildNotificationSection(context, vm),

          const SizedBox(height: 32),

          // 섹션 제목: 계정
          _buildSectionTitle("계정"),
          const SizedBox(height: 16),

          // 계정 카드 그리드
          _buildAccountGrid(context, vm),

          const SizedBox(height: 32),

          // 섹션 제목: 지원
          _buildSectionTitle("지원"),
          const SizedBox(height: 16),

          // 지원 카드 그리드
          _buildSupportGrid(context),

          const SizedBox(height: 32),

          // 섹션 제목: 약관 및 정보
          _buildSectionTitle("약관 및 정보"),
          const SizedBox(height: 16),

          // 약관 카드 그리드
          _buildInfoGrid(context),

          const SizedBox(height: 32),

          // 로그아웃 버튼
          _buildLogoutButton(context, vm),

          const SizedBox(height: 16),

          // 회원 탈퇴
          _buildDeleteAccountButton(context, vm),

          const SizedBox(height: 100), // 바텀바 공간
        ],
      ),
    );
  }

  /// 프로필 카드 - Liquid Glass 스타일
  Widget _buildProfileCard(SettingsViewModel vm) {
    return ClipRRect(
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
          ),
          child: Row(
            children: [
              // 프로필 아이콘
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Center(
                  child: Text(
                    vm.displayName.isNotEmpty
                        ? vm.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // 이름 & 이메일
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vm.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      vm.displayEmail,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 섹션 제목
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// 푸시 알림 스위치 - Liquid Glass
  Widget _buildNotificationSection(BuildContext context, SettingsViewModel vm) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: Colors.white.withOpacity(0.8),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "푸시 알림",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "모든 알림 받기",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: vm.isPushEnabled,
                activeColor: Colors.white,
                activeTrackColor: Colors.white.withOpacity(0.3),
                inactiveThumbColor: Colors.white.withOpacity(0.5),
                inactiveTrackColor: Colors.white.withOpacity(0.1),
                onChanged: (value) {
                  vm.togglePushNotification(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 계정 카드 그리드
  Widget _buildAccountGrid(BuildContext context, SettingsViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: _buildGridCard(
            icon: Icons.person_outline,
            title: "프로필 수정",
            subtitle: "이름, 이메일",
            onTap: () async {
              if (vm.currentUser == null) return;

              final updatedUser = await Navigator.push<AppUser>(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ChangeNotifierProvider(
                        create: (_) => ProfileEditViewModel(),
                        child: ProfileEditView(user: vm.currentUser!),
                      ),
                ),
              );

              if (updatedUser != null) {
                await vm.initialize();
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGridCard(
            icon: Icons.lock_outline,
            title: "비밀번호 변경",
            subtitle: "비밀번호 재설정",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ChangeNotifierProvider(
                        create: (_) => PasswordChangeViewModel(),
                        child: const PasswordChangeView(),
                      ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 지원 카드 그리드
  Widget _buildSupportGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGridCard(
                icon: Icons.help_outline,
                title: "FAQ",
                subtitle: "자주 묻는 질문",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQView()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGridCard(
                icon: Icons.mail_outline,
                title: "문의하기",
                subtitle: "고객 지원",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactView(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGridCard(
                icon: Icons.report_problem_outlined,
                title: "긴급 신고",
                subtitle: "긴급 상황",
                iconColor: const Color(0xFFFF6B6B), // 빨간색 포인트
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmergencyReportView(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }

  /// 약관 및 정보 카드 그리드
  Widget _buildInfoGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGridCard(
                icon: Icons.description_outlined,
                title: "이용약관",
                subtitle: "서비스 약관",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsView()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGridCard(
                icon: Icons.privacy_tip_outlined,
                title: "개인정보",
                subtitle: "보호 정책",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyView(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGridCard(
                icon: Icons.code,
                title: "개발자 정보",
                subtitle: "팀 정보",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeveloperInfoView(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }

  /// 그리드 카드 위젯 - Liquid Glass 스타일
  Widget _buildGridCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // 아이콘
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (iconColor ?? Colors.white).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor ?? Colors.white, size: 28),
                ),
                const SizedBox(height: 12),
                // 제목
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                // 부제목
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 로그아웃 버튼 - Liquid Glass
  Widget _buildLogoutButton(BuildContext context, SettingsViewModel vm) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final confirm = await _showLogoutDialog(context);
                if (confirm == true) {
                  await vm.logout(context);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: const Center(
                child: Text(
                  "로그아웃",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 회원 탈퇴 버튼
  Widget _buildDeleteAccountButton(BuildContext context, SettingsViewModel vm) {
    return GestureDetector(
      onTap: () async {
        final confirm = await _showDeleteAccountDialog(context);

        if (confirm != true) return;

        if (!context.mounted) return;

        final navigator = Navigator.of(context);

        try {
          await vm.deleteAccount();
        } catch (e) {
          // 에러 무시
        }

        await Future.delayed(const Duration(milliseconds: 500));

        navigator.pushNamedAndRemoveUntil('/login', (route) => false);
      },
      child: Center(
        child: Text(
          "회원 탈퇴",
          style: TextStyle(
            color: const Color(0xFFFF6B6B).withOpacity(0.7),
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  /// 로그아웃 확인 다이얼로그 - Liquid Glass 스타일
  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              backgroundColor: Colors.black.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              title: const Text("로그아웃", style: TextStyle(color: Colors.white)),
              content: Text(
                "정말 로그아웃 하시겠습니까?",
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    "취소",
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    "로그아웃",
                    style: TextStyle(color: Color(0xFFFF6B6B)),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  /// 회원 탈퇴 확인 다이얼로그 - Liquid Glass 스타일
  Future<bool?> _showDeleteAccountDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final controller = TextEditingController();
        bool isDeleteEnabled = false;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            title: const Row(
              children: [
                Icon(Icons.warning, color: Color(0xFFFF6B6B)),
                SizedBox(width: 8),
                Text(
                  "회원 탈퇴",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "정말로 탈퇴하시겠습니까?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "• 모든 데이터가 영구적으로 삭제됩니다.\n"
                      "• 예약 정보가 모두 사라집니다.\n"
                      "• 이 작업은 되돌릴 수 없습니다.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "계속하려면 아래에 DELETE를 입력하세요:",
                      style: TextStyle(
                        color: Color(0xFFFF6B6B),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "DELETE",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6B6B),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: const Color(0xFFFF6B6B).withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6B6B),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          isDeleteEnabled = value == "DELETE";
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: Text(
                  "취소",
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, child) {
                  final enabled = value.text == "DELETE";
                  return ElevatedButton(
                    onPressed:
                        enabled
                            ? () => Navigator.pop(dialogContext, true)
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B6B),
                      disabledBackgroundColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "탈퇴하기",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
