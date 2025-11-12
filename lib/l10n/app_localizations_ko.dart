// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get assignedTripsHeader => '배정된 라이드 여정';

  @override
  String get noAssignedTrips => '배정된 여정이 없습니다';

  @override
  String get assignRideHint => '라이드를 배정하면 여정 목록에 추가됩니다';

  @override
  String get enterChat => '채팅방 입장';

  @override
  String get origin => '출발지';

  @override
  String get destination => '목적지';

  @override
  String get timeUnknown => '시간 정보 없음';

  @override
  String passengers(int count) {
    return '$count명';
  }

  @override
  String get loginSubtitle => '택시 탑승자를 찾아보세요';

  @override
  String get emailLabel => '이메일';

  @override
  String get emailHint => '이메일을 입력하세요';

  @override
  String get passwordLabel => '비밀번호';

  @override
  String get passwordHint => '비밀번호';

  @override
  String get login => '로그인';

  @override
  String get loggingIn => '로그인 중...';

  @override
  String get signUpCta => '아직 계정이 없나요? 회원가입하기';

  @override
  String get loginFailed => '로그인에 실패했습니다.';

  @override
  String get errorUserNotFound => '해당 이메일로 가입된 계정을 찾을 수 없습니다.';

  @override
  String get errorWrongPassword => '비밀번호가 올바르지 않습니다.';

  @override
  String get errorInvalidEmail => '이메일 형식이 올바르지 않습니다.';

  @override
  String get errorCancelled => '로그인을 취소했어요.';

  @override
  String get errorUnknown => '알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요';

  @override
  String get signUpTitle => '회원가입';

  @override
  String get signUpSubtitle => 'TAGO 타고가실?';

  @override
  String get nameLabel => '이름';

  @override
  String get nameHint => '이름을 입력하세요';

  @override
  String get companyNameLabel => '회사 이름';

  @override
  String get companyNameHint => 'PSU Taxi';

  @override
  String get confirmPasswordLabel => '비밀번호 확인';

  @override
  String get confirmPasswordHint => '비밀번호';

  @override
  String get companyCodeLabel => '회사 확인 코드';

  @override
  String get companyCodeHint => '관리자에게 받은 확인 코드 입력';

  @override
  String get signUp => '회원가입';

  @override
  String get signingUp => '가입 중...';

  @override
  String get loginCta => '이미 계정이 있나요? 로그인하기';

  @override
  String get errorPasswordMismatch => '비밀번호가 서로 일치하지 않습니다.';

  @override
  String get errorInvalidCompanyCode => '유효하지 않은 회사 확인 코드입니다.';

  @override
  String get signUpFailed => '회원가입에 실패했습니다.';

  @override
  String get errorWeakPassword => '비밀번호가 너무 약합니다. 6자 이상으로 설정해주세요.';

  @override
  String get errorEmailInUse => '이미 사용 중인 이메일입니다.';

  @override
  String get hello => '안녕하세요';

  @override
  String get honorificSuffix => '님';

  @override
  String get pendingRideRequestsHeader => '대기 중인 라이드 요청';

  @override
  String get noPendingTrips => '대기 중인 여정이 없습니다';

  @override
  String get newRequestNotification => '새로운 요청이 오면 알려드릴게요';

  @override
  String get acceptRequest => '요청 수락하기';

  @override
  String get requestAccepted => '요청이 수락되었습니다.';

  @override
  String get defaultDriverName => '기사';

  @override
  String get home => '홈';

  @override
  String get journey => '여정';

  @override
  String get chat => '채팅';

  @override
  String get settings => '설정';

  @override
  String get chatRoomListHeader => '채팅방 목록';

  @override
  String errorOccurred(String error) {
    return '오류 발생: $error';
  }

  @override
  String get noChatRooms => '채팅방이 없습니다';

  @override
  String get chatRoomCreatedHint => '라이드를 배정하면 채팅방이 생성됩니다';

  @override
  String get noMessages => '메시지가 없습니다.';

  @override
  String get settingsHeader => '설정';

  @override
  String get accountSection => '계정';

  @override
  String get editProfile => '프로필 수정';

  @override
  String get editProfileSubtitle => '이름, 이메일';

  @override
  String get changePassword => '비밀번호 변경';

  @override
  String get changePasswordSubtitle => '비밀번호 재설정';

  @override
  String get termsAndInfoSection => '약관 및 정보';

  @override
  String get termsOfService => '이용약관';

  @override
  String get termsOfServiceSubtitle => '서비스 약관';

  @override
  String get privacyPolicy => '개인정보';

  @override
  String get privacyPolicySubtitle => '보호 정책';

  @override
  String get developerInfo => '개발자 정보';

  @override
  String get developerInfoSubtitle => '팀 정보';

  @override
  String get logout => '로그아웃';

  @override
  String get deleteAccount => '회원 탈퇴';

  @override
  String get logoutDialogTitle => '로그아웃';

  @override
  String get logoutDialogMessage => '정말 로그아웃 하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get deleteAccountDialogTitle => '회원 탈퇴';

  @override
  String get deleteAccountDialogMessage => '정말로 탈퇴하시겠습니까?';

  @override
  String get deleteAccountWarning1 => '• 모든 데이터가 영구적으로 삭제됩니다.';

  @override
  String get deleteAccountWarning2 => '• 예약 정보가 모두 사라집니다.';

  @override
  String get deleteAccountWarning3 => '• 이 작업은 되돌릴 수 없습니다.';

  @override
  String get deleteAccountInputHint => '계속하려면 아래에 DELETE를 입력하세요:';

  @override
  String get deleteAccountInputPlaceholder => 'DELETE';

  @override
  String get deleteAccountButton => '탈퇴하기';

  @override
  String get save => '저장';

  @override
  String get profileInfoMessage => '프로필 정보는 택시 기사와 다른 사용자에게 표시됩니다.';

  @override
  String get currentPassword => '현재 비밀번호';

  @override
  String get currentPasswordHint => '현재 비밀번호를 입력하세요';

  @override
  String get newPassword => '새 비밀번호';

  @override
  String get newPasswordHint => '새 비밀번호를 입력하세요';

  @override
  String get confirmNewPassword => '새 비밀번호 확인';

  @override
  String get confirmNewPasswordHint => '새 비밀번호를 다시 입력하세요';

  @override
  String get passwordRulesTitle => '비밀번호 규칙';

  @override
  String get passwordRuleMinLength => '• 8자 이상';

  @override
  String get passwordRuleLetters => '• 영문 포함';

  @override
  String get passwordRuleNumbers => '• 숫자 포함';

  @override
  String get passwordChangeInfo => '보안을 위해 정기적으로 비밀번호를 변경하세요.';

  @override
  String get or => '또는';

  @override
  String get getResetLinkByEmail => '이메일로 재설정 링크 받기';

  @override
  String get termsHeaderInfo => 'TAGO 서비스 이용약관입니다.\n서비스 이용 전 반드시 확인해주세요.';

  @override
  String lastUpdated(String date) {
    return '최종 업데이트: $date';
  }

  @override
  String get termsArticle1Title => '제 1 조 (목적)';

  @override
  String get termsArticle1Content => '본 약관은 TAGO(이하 \'회사\')가 제공하는 라이드 공유 서비스(이하 \'서비스\')의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.';

  @override
  String get termsArticle2Title => '제 2 조 (정의)';

  @override
  String get termsArticle2Content => '1. \'서비스\'란 회사가 제공하는 공항-학교 간 라이드 공유 플랫폼을 의미합니다.\n\n2. \'이용자\'란 본 약관에 따라 회사가 제공하는 서비스를 받는 회원을 말합니다.\n\n3. \'회원\'이란 본 약관에 동의하고 회사와 이용계약을 체결한 자를 의미합니다.\n\n4. \'택시 기사\'란 회사와 제휴한 운송 서비스 제공자를 의미합니다.';

  @override
  String get termsArticle3Title => '제 3 조 (약관의 효력 및 변경)';

  @override
  String get termsArticle3Content => '1. 본 약관은 서비스를 이용하고자 하는 모든 이용자에게 그 효력을 발생합니다.\n\n2. 회사는 필요한 경우 관련 법령을 위배하지 않는 범위에서 본 약관을 변경할 수 있습니다.\n\n3. 약관이 변경되는 경우 회사는 변경사항을 시행일자 7일 전부터 공지합니다.\n\n4. 이용자가 변경된 약관에 동의하지 않는 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다.';

  @override
  String get termsArticle4Title => '제 4 조 (서비스의 제공)';

  @override
  String get termsArticle4Content => '1. 회사는 다음과 같은 서비스를 제공합니다:\n   • 공항-학교 간 라이드 예약\n   • 택시 기사 매칭\n   • 결제 대행\n   • 예약 관리\n\n2. 서비스는 연중무휴 1일 24시간 제공함을 원칙으로 합니다.\n\n3. 회사는 시스템 점검, 보수 등의 사유로 서비스 제공을 일시 중단할 수 있습니다.';

  @override
  String get termsArticle5Title => '제 5 조 (회원가입)';

  @override
  String get termsArticle5Content => '1. 이용자는 회사가 정한 가입 양식에 따라 회원정보를 기입한 후 본 약관에 동의한다는 의사표시를 함으로써 회원가입을 신청합니다.\n\n2. 회사는 다음 각 호에 해당하는 경우 회원가입을 거절할 수 있습니다:\n   • 타인의 명의를 이용한 경우\n   • 허위 정보를 기재한 경우\n   • 기타 회원으로 등록하는 것이 부적절한 경우';

  @override
  String get termsArticle6Title => '제 6 조 (개인정보 보호)';

  @override
  String get termsArticle6Content => '회사는 관련 법령이 정하는 바에 따라 이용자의 개인정보를 보호하기 위해 노력합니다. 개인정보의 보호 및 이용에 대해서는 관련 법령 및 회사의 개인정보처리방침이 적용됩니다.';

  @override
  String get termsArticle7Title => '제 7 조 (회원의 의무)';

  @override
  String get termsArticle7Content => '1. 회원은 다음 행위를 하여서는 안 됩니다:\n   • 허위 정보 등록 및 타인 정보 도용\n   • 회사의 서비스 정보 변경\n   • 회사가 정한 정보 이외의 정보 송신 또는 게시\n   • 회사의 저작권, 제3자의 저작권 등 권리 침해\n   • 타인의 명예를 손상시키거나 불이익을 주는 행위\n\n2. 회원은 관계 법령, 본 약관, 이용안내 및 서비스상 공지사항 등을 준수하여야 합니다.';

  @override
  String get termsArticle8Title => '제 8 조 (예약 및 취소)';

  @override
  String get termsArticle8Content => '1. 회원은 앱을 통해 라이드를 예약할 수 있습니다.\n\n2. 예약 취소는 출발 24시간 전까지 무료로 가능합니다.\n\n3. 출발 24시간 이내 취소 시 취소 수수료가 부과될 수 있습니다.\n\n4. 예약 후 연락 두절, 탑승 거부 등의 경우 패널티가 부과될 수 있습니다.';

  @override
  String get termsArticle9Title => '제 9 조 (결제)';

  @override
  String get termsArticle9Content => '1. 서비스 이용 요금은 라이드 완료 후 자동으로 결제됩니다.\n\n2. 회원은 신용카드, 체크카드 등 회사가 정한 결제수단을 이용할 수 있습니다.\n\n3. 결제와 관련된 회원의 개인정보는 안전하게 보호됩니다.';

  @override
  String get termsArticle10Title => '제 10 조 (환불)';

  @override
  String get termsArticle10Content => '1. 회사의 귀책사유로 서비스가 제공되지 않은 경우 전액 환불합니다.\n\n2. 회원의 사유로 서비스를 이용하지 못한 경우 환불이 불가합니다.\n\n3. 환불은 결제수단에 따라 3-7 영업일이 소요될 수 있습니다.';

  @override
  String get termsArticle11Title => '제 11 조 (책임의 제한)';

  @override
  String get termsArticle11Content => '1. 회사는 천재지변, 불가항력적 사유로 서비스를 제공할 수 없는 경우 책임이 면제됩니다.\n\n2. 회사는 회원의 귀책사유로 인한 서비스 이용 장애에 대하여 책임을 지지 않습니다.\n\n3. 회사는 택시 기사가 제공하는 운송 서비스의 질에 대해 책임을 지지 않으나, 문제 발생 시 적극적으로 중재합니다.';

  @override
  String get termsArticle12Title => '제 12 조 (분쟁 해결)';

  @override
  String get termsArticle12Content => '1. 본 약관에 명시되지 않은 사항은 관련 법령 및 상관례에 따릅니다.\n\n2. 서비스 이용으로 발생한 분쟁에 대해 소송이 필요한 경우, 회사의 소재지를 관할하는 법원을 전속 관할 법원으로 합니다.';

  @override
  String get termsContactTitle => '약관 관련 문의';

  @override
  String get termsContactMessage => '이용약관에 대한 문의사항이 있으시면\n\'지원 > 문의하기\'를 통해 연락주세요.';

  @override
  String get privacyHeaderInfo => 'TAGO는 이용자의 개인정보를 소중히 다루며,\n관련 법령을 준수합니다.';

  @override
  String get privacySection1Title => '1. 개인정보의 수집 및 이용 목적';

  @override
  String get privacySection1Content => 'TAGO(이하 \'회사\')는 다음의 목적을 위하여 개인정보를 처리합니다:\n\n• 회원 가입 및 관리\n• 서비스 제공 및 개선\n• 라이드 예약 및 매칭\n• 결제 및 정산\n• 고객 지원 및 문의 응대\n• 마케팅 및 이벤트 정보 제공 (동의 시)';

  @override
  String get privacySection2Title => '2. 수집하는 개인정보 항목';

  @override
  String get privacySection2Content => '회사는 다음의 개인정보를 수집합니다:\n\n【필수 정보】\n• 이름\n• 이메일 주소\n• 전화번호 (서비스 제공 시)\n• 학교 정보\n\n【선택 정보】\n• 프로필 사진\n\n【자동 수집 정보】\n• 서비스 이용 기록\n• 접속 로그\n• 기기 정보\n• 위치 정보 (서비스 이용 시)';

  @override
  String get privacySection3Title => '3. 개인정보의 보유 및 이용 기간';

  @override
  String get privacySection3Content => '회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.\n\n• 회원 탈퇴 시: 즉시 파기\n• 단, 관계 법령에 따라 보존할 필요가 있는 경우 해당 기간 동안 보관:\n  - 계약 또는 청약철회 등에 관한 기록: 5년\n  - 대금결제 및 재화 등의 공급에 관한 기록: 5년\n  - 소비자 불만 또는 분쟁처리에 관한 기록: 3년';

  @override
  String get privacySection4Title => '4. 개인정보의 제3자 제공';

  @override
  String get privacySection4Content => '회사는 원칙적으로 이용자의 개인정보를 외부에 제공하지 않습니다. 다만, 아래의 경우는 예외로 합니다:\n\n• 이용자가 사전에 동의한 경우\n• 서비스 제공을 위해 필요한 경우 (택시 기사에게 예약 정보 제공)\n• 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우';

  @override
  String get privacySection5Title => '5. 개인정보 처리의 위탁';

  @override
  String get privacySection5Content => '회사는 서비스 향상을 위해 아래와 같이 개인정보 처리업무를 외부에 위탁하고 있습니다:\n\n【위탁업체】\n• 결제 서비스: Stripe, PayPal\n• 클라우드 서비스: Firebase (Google)\n• 고객 지원: Zendesk\n\n회사는 위탁계약 체결 시 개인정보 보호법에 따라 위탁업무 수행목적 외 개인정보 처리금지, 기술적·관리적 보호조치, 재위탁 제한 등을 규정하고 있습니다.';

  @override
  String get privacySection6Title => '6. 정보주체의 권리·의무 및 행사 방법';

  @override
  String get privacySection6Content => '이용자는 다음과 같은 권리를 행사할 수 있습니다:\n\n• 개인정보 열람 요구\n• 오류 등이 있을 경우 정정 요구\n• 삭제 요구\n• 처리 정지 요구\n\n권리 행사는 \'설정 > 프로필 수정\' 또는 \'문의하기\'를 통해 가능합니다.';

  @override
  String get privacySection7Title => '7. 개인정보의 파기';

  @override
  String get privacySection7Content => '회사는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.\n\n【파기 절차】\n이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져 내부 방침 및 관련 법령에 따라 일정기간 저장된 후 파기됩니다.\n\n【파기 방법】\n• 전자적 파일: 복구 및 재생되지 않도록 기술적 방법으로 완전 삭제\n• 종이 문서: 분쇄하거나 소각';

  @override
  String get privacySection8Title => '8. 개인정보 보호책임자';

  @override
  String get privacySection8Content => '회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다:\n\n【개인정보 보호책임자】\n• 이름: TAGO 개인정보 보호팀\n• 이메일: privacy@tagoapp.com\n\n기타 개인정보침해에 대한 신고나 상담이 필요한 경우 아래 기관에 문의하실 수 있습니다:\n• 개인정보침해신고센터: privacy.kisa.or.kr (국번없이 118)\n• 개인정보분쟁조정위원회: kopico.go.kr (1833-6972)';

  @override
  String get privacySection9Title => '9. 개인정보 처리방침의 변경';

  @override
  String get privacySection9Content => '이 개인정보 처리방침은 2025년 1월 1일부터 적용됩니다.\n\n법령, 정책 또는 보안기술의 변경에 따라 내용의 추가·삭제 및 수정이 있을 시에는 변경 최소 7일 전부터 앱 내 공지사항을 통해 고지할 것입니다.';

  @override
  String get privacyContactTitle => '개인정보 관련 문의';

  @override
  String get privacyContactMessage => '개인정보 처리방침에 대한 문의:\nprivacy@tagoapp.com';

  @override
  String get appDescription => '한인 학생들을 위한 스마트 라이드 서비스';

  @override
  String get developmentTeam => '개발팀';

  @override
  String get inquiry => '문의';

  @override
  String get website => '웹사이트';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get copyright => '© 2025 TAGO. All rights reserved.';

  @override
  String get comingSoon => '이 기능은 곧 추가될 예정입니다.';

  @override
  String get tripInformation => '여정 정보';

  @override
  String get passengerCount => '탑승 인원';

  @override
  String get totalBags => '총 가방';

  @override
  String bags(int count) {
    return '$count개';
  }

  @override
  String participantList(int passengerCount) {
    return '참여자 목록 (승객 $passengerCount명 + 기사 1명)';
  }

  @override
  String participantListNoDriver(int count) {
    return '참여자 목록 ($count명)';
  }

  @override
  String get driver => '드라이버';

  @override
  String get startRide => '라이드 시작하기';

  @override
  String get leaveChatRoom => '채팅방 나가기';

  @override
  String get checkTripRoute => '여정 경로 확인하기';

  @override
  String get endRide => '라이드 종료';

  @override
  String get viewOriginal => '원문 보기';

  @override
  String get viewTranslation => '번역 보기';

  @override
  String get enterMessage => '메세지를 입력하세요';

  @override
  String get firstMessageHint => '첫 메세지를 보내보세요 🙂';

  @override
  String get loadingParticipants => '참여자 정보를 불러오는 중...';

  @override
  String get noParticipants => '참여자가 없습니다';

  @override
  String get rideStarted => '라이드를 시작합니다.';

  @override
  String get leftChatRoom => '채팅방에서 나갔습니다.';

  @override
  String get rideEnded => '라이드가 종료되었습니다.';

  @override
  String get endRideDialogTitle => '라이드 종료';

  @override
  String get endRideDialogMessage => '라이드를 종료하시겠습니까?\n\n모든 채팅 기록과 여정 정보가 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.';

  @override
  String get end => '종료';

  @override
  String rideEndError(String error) {
    return '라이드 종료 중 오류 발생: $error';
  }

  @override
  String leaveChatError(String error) {
    return '채팅방 나가기 중 오류 발생: $error';
  }

  @override
  String updateError(String error) {
    return '업데이트 중 오류 발생: $error';
  }

  @override
  String mapLoadError(String error) {
    return '지도 정보를 불러오는 중 오류가 발생했습니다: $error';
  }

  @override
  String get chatRoomNotFound => '채팅방 문서를 찾을 수 없습니다.';

  @override
  String get currentLocation => '현재 위치';

  @override
  String get mapLoading => '지도 로딩 중...';
}
