import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:tago_driver/presentation/common/appScaffold.dart';

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
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "이용약관",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      scrollable: true,
      body: _buildTermsContent(),
    );
  }

  /// 이용약관 콘텐츠
  ///
  /// 구성:
  /// 1. 안내 문구
  /// 2. 약관 업데이트 일자
  /// 3. 각 섹션별 약관 내용
  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 안내 문구
        _buildHeader(),

        const SizedBox(height: 24),

        // 업데이트 일자
        _buildUpdateDate(),

        const SizedBox(height: 32),

        // 제 1 조 (목적)
        _buildSection(
          article: "제 1 조 (목적)",
          content:
              "본 약관은 TAGO(이하 '회사')가 제공하는 라이드 공유 서비스(이하 '서비스')의 "
              "이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항, 기타 필요한 "
              "사항을 규정함을 목적으로 합니다.",
        ),

        const SizedBox(height: 24),

        // 제 2 조 (정의)
        _buildSection(
          article: "제 2 조 (정의)",
          content:
              "1. '서비스'란 회사가 제공하는 공항-학교 간 라이드 공유 플랫폼을 의미합니다.\n\n"
              "2. '이용자'란 본 약관에 따라 회사가 제공하는 서비스를 받는 회원을 말합니다.\n\n"
              "3. '회원'이란 본 약관에 동의하고 회사와 이용계약을 체결한 자를 의미합니다.\n\n"
              "4. '택시 기사'란 회사와 제휴한 운송 서비스 제공자를 의미합니다.",
        ),

        const SizedBox(height: 24),

        // 제 3 조 (약관의 효력 및 변경)
        _buildSection(
          article: "제 3 조 (약관의 효력 및 변경)",
          content:
              "1. 본 약관은 서비스를 이용하고자 하는 모든 이용자에게 그 효력을 발생합니다.\n\n"
              "2. 회사는 필요한 경우 관련 법령을 위배하지 않는 범위에서 본 약관을 변경할 수 있습니다.\n\n"
              "3. 약관이 변경되는 경우 회사는 변경사항을 시행일자 7일 전부터 공지합니다.\n\n"
              "4. 이용자가 변경된 약관에 동의하지 않는 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다.",
        ),

        const SizedBox(height: 24),

        // 제 4 조 (서비스의 제공)
        _buildSection(
          article: "제 4 조 (서비스의 제공)",
          content:
              "1. 회사는 다음과 같은 서비스를 제공합니다:\n"
              "   • 공항-학교 간 라이드 예약\n"
              "   • 택시 기사 매칭\n"
              "   • 결제 대행\n"
              "   • 예약 관리\n\n"
              "2. 서비스는 연중무휴 1일 24시간 제공함을 원칙으로 합니다.\n\n"
              "3. 회사는 시스템 점검, 보수 등의 사유로 서비스 제공을 일시 중단할 수 있습니다.",
        ),

        const SizedBox(height: 24),

        // 제 5 조 (회원가입)
        _buildSection(
          article: "제 5 조 (회원가입)",
          content:
              "1. 이용자는 회사가 정한 가입 양식에 따라 회원정보를 기입한 후 "
              "본 약관에 동의한다는 의사표시를 함으로써 회원가입을 신청합니다.\n\n"
              "2. 회사는 다음 각 호에 해당하는 경우 회원가입을 거절할 수 있습니다:\n"
              "   • 타인의 명의를 이용한 경우\n"
              "   • 허위 정보를 기재한 경우\n"
              "   • 기타 회원으로 등록하는 것이 부적절한 경우",
        ),

        const SizedBox(height: 24),

        // 제 6 조 (개인정보 보호)
        _buildSection(
          article: "제 6 조 (개인정보 보호)",
          content:
              "회사는 관련 법령이 정하는 바에 따라 이용자의 개인정보를 보호하기 위해 "
              "노력합니다. 개인정보의 보호 및 이용에 대해서는 관련 법령 및 회사의 "
              "개인정보처리방침이 적용됩니다.",
        ),

        const SizedBox(height: 24),

        // 제 7 조 (회원의 의무)
        _buildSection(
          article: "제 7 조 (회원의 의무)",
          content:
              "1. 회원은 다음 행위를 하여서는 안 됩니다:\n"
              "   • 허위 정보 등록 및 타인 정보 도용\n"
              "   • 회사의 서비스 정보 변경\n"
              "   • 회사가 정한 정보 이외의 정보 송신 또는 게시\n"
              "   • 회사의 저작권, 제3자의 저작권 등 권리 침해\n"
              "   • 타인의 명예를 손상시키거나 불이익을 주는 행위\n\n"
              "2. 회원은 관계 법령, 본 약관, 이용안내 및 서비스상 공지사항 등을 "
              "준수하여야 합니다.",
        ),

        const SizedBox(height: 24),

        // 제 8 조 (예약 및 취소)
        _buildSection(
          article: "제 8 조 (예약 및 취소)",
          content:
              "1. 회원은 앱을 통해 라이드를 예약할 수 있습니다.\n\n"
              "2. 예약 취소는 출발 24시간 전까지 무료로 가능합니다.\n\n"
              "3. 출발 24시간 이내 취소 시 취소 수수료가 부과될 수 있습니다.\n\n"
              "4. 예약 후 연락 두절, 탑승 거부 등의 경우 패널티가 부과될 수 있습니다.",
        ),

        const SizedBox(height: 24),

        // 제 9 조 (결제)
        _buildSection(
          article: "제 9 조 (결제)",
          content:
              "1. 서비스 이용 요금은 라이드 완료 후 자동으로 결제됩니다.\n\n"
              "2. 회원은 신용카드, 체크카드 등 회사가 정한 결제수단을 이용할 수 있습니다.\n\n"
              "3. 결제와 관련된 회원의 개인정보는 안전하게 보호됩니다.",
        ),

        const SizedBox(height: 24),

        // 제 10 조 (환불)
        _buildSection(
          article: "제 10 조 (환불)",
          content:
              "1. 회사의 귀책사유로 서비스가 제공되지 않은 경우 전액 환불합니다.\n\n"
              "2. 회원의 사유로 서비스를 이용하지 못한 경우 환불이 불가합니다.\n\n"
              "3. 환불은 결제수단에 따라 3-7 영업일이 소요될 수 있습니다.",
        ),

        const SizedBox(height: 24),

        // 제 11 조 (책임의 제한)
        _buildSection(
          article: "제 11 조 (책임의 제한)",
          content:
              "1. 회사는 천재지변, 불가항력적 사유로 서비스를 제공할 수 없는 경우 "
              "책임이 면제됩니다.\n\n"
              "2. 회사는 회원의 귀책사유로 인한 서비스 이용 장애에 대하여 책임을 지지 않습니다.\n\n"
              "3. 회사는 택시 기사가 제공하는 운송 서비스의 질에 대해 책임을 지지 않으나, "
              "문제 발생 시 적극적으로 중재합니다.",
        ),

        const SizedBox(height: 24),

        // 제 12 조 (분쟁 해결)
        _buildSection(
          article: "제 12 조 (분쟁 해결)",
          content:
              "1. 본 약관에 명시되지 않은 사항은 관련 법령 및 상관례에 따릅니다.\n\n"
              "2. 서비스 이용으로 발생한 분쟁에 대해 소송이 필요한 경우, "
              "회사의 소재지를 관할하는 법원을 전속 관할 법원으로 합니다.",
        ),

        const SizedBox(height: 40),

        // 문의 안내
        _buildContactInfo(),

        const SizedBox(height: 40),
      ],
    );
  }

  /// 상단 안내 문구
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
                Icons.description_outlined,
                color: Colors.blueAccent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "TAGO 서비스 이용약관입니다.\n서비스 이용 전 반드시 확인해주세요.",
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
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 문의 안내
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
                  Icon(Icons.help_outline, color: Colors.blueAccent, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    "약관 관련 문의",
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
                "이용약관에 대한 문의사항이 있으시면\n"
                "'지원 > 문의하기'를 통해 연락주세요.",
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
