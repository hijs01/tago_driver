import 'package:flutter/material.dart';
import 'dart:ui'; // BackdropFilter 사용
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

/// 개발자 정보 화면 - Liquid Glass 스타일
class DeveloperInfoView extends StatelessWidget {
  const DeveloperInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScaffold(
      // ===== 검정 배경 유지 =====
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.developerInfo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      scrollable: true,
      bodyPadding: const EdgeInsets.all(24),
      body: _buildContent(context, l10n),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),

        // 앱 로고
        _buildAppLogo(),

        const SizedBox(height: 24),

        // 앱 이름
        _buildAppName(),

        const SizedBox(height: 8),

        // 앱 설명
        _buildAppDescription(l10n),

        const SizedBox(height: 48),

        // 개발팀
        _buildInfoSection(
          icon: Icons.people,
          title: l10n.developmentTeam,
          subtitle: "TAGO Development Team",
        ),

        const SizedBox(height: 16),

        // 문의
        _buildInfoSection(
          icon: Icons.email,
          title: l10n.inquiry,
          subtitle: "support@tagoapp.com",
          onTap: () {
            _showComingSoon(context, l10n);
          },
        ),

        const SizedBox(height: 16),

        // 웹사이트
        _buildInfoSection(
          icon: Icons.language,
          title: l10n.website,
          subtitle: "www.tagoapp.com",
          onTap: () {
            _showComingSoon(context, l10n);
          },
        ),

        const SizedBox(height: 16),

        // GitHub
        _buildInfoSection(
          icon: Icons.code,
          title: "GitHub",
          subtitle: "github.com/tago-app",
          onTap: () {
            _showComingSoon(context, l10n);
          },
        ),

        const SizedBox(height: 80),

        // 버전 정보
        _buildVersionInfo(l10n),

        const SizedBox(height: 16),

        // 저작권
        _buildCopyright(l10n),

        const SizedBox(height: 100), // 바텀바 공간
      ],
    );
  }

  /// 앱 로고 - Liquid Glass
  Widget _buildAppLogo() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.local_taxi, size: 50, color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// 앱 이름
  Widget _buildAppName() {
    return const Center(
      child: Text(
        "TAGO",
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  /// 앱 설명
  Widget _buildAppDescription(AppLocalizations l10n) {
    return Center(
      child: Text(
        l10n.appDescription,
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 정보 섹션 타일 - Liquid Glass
  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
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
            child: Row(
              children: [
                // 아이콘
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white.withOpacity(0.9),
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // 제목 & 부제목
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // 화살표
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.3),
                    size: 14,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 버전 정보 - Liquid Glass
  Widget _buildVersionInfo(AppLocalizations l10n) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Text(
              l10n.version('1.0.0'),
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 저작권 표시
  Widget _buildCopyright(AppLocalizations l10n) {
    return Center(
      child: Text(
        l10n.copyright,
        style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11),
      ),
    );
  }

  /// "곧 추가될 예정" 메시지 - Liquid Glass 스타일
  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.comingSoon),
        backgroundColor: Colors.white.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
