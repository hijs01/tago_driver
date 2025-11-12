// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get assignedTripsHeader => 'Assigned rides';

  @override
  String get noAssignedTrips => 'No assigned trips';

  @override
  String get assignRideHint => 'Assigned rides will appear here';

  @override
  String get enterChat => 'Enter chat';

  @override
  String get origin => 'Origin';

  @override
  String get destination => 'Destination';

  @override
  String get timeUnknown => 'Time not set';

  @override
  String passengers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '$count person',
    );
    return '$_temp0';
  }

  @override
  String get loginSubtitle => 'Find taxi passengers';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Your password';

  @override
  String get login => 'Log in';

  @override
  String get loggingIn => 'Signing in...';

  @override
  String get signUpCta => 'Don\'t have an account? Sign up';

  @override
  String get loginFailed => 'Failed to sign in.';

  @override
  String get errorUserNotFound => 'No account found for this email.';

  @override
  String get errorWrongPassword => 'Incorrect password.';

  @override
  String get errorInvalidEmail => 'Invalid email format.';

  @override
  String get errorCancelled => 'Sign-in was cancelled.';

  @override
  String get errorUnknown => 'An unknown error occurred. Please try again later.';

  @override
  String get signUpTitle => 'Sign Up';

  @override
  String get signUpSubtitle => 'TAGO, are you going to ride?';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Enter your name';

  @override
  String get companyNameLabel => 'Company Name';

  @override
  String get companyNameHint => 'PSU Taxi';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Confirm password';

  @override
  String get companyCodeLabel => 'Company Verification Code';

  @override
  String get companyCodeHint => 'Enter verification code received from administrator';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signingUp => 'Signing up...';

  @override
  String get loginCta => 'Already have an account? Log in';

  @override
  String get errorPasswordMismatch => 'Passwords do not match.';

  @override
  String get errorInvalidCompanyCode => 'Invalid company verification code.';

  @override
  String get signUpFailed => 'Failed to sign up.';

  @override
  String get errorWeakPassword => 'Password is too weak. Please use at least 6 characters.';

  @override
  String get errorEmailInUse => 'Email is already in use.';

  @override
  String get hello => 'Hello';

  @override
  String get honorificSuffix => '';

  @override
  String get pendingRideRequestsHeader => 'Pending ride requests';

  @override
  String get noPendingTrips => 'No pending trips';

  @override
  String get newRequestNotification => 'We\'ll notify you when new requests arrive';

  @override
  String get acceptRequest => 'Accept request';

  @override
  String get requestAccepted => 'Request accepted';

  @override
  String get defaultDriverName => 'Driver';

  @override
  String get home => 'Home';

  @override
  String get journey => 'Journey';

  @override
  String get chat => 'Chat';

  @override
  String get settings => 'Settings';

  @override
  String get chatRoomListHeader => 'Chat rooms';

  @override
  String errorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get noChatRooms => 'No chat rooms';

  @override
  String get chatRoomCreatedHint => 'Chat rooms will be created when you accept a ride';

  @override
  String get noMessages => 'No messages';

  @override
  String get settingsHeader => 'Settings';

  @override
  String get accountSection => 'Account';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editProfileSubtitle => 'Name, Email';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordSubtitle => 'Reset Password';

  @override
  String get termsAndInfoSection => 'Terms and Info';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceSubtitle => 'Service Terms';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicySubtitle => 'Protection Policy';

  @override
  String get developerInfo => 'Developer Info';

  @override
  String get developerInfoSubtitle => 'Team Info';

  @override
  String get logout => 'Logout';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get logoutDialogTitle => 'Logout';

  @override
  String get logoutDialogMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteAccountDialogTitle => 'Delete Account';

  @override
  String get deleteAccountDialogMessage => 'Are you really sure you want to delete your account?';

  @override
  String get deleteAccountWarning1 => '• All data will be permanently deleted.';

  @override
  String get deleteAccountWarning2 => '• All reservation information will be lost.';

  @override
  String get deleteAccountWarning3 => '• This action cannot be undone.';

  @override
  String get deleteAccountInputHint => 'To continue, please type DELETE below:';

  @override
  String get deleteAccountInputPlaceholder => 'DELETE';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get save => 'Save';

  @override
  String get profileInfoMessage => 'Profile information is displayed to taxi drivers and other users.';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get currentPasswordHint => 'Enter current password';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordHint => 'Enter new password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get confirmNewPasswordHint => 'Re-enter new password';

  @override
  String get passwordRulesTitle => 'Password Rules';

  @override
  String get passwordRuleMinLength => '• 8 characters or more';

  @override
  String get passwordRuleLetters => '• Includes English letters';

  @override
  String get passwordRuleNumbers => '• Includes numbers';

  @override
  String get passwordChangeInfo => 'Change your password regularly for security.';

  @override
  String get or => 'or';

  @override
  String get getResetLinkByEmail => 'Get reset link by email';

  @override
  String get termsHeaderInfo => 'This is the TAGO Service Terms of Service.\nPlease review before using the service.';

  @override
  String lastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get termsArticle1Title => 'Article 1 (Purpose)';

  @override
  String get termsArticle1Content => 'The purpose of these terms and conditions is to stipulate the rights, obligations, and responsibilities between the company and users, and other necessary matters related to the use of the ride-sharing service (hereinafter referred to as \'Service\') provided by TAGO (hereinafter referred to as \'Company\').';

  @override
  String get termsArticle2Title => 'Article 2 (Definitions)';

  @override
  String get termsArticle2Content => '1. \'Service\' refers to the airport-school ride-sharing platform provided by the company.\n\n2. \'User\' refers to a member who receives services provided by the company in accordance with these terms and conditions.\n\n3. \'Member\' refers to a person who agrees to these terms and conditions and enters into a service agreement with the company.\n\n4. \'Taxi Driver\' refers to a transportation service provider affiliated with the company.';

  @override
  String get termsArticle3Title => 'Article 3 (Effectiveness and Changes to Terms)';

  @override
  String get termsArticle3Content => '1. These terms and conditions shall be effective for all users who wish to use the service.\n\n2. The company may change these terms and conditions within the scope that does not violate relevant laws and regulations if necessary.\n\n3. If the terms are changed, the company will notify the changes 7 days before the implementation date.\n\n4. If a user does not agree to the changed terms, they may stop using the service and withdraw.';

  @override
  String get termsArticle4Title => 'Article 4 (Service Provision)';

  @override
  String get termsArticle4Content => '1. The company provides the following services:\n   • Airport-school ride reservations\n   • Taxi driver matching\n   • Payment processing\n   • Reservation management\n\n2. Services are provided 24 hours a day, 365 days a year in principle.\n\n3. The company may temporarily suspend service provision due to system maintenance, repairs, etc.';

  @override
  String get termsArticle5Title => 'Article 5 (Membership Registration)';

  @override
  String get termsArticle5Content => '1. Users apply for membership by filling out the membership information according to the registration form set by the company and expressing their intention to agree to these terms and conditions.\n\n2. The company may refuse membership registration in the following cases:\n   • Use of another person\'s name\n   • False information\n   • Other cases where registration as a member is inappropriate';

  @override
  String get termsArticle6Title => 'Article 6 (Privacy Protection)';

  @override
  String get termsArticle6Content => 'The company strives to protect users\' personal information in accordance with relevant laws and regulations. The relevant laws and regulations and the company\'s privacy policy apply to the protection and use of personal information.';

  @override
  String get termsArticle7Title => 'Article 7 (Member Obligations)';

  @override
  String get termsArticle7Content => '1. Members must not engage in the following acts:\n   • Registration of false information and use of others\' information\n   • Modification of the company\'s service information\n   • Transmission or posting of information other than that specified by the company\n   • Infringement of the company\'s copyright, third-party copyright, etc.\n   • Acts that damage others\' reputation or cause disadvantage\n\n2. Members must comply with relevant laws, these terms, usage guidelines, and service announcements.';

  @override
  String get termsArticle8Title => 'Article 8 (Reservation and Cancellation)';

  @override
  String get termsArticle8Content => '1. Members can make ride reservations through the app.\n\n2. Cancellation is free up to 24 hours before departure.\n\n3. Cancellation within 24 hours of departure may incur cancellation fees.\n\n4. Penalties may be imposed for cases such as no contact or refusal to board after reservation.';

  @override
  String get termsArticle9Title => 'Article 9 (Payment)';

  @override
  String get termsArticle9Content => '1. Service usage fees are automatically charged after ride completion.\n\n2. Members can use payment methods specified by the company such as credit cards and check cards.\n\n3. Members\' personal information related to payment is securely protected.';

  @override
  String get termsArticle10Title => 'Article 10 (Refund)';

  @override
  String get termsArticle10Content => '1. If the service is not provided due to the company\'s fault, a full refund will be made.\n\n2. If the service cannot be used due to the member\'s fault, no refund will be made.\n\n3. Refunds may take 3-7 business days depending on the payment method.';

  @override
  String get termsArticle11Title => 'Article 11 (Limitation of Liability)';

  @override
  String get termsArticle11Content => '1. The company is exempt from liability if the service cannot be provided due to natural disasters or force majeure.\n\n2. The company is not responsible for service use disruptions due to the member\'s fault.\n\n3. The company is not responsible for the quality of transportation services provided by taxi drivers, but actively mediates when problems occur.';

  @override
  String get termsArticle12Title => 'Article 12 (Dispute Resolution)';

  @override
  String get termsArticle12Content => '1. Matters not specified in these terms and conditions follow relevant laws and commercial practices.\n\n2. If litigation is necessary for disputes arising from service use, the court having jurisdiction over the company\'s location shall be the exclusive jurisdiction court.';

  @override
  String get termsContactTitle => 'Terms Inquiry';

  @override
  String get termsContactMessage => 'If you have any questions about the Terms of Service,\nplease contact us through \'Support > Contact Us\'.';

  @override
  String get privacyHeaderInfo => 'TAGO values users\' personal information and\ncomplies with relevant laws and regulations.';

  @override
  String get privacySection1Title => '1. Purpose of Personal Information Collection and Use';

  @override
  String get privacySection1Content => 'TAGO (hereinafter referred to as \'the Company\') processes personal information for the following purposes:\n\n• Membership registration and management\n• Service provision and improvement\n• Ride reservation and matching\n• Payment and settlement\n• Customer support and inquiry response\n• Marketing and event information provision (upon consent)';

  @override
  String get privacySection2Title => '2. Items of Personal Information Collected';

  @override
  String get privacySection2Content => 'The Company collects the following personal information:\n\n【Required Information】\n• Name\n• Email address\n• Phone number (when providing service)\n• School information\n\n【Optional Information】\n• Profile picture\n\n【Automatically Collected Information】\n• Service usage history\n• Access logs\n• Device information\n• Location information (when using service)';

  @override
  String get privacySection3Title => '3. Retention and Use Period of Personal Information';

  @override
  String get privacySection3Content => 'The Company processes and retains personal information within the retention and use period of personal information under relevant laws and regulations, or within the retention and use period of personal information agreed upon when collecting personal information from the information subject.\n\n• Upon membership withdrawal: Immediate destruction\n• However, if retention is required under relevant laws, retention for the relevant period:\n  - Records on contracts or withdrawal of subscription: 5 years\n  - Records on payment and supply of goods: 5 years\n  - Records on consumer complaints or dispute resolution: 3 years';

  @override
  String get privacySection4Title => '4. Provision of Personal Information to Third Parties';

  @override
  String get privacySection4Content => 'The Company does not provide users\' personal information to external parties in principle. However, the following cases are exceptions:\n\n• When the user has consented in advance\n• When necessary for service provision (providing reservation information to taxi drivers)\n• When required by law or when requested by investigative agencies in accordance with procedures and methods prescribed by law for investigative purposes';

  @override
  String get privacySection5Title => '5. Entrustment of Personal Information Processing';

  @override
  String get privacySection5Content => 'The Company entrusts personal information processing tasks to external parties as follows for service improvement:\n\n【Entrusted Companies】\n• Payment services: Stripe, PayPal\n• Cloud services: Firebase (Google)\n• Customer support: Zendesk\n\nThe Company stipulates in the entrustment contract that personal information processing is prohibited for purposes other than performing entrusted tasks, technical and administrative protection measures, and restrictions on re-entrustment in accordance with the Personal Information Protection Act.';

  @override
  String get privacySection6Title => '6. Rights, Obligations, and Exercise Methods of Information Subjects';

  @override
  String get privacySection6Content => 'Users can exercise the following rights:\n\n• Request to view personal information\n• Request correction in case of errors\n• Request deletion\n• Request suspension of processing\n\nRights can be exercised through \'Settings > Edit Profile\' or \'Contact Us\'.';

  @override
  String get privacySection7Title => '7. Destruction of Personal Information';

  @override
  String get privacySection7Content => 'The Company destroys personal information without delay when it becomes unnecessary, such as when the retention period has elapsed or the processing purpose has been achieved.\n\n【Destruction Procedure】\nInformation entered by users is moved to a separate database after the purpose is achieved and destroyed after being stored for a certain period in accordance with internal policies and relevant laws.\n\n【Destruction Method】\n• Electronic files: Complete deletion using technical methods so that they cannot be recovered or reproduced\n• Paper documents: Shredding or incineration';

  @override
  String get privacySection8Title => '8. Personal Information Protection Officer';

  @override
  String get privacySection8Content => 'The Company is responsible for overseeing personal information processing tasks and has designated a personal information protection officer as follows to handle information subjects\' complaints and damage relief related to personal information processing:\n\n【Personal Information Protection Officer】\n• Name: TAGO Privacy Protection Team\n• Email: privacy@tagoapp.com\n\nFor other reports or consultations regarding personal information infringement, you can contact the following agencies:\n• Personal Information Infringement Report Center: privacy.kisa.or.kr (118 without area code)\n• Personal Information Dispute Mediation Committee: kopico.go.kr (1833-6972)';

  @override
  String get privacySection9Title => '9. Changes to Privacy Policy';

  @override
  String get privacySection9Content => 'This Privacy Policy applies from January 1, 2025.\n\nIf there are additions, deletions, or modifications to the content due to changes in laws, policies, or security technology, we will notify you through in-app announcements at least 7 days before the change.';

  @override
  String get privacyContactTitle => 'Privacy Inquiry';

  @override
  String get privacyContactMessage => 'Questions about the Privacy Policy:\nprivacy@tagoapp.com';

  @override
  String get appDescription => 'Smart ride service for Korean students';

  @override
  String get developmentTeam => 'Development Team';

  @override
  String get inquiry => 'Inquiry';

  @override
  String get website => 'Website';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get copyright => '© 2025 TAGO. All rights reserved.';

  @override
  String get comingSoon => 'This feature will be available soon.';

  @override
  String get tripInformation => 'Trip Information';

  @override
  String get passengerCount => 'Number of Passengers';

  @override
  String get totalBags => 'Total Bags';

  @override
  String bags(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bags',
      one: '$count bag',
    );
    return '$_temp0';
  }

  @override
  String participantList(int passengerCount) {
    String _temp0 = intl.Intl.pluralLogic(
      passengerCount,
      locale: localeName,
      other: 'passengers',
      one: 'passenger',
    );
    return 'Participant List ($passengerCount $_temp0 + 1 driver)';
  }

  @override
  String participantListNoDriver(int count) {
    return 'Participant List ($count people)';
  }

  @override
  String get driver => 'Driver';

  @override
  String get startRide => 'Start Ride';

  @override
  String get leaveChatRoom => 'Leave Chat Room';

  @override
  String get checkTripRoute => 'Check Trip Route';

  @override
  String get endRide => 'End Ride';

  @override
  String get viewOriginal => 'View Original';

  @override
  String get viewTranslation => 'View Translation';

  @override
  String get enterMessage => 'Enter message';

  @override
  String get firstMessageHint => 'Send your first message 🙂';

  @override
  String get loadingParticipants => 'Loading participant information...';

  @override
  String get noParticipants => 'No participants';

  @override
  String get rideStarted => 'Ride started.';

  @override
  String get leftChatRoom => 'Left the chat room.';

  @override
  String get rideEnded => 'Ride has ended.';

  @override
  String get endRideDialogTitle => 'End Ride';

  @override
  String get endRideDialogMessage => 'Are you sure you want to end the ride?\n\nAll chat history and trip information will be deleted.\nThis action cannot be undone.';

  @override
  String get end => 'End';

  @override
  String rideEndError(String error) {
    return 'Error ending ride: $error';
  }

  @override
  String leaveChatError(String error) {
    return 'Error leaving chat room: $error';
  }

  @override
  String updateError(String error) {
    return 'Update error: $error';
  }

  @override
  String mapLoadError(String error) {
    return 'Error loading map information: $error';
  }

  @override
  String get chatRoomNotFound => 'Chat room document not found.';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get mapLoading => 'Loading map...';

  @override
  String get systemGuide => 'System Guide';

  @override
  String driverEntered(String driverName) {
    return '$driverName driver has entered.';
  }

  @override
  String get driverEnteredNoName => 'Driver has entered.';

  @override
  String get systemGuide1 => '1. Please reconfirm the pickup location with the driver via chat.';

  @override
  String systemGuide2(String fareText, String tipText) {
    return '2. Please pay the fare on-site.\n   - Estimated fare: $fareText\n   - Recommended tip: $tipText';
  }

  @override
  String get systemGuide3 => '3. If you have any questions, please feel free to ask in the chat room.';

  @override
  String get statusActive => 'Active';

  @override
  String get statusOnProgress => 'On Progress';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusAccepted => 'Accepted';
}
