import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

/// 이용약관 화면
///
/// 기능:
/// 1. 서비스 이용약관 전체 텍스트 표시
/// 2. 섹션별 구분
/// 3. 스크롤 가능
///
/// 특징:
/// - 정적 콘텐츠 (ViewModel 불필요)
/// - 읽기 전용
///
/// 사용 위치: settings_view.dart의 "이용약관"
class TermsView extends StatelessWidget {
  const TermsView({super.key});

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
          l10n.termsOfService,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      scrollable: true,
      body: _buildTermsContent(context, l10n),
    );
  }

  /// 이용약관 콘텐츠
  ///
  /// 구성:
  /// 1. 안내 문구
  /// 2. 약관 업데이트 일자
  /// 3. 각 섹션별 약관 내용
  Widget _buildTermsContent(BuildContext context, AppLocalizations l10n) {
    // AppBar 높이를 고려한 여백 추가
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: appBarHeight + statusBarHeight + 20),
        
        // 안내 문구
        _buildHeader(l10n),

        const SizedBox(height: 24),

        // 업데이트 일자
        _buildUpdateDate(l10n, context),

        const SizedBox(height: 32),

        // 제 1 조 (목적)
        _buildSection(
          article: l10n.termsArticle1Title,
          content: l10n.termsArticle1Content,
        ),

        const SizedBox(height: 24),

        // 제 2 조 (정의)
        _buildSection(
          article: l10n.termsArticle2Title,
          content: l10n.termsArticle2Content,
        ),

        const SizedBox(height: 24),

        // 제 3 조 (약관의 효력 및 변경)
        _buildSection(
          article: l10n.termsArticle3Title,
          content: l10n.termsArticle3Content,
        ),

        const SizedBox(height: 24),

        // 제 4 조 (서비스의 제공)
        _buildSection(
          article: l10n.termsArticle4Title,
          content: l10n.termsArticle4Content,
        ),

        const SizedBox(height: 24),

        // 제 5 조 (회원가입)
        _buildSection(
          article: l10n.termsArticle5Title,
          content: l10n.termsArticle5Content,
        ),

        const SizedBox(height: 24),

        // 제 6 조 (개인정보 보호)
        _buildSection(
          article: l10n.termsArticle6Title,
          content: l10n.termsArticle6Content,
        ),

        const SizedBox(height: 24),

        // 제 7 조 (회원의 의무)
        _buildSection(
          article: l10n.termsArticle7Title,
          content: l10n.termsArticle7Content,
        ),

        const SizedBox(height: 24),

        // 제 8 조 (예약 및 취소)
        _buildSection(
          article: l10n.termsArticle8Title,
          content: l10n.termsArticle8Content,
        ),

        const SizedBox(height: 24),

        // 제 9 조 (결제)
        _buildSection(
          article: l10n.termsArticle9Title,
          content: l10n.termsArticle9Content,
        ),

        const SizedBox(height: 24),

        // 제 10 조 (환불)
        _buildSection(
          article: l10n.termsArticle10Title,
          content: l10n.termsArticle10Content,
        ),

        const SizedBox(height: 24),

        // 제 11 조 (책임의 제한)
        _buildSection(
          article: l10n.termsArticle11Title,
          content: l10n.termsArticle11Content,
        ),

        const SizedBox(height: 24),

        // 제 12 조 (분쟁 해결)
        _buildSection(
          article: l10n.termsArticle12Title,
          content: l10n.termsArticle12Content,
        ),

        const SizedBox(height: 40),

        // 문의 안내
        _buildContactInfo(l10n),

        const SizedBox(height: 40),
      ],
    );
  }

  /// 상단 안내 문구
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
                Icons.description_outlined,
                color: Colors.blueAccent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.termsHeaderInfo,
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

  /// 업데이트 일자
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

  /// 약관 섹션
  ///
  /// @param article 조항 제목 (예: "제 1 조 (목적)")
  /// @param content 조항 내용
  Widget _buildSection({required String article, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 조항 제목
        Text(
          article,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // 조항 내용
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

  /// 문의 안내
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
                  Icon(Icons.help_outline, color: Colors.blueAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.termsContactTitle,
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
                l10n.termsContactMessage,
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
