import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:tago_driver/presentation/common/appScaffold.dart';

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
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "개인정보 처리방침",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      scrollable: true,
      body: _buildPrivacyContent(),
    );
  }

  /// 개인정보 처리방침 콘텐츠
  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),

        const SizedBox(height: 24),

        _buildUpdateDate(),

        const SizedBox(height: 32),

        _buildSection(
          title: "1. 개인정보의 수집 및 이용 목적",
          content:
              "TAGO(이하 '회사')는 다음의 목적을 위하여 개인정보를 처리합니다:\n\n"
              "• 회원 가입 및 관리\n"
              "• 서비스 제공 및 개선\n"
              "• 라이드 예약 및 매칭\n"
              "• 결제 및 정산\n"
              "• 고객 지원 및 문의 응대\n"
              "• 마케팅 및 이벤트 정보 제공 (동의 시)",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "2. 수집하는 개인정보 항목",
          content:
              "회사는 다음의 개인정보를 수집합니다:\n\n"
              "【필수 정보】\n"
              "• 이름\n"
              "• 이메일 주소\n"
              "• 전화번호 (서비스 제공 시)\n"
              "• 학교 정보\n\n"
              "【선택 정보】\n"
              "• 프로필 사진\n\n"
              "【자동 수집 정보】\n"
              "• 서비스 이용 기록\n"
              "• 접속 로그\n"
              "• 기기 정보\n"
              "• 위치 정보 (서비스 이용 시)",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "3. 개인정보의 보유 및 이용 기간",
          content:
              "회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 "
              "개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 "
              "개인정보를 처리·보유합니다.\n\n"
              "• 회원 탈퇴 시: 즉시 파기\n"
              "• 단, 관계 법령에 따라 보존할 필요가 있는 경우 해당 기간 동안 보관:\n"
              "  - 계약 또는 청약철회 등에 관한 기록: 5년\n"
              "  - 대금결제 및 재화 등의 공급에 관한 기록: 5년\n"
              "  - 소비자 불만 또는 분쟁처리에 관한 기록: 3년",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "4. 개인정보의 제3자 제공",
          content:
              "회사는 원칙적으로 이용자의 개인정보를 외부에 제공하지 않습니다. "
              "다만, 아래의 경우는 예외로 합니다:\n\n"
              "• 이용자가 사전에 동의한 경우\n"
              "• 서비스 제공을 위해 필요한 경우 (택시 기사에게 예약 정보 제공)\n"
              "• 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 "
              "수사기관의 요구가 있는 경우",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "5. 개인정보 처리의 위탁",
          content:
              "회사는 서비스 향상을 위해 아래와 같이 개인정보 처리업무를 외부에 위탁하고 있습니다:\n\n"
              "【위탁업체】\n"
              "• 결제 서비스: Stripe, PayPal\n"
              "• 클라우드 서비스: Firebase (Google)\n"
              "• 고객 지원: Zendesk\n\n"
              "회사는 위탁계약 체결 시 개인정보 보호법에 따라 위탁업무 수행목적 외 "
              "개인정보 처리금지, 기술적·관리적 보호조치, 재위탁 제한 등을 규정하고 있습니다.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "6. 정보주체의 권리·의무 및 행사 방법",
          content:
              "이용자는 다음과 같은 권리를 행사할 수 있습니다:\n\n"
              "• 개인정보 열람 요구\n"
              "• 오류 등이 있을 경우 정정 요구\n"
              "• 삭제 요구\n"
              "• 처리 정지 요구\n\n"
              "권리 행사는 '설정 > 프로필 수정' 또는 '문의하기'를 통해 가능합니다.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "7. 개인정보의 파기",
          content:
              "회사는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 "
              "지체없이 해당 개인정보를 파기합니다.\n\n"
              "【파기 절차】\n"
              "이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져 내부 방침 및 관련 법령에 따라 "
              "일정기간 저장된 후 파기됩니다.\n\n"
              "【파기 방법】\n"
              "• 전자적 파일: 복구 및 재생되지 않도록 기술적 방법으로 완전 삭제\n"
              "• 종이 문서: 분쇄하거나 소각",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "8. 개인정보 보호책임자",
          content:
              "회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, "
              "개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 "
              "아래와 같이 개인정보 보호책임자를 지정하고 있습니다:\n\n"
              "【개인정보 보호책임자】\n"
              "• 이름: TAGO 개인정보 보호팀\n"
              "• 이메일: privacy@tagoapp.com\n\n"
              "기타 개인정보침해에 대한 신고나 상담이 필요한 경우 아래 기관에 문의하실 수 있습니다:\n"
              "• 개인정보침해신고센터: privacy.kisa.or.kr (국번없이 118)\n"
              "• 개인정보분쟁조정위원회: kopico.go.kr (1833-6972)",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "9. 개인정보 처리방침의 변경",
          content:
              "이 개인정보 처리방침은 2025년 1월 1일부터 적용됩니다.\n\n"
              "법령, 정책 또는 보안기술의 변경에 따라 내용의 추가·삭제 및 수정이 있을 시에는 "
              "변경 최소 7일 전부터 앱 내 공지사항을 통해 고지할 것입니다.",
        ),

        const SizedBox(height: 40),

        _buildContactInfo(),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHeader() {
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
                  "TAGO는 이용자의 개인정보를 소중히 다루며,\n관련 법령을 준수합니다.",
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

  Widget _buildUpdateDate() {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        "최종 업데이트: 2025년 1월 1일",
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
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
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
                  const Text(
                    "개인정보 관련 문의",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "개인정보 처리방침에 대한 문의:\nprivacy@tagoapp.com",
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
