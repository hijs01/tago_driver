import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tago_driver/data/models/user.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/setting/settings_view_model.dart';
import 'package:tago_driver/presentation/pages/setting/details/profile_edit/profile_edit_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/profile_edit/profile_edit_view_model.dart';
import 'package:tago_driver/presentation/pages/setting/details/password_change/password_change_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/password_change/password_change_view_model.dart';
import 'package:tago_driver/presentation/pages/setting/details/terms/terms_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/privacy/privacy_view.dart';
import 'package:tago_driver/presentation/pages/setting/details/developer_info/developer_info_view.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

/// 설정 화면 - Dark Minimal 스타일
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
    final l10n = AppLocalizations.of(context)!;

    if (vm.isLoading) {
      return AppScaffold(
        backgroundColor: const Color(0xFF0F1419),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              const Color(0xFF4CAF50),
            ),
            strokeWidth: 3,
          ),
        ),
      );
    }

    return AppScaffold(
      backgroundColor: const Color(0xFF0F1419),
      scrollable: true,
      bodyPadding: const EdgeInsets.all(24),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // 설정 타이틀
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.settingsHeader,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 프로필 카드
          _buildProfileCard(vm),

          const SizedBox(height: 32),

          // 섹션 제목: 계정
          _buildSectionTitle(l10n.accountSection),
          const SizedBox(height: 16),

          // 계정 카드 그리드
          _buildAccountGrid(context, vm, l10n),

          const SizedBox(height: 32),

          // 섹션 제목: 약관 및 정보
          _buildSectionTitle(l10n.termsAndInfoSection),
          const SizedBox(height: 16),

          // 약관 카드 그리드
          _buildInfoGrid(context, l10n),

          const SizedBox(height: 32),

          // 로그아웃 버튼
          _buildLogoutButton(context, vm, l10n),

          const SizedBox(height: 16),

          // 회원 탈퇴
          _buildDeleteAccountButton(context, vm, l10n),

          const SizedBox(height: 100), // 바텀바 공간
        ],
      ),
    );
  }

  /// 프로필 카드 - Dark Minimal 스타일
  Widget _buildProfileCard(SettingsViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 프로필 아이콘
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4CAF50).withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                vm.displayName.isNotEmpty
                    ? vm.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 이름 & 이메일
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vm.displayEmail,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          color: Colors.white.withOpacity(0.5),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  /// 계정 카드 그리드
  Widget _buildAccountGrid(BuildContext context, SettingsViewModel vm, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGridCard(
                icon: Icons.person_outline,
                title: l10n.editProfile,
                subtitle: l10n.editProfileSubtitle,
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
                title: l10n.changePassword,
                subtitle: l10n.changePasswordSubtitle,
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
        ),
      ],
    );
  }

  /// 약관 및 정보 카드 그리드
  Widget _buildInfoGrid(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGridCard(
                icon: Icons.description_outlined,
                title: l10n.termsOfService,
                subtitle: l10n.termsOfServiceSubtitle,
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
                title: l10n.privacyPolicy,
                subtitle: l10n.privacyPolicySubtitle,
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
                title: l10n.developerInfo,
                subtitle: l10n.developerInfoSubtitle,
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

  /// 그리드 카드 위젯 - Dark Minimal 스타일
  Widget _buildGridCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘
            Icon(
              icon,
              color: iconColor ?? const Color(0xFF4CAF50),
              size: 32,
            ),
            const SizedBox(height: 12),
            // 제목
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
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
    );
  }

  /// 로그아웃 버튼 - Dark Minimal
  Widget _buildLogoutButton(BuildContext context, SettingsViewModel vm, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final confirm = await _showLogoutDialog(context, l10n);
            if (confirm == true) {
              await vm.logout(context);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              l10n.logout,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 회원 탈퇴 버튼
  Widget _buildDeleteAccountButton(BuildContext context, SettingsViewModel vm, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () async {
        final confirm = await _showDeleteAccountDialog(context, l10n);

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
          l10n.deleteAccount,
          style: TextStyle(
            color: const Color(0xFFFF6B6B).withOpacity(0.7),
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  /// 로그아웃 확인 다이얼로그 - Dark Minimal 스타일
  Future<bool?> _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.logoutDialogTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          l10n.logoutDialogMessage,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.logout,
              style: const TextStyle(
                color: Color(0xFFFF6B6B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 회원 탈퇴 확인 다이얼로그 - Dark Minimal 스타일
  Future<bool?> _showDeleteAccountDialog(BuildContext context, AppLocalizations l10n) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final controller = TextEditingController();

        return AlertDialog(
          backgroundColor: const Color(0xFF1A1F26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
            title: Row(
              children: [
                const Icon(Icons.warning, color: Color(0xFFFF6B6B)),
                const SizedBox(width: 8),
                Text(
                  l10n.deleteAccountDialogTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Text(
                      l10n.deleteAccountDialogMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${l10n.deleteAccountWarning1}\n'
                      '${l10n.deleteAccountWarning2}\n'
                      '${l10n.deleteAccountWarning3}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.deleteAccountInputHint,
                      style: const TextStyle(
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
                        hintText: l10n.deleteAccountInputPlaceholder,
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color(0xFFFF6B6B).withOpacity(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color(0xFFFF6B6B).withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6B6B),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      l10n.deleteAccountButton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ),
            ],
        );
      },
    );
  }
}
