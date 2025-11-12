import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

/// 개인정보 처리방침 화면
///
/// 기능:
/// 1. 개인정보 처리방침 전체 텍스트 표시
/// 2. 섹션별 구분
/// 3. 스크롤 가능
///
/// 특징:
/// - 정적 콘텐츠 (ViewModel 불필요)
/// - 읽기 전용
///
/// 사용 위치: settings_view.dart의 "개인정보 처리방침"
class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.privacyPolicy,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      scrollable: true,
      body: _buildPrivacyContent(context, l10n),
    );
  }

  /// 개인정보 처리방침 콘텐츠
  Widget _buildPrivacyContent(BuildContext context, AppLocalizations l10n) {
    // AppBar 높이를 고려한 여백 추가
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: appBarHeight + statusBarHeight + 20),
        
        _buildHeader(l10n),

        const SizedBox(height: 24),

        _buildUpdateDate(l10n, context),

        const SizedBox(height: 32),

        _buildSection(
          title: l10n.privacySection1Title,
          content: l10n.privacySection1Content,
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: l10n.privacySection2Title,
          content: l10n.privacySection2Content,
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: l10n.privacySection3Title,
          content: l10n.privacySection3Content,
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: l10n.privacySection4Title,
          content: l10n.privacySection4Content,
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: l10n.privacySection5Title,
          content: l10n.privacySection5Content,
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: l10n.privacySection6Title,
          content: l10n.privacySection6Content,
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: l10n.privacySection7Title,
          content: l10n.privacySection7Content,
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: l10n.privacySection8Title,
          content: l10n.privacySection8Content,
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: l10n.privacySection9Title,
          content: l10n.privacySection9Content,
        ),

        const SizedBox(height: 40),

        _buildContactInfo(l10n),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
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
              Icon(
                Icons.privacy_tip_outlined,
                color: Colors.blueAccent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.privacyHeaderInfo,
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

  Widget _buildUpdateDate(AppLocalizations l10n, BuildContext context) {
    // 로케일에 맞는 날짜 포맷팅
    final locale = Localizations.localeOf(context).toString();
    final date = DateTime(2025, 1, 1);
    String formattedDate;
    
    if (locale == 'ko') {
      formattedDate = DateFormat('yyyy년 M월 d일', locale).format(date);
    } else {
      formattedDate = DateFormat('MMMM d, yyyy', locale).format(date);
    }
    
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        l10n.lastUpdated(formattedDate),
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                content,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  height: 1.7,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(AppLocalizations l10n) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    color: Colors.blueAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.privacyContactTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.privacyContactMessage,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
