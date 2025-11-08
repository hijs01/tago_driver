import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:tago_driver/presentation/common/appScaffold.dart';

/// FAQ (자주 묻는 질문) 화면
///
/// 기능:
/// 1. 자주 묻는 질문 리스트 표시
/// 2. 질문 탭하면 답변 펼쳐지기 (ExpansionTile)
/// 3. 카테고리별 구분
///
/// 특징:
/// - 정적 콘텐츠 (ViewModel 불필요)
/// - 확장/축소 가능한 타일
///
/// 사용 위치: settings_view.dart의 "FAQ"
class FAQView extends StatelessWidget {
  const FAQView({super.key});

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
          "FAQ",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      scrollable: true,
      body: _buildFAQContent(),
    );
  }

  /// FAQ 콘텐츠
  ///
  /// 구성:
  /// 1. 안내 문구
  /// 2. 일반 질문 섹션
  /// 3. 예약 관련 질문 섹션
  /// 4. 결제 관련 질문 섹션
  /// 5. 문의 안내
  Widget _buildFAQContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 안내 문구
        _buildHeader(),

        const SizedBox(height: 32),

        // 일반 질문
        _buildSectionTitle("일반"),
        const SizedBox(height: 16),
        _buildGeneralFAQs(),

        const SizedBox(height: 32),

        // 예약 관련
        _buildSectionTitle("예약"),
        const SizedBox(height: 16),
        _buildBookingFAQs(),

        const SizedBox(height: 32),

        // 결제 관련
        _buildSectionTitle("결제"),
        const SizedBox(height: 16),
        _buildPaymentFAQs(),

        const SizedBox(height: 32),

        // 문의 안내
        _buildContactInfo(),

        const SizedBox(height: 40),
      ],
    );
  }

  /// 상단 안내 문구
  ///
  /// 표시: FAQ 화면 설명
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
              Icon(Icons.help_outline, color: Colors.blueAccent, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "자주 묻는 질문들을 확인하세요.\n궁금한 내용을 탭하면 답변을 볼 수 있습니다.",
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

  /// 섹션 제목
  ///
  /// @param title 섹션 이름 (예: "일반", "예약")
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

  /// 일반 질문 섹션
  ///
  /// 질문 목록:
  /// - TAGO는 무엇인가요?
  /// - 누가 이용할 수 있나요?
  /// - 앱은 무료인가요?
  Widget _buildGeneralFAQs() {
    return Column(
      children: [
        _buildFAQTile(
          question: "TAGO는 무엇인가요?",
          answer:
              "TAGO는 미국 한인 대학생들을 위한 라이드 공유 서비스입니다. "
              "공항과 학교 간 이동을 쉽고 안전하게 예약할 수 있도록 "
              "한인 택시 회사와 학생들을 직접 연결해드립니다.",
        ),
        const SizedBox(height: 12),

        _buildFAQTile(
          question: "누가 이용할 수 있나요?",
          answer:
              "현재 Penn State University 학생들을 대상으로 서비스를 제공하고 있습니다. "
              "향후 다른 대학교로도 확대할 예정입니다.",
        ),
        const SizedBox(height: 12),

        _buildFAQTile(
          question: "앱은 무료인가요?",
          answer:
              "앱 다운로드 및 사용은 무료입니다. "
              "실제 라이드 이용 시에만 택시 요금이 발생합니다.",
        ),
      ],
    );
  }

  /// 예약 관련 질문 섹션
  ///
  /// 질문 목록:
  /// - 예약은 어떻게 하나요?
  /// - 예약 취소는 가능한가요?
  /// - 얼마나 미리 예약해야 하나요?
  Widget _buildBookingFAQs() {
    return Column(
      children: [
        _buildFAQTile(
          question: "예약은 어떻게 하나요?",
          answer:
              "1. 홈 화면에서 '탑 구하기' 버튼을 탭하세요.\n"
              "2. 출발지와 도착지를 선택하세요.\n"
              "3. 날짜, 시간, 인원수를 입력하세요.\n"
              "4. 슬라이드하여 예약을 완료하세요.\n"
              "택시 기사가 배정되면 알림을 받게 됩니다.",
        ),
        const SizedBox(height: 12),

        _buildFAQTile(
          question: "예약 취소는 가능한가요?",
          answer:
              "출발 24시간 전까지는 무료로 취소 가능합니다. "
              "24시간 이내 취소 시에는 취소 수수료가 부과될 수 있습니다. "
              "'내 예약' 화면에서 취소 버튼을 눌러주세요.",
        ),
        const SizedBox(height: 12),

        _buildFAQTile(
          question: "얼마나 미리 예약해야 하나요?",
          answer:
              "최소 24시간 전에 예약하시는 것을 권장합니다. "
              "특히 공항 픽업의 경우 2-3일 전에 예약하시면 "
              "원하시는 시간에 더 확실하게 예약하실 수 있습니다.",
        ),
      ],
    );
  }

  /// 결제 관련 질문 섹션
  ///
  /// 질문 목록:
  /// - 결제는 어떻게 하나요?
  /// - 어떤 결제 수단을 사용할 수 있나요?
  /// - 영수증은 받을 수 있나요?
  Widget _buildPaymentFAQs() {
    return Column(
      children: [
        _buildFAQTile(
          question: "결제는 어떻게 하나요?",
          answer:
              "라이드 완료 후 앱에 등록된 결제 수단으로 자동 결제됩니다. "
              "별도로 현금을 준비하실 필요가 없습니다.",
        ),
        const SizedBox(height: 12),

        _buildFAQTile(
          question: "어떤 결제 수단을 사용할 수 있나요?",
          answer:
              "현재는 신용카드 및 체크카드 결제를 지원합니다. "
              "'설정 > 결제 설정'에서 카드를 등록하실 수 있습니다.",
        ),
        const SizedBox(height: 12),

        _buildFAQTile(
          question: "영수증은 받을 수 있나요?",
          answer:
              "네, 라이드 완료 후 등록하신 이메일로 자동으로 영수증이 발송됩니다. "
              "'내 예약' 화면에서도 영수증을 다시 확인하실 수 있습니다.",
        ),
      ],
    );
  }

  /// FAQ 타일 (질문 + 답변)
  ///
  /// 기능:
  /// - 처음에는 질문만 표시 (축소 상태)
  /// - 탭하면 답변이 펼쳐짐 (확장 상태)
  /// - 다시 탭하면 다시 축소됨
  ///
  /// @param question 질문 텍스트
  /// @param answer 답변 텍스트
  Widget _buildFAQTile({required String question, required String answer}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Theme(
            // ExpansionTile 스타일 커스터마이징
            data: ThemeData(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

              // 질문 (타이틀)
              title: Text(
                question,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // 아이콘 색상
              iconColor: Colors.white.withOpacity(0.7),
              collapsedIconColor: Colors.white.withOpacity(0.5),

              // 답변 (펼쳐지는 부분)
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    answer,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 문의 안내
  ///
  /// 표시:
  /// - 추가 질문이 있을 때 문의하는 방법 안내
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
                    Icons.contact_support,
                    color: Colors.blueAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "추가 문의",
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
                "원하는 답변을 찾지 못하셨나요?\n"
                "'지원 > 문의하기'에서 언제든지 문의해주세요.\n"
                "최대한 빠르게 답변드리겠습니다!",
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
