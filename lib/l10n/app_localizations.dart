import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @assignedTripsHeader.
  ///
  /// In en, this message translates to:
  /// **'Assigned rides'**
  String get assignedTripsHeader;

  /// No description provided for @noAssignedTrips.
  ///
  /// In en, this message translates to:
  /// **'No assigned trips'**
  String get noAssignedTrips;

  /// No description provided for @assignRideHint.
  ///
  /// In en, this message translates to:
  /// **'Assigned rides will appear here'**
  String get assignRideHint;

  /// No description provided for @enterChat.
  ///
  /// In en, this message translates to:
  /// **'Enter chat'**
  String get enterChat;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @timeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Time not set'**
  String get timeUnknown;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} person} other {{count} people}}'**
  String passengers(int count);

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find taxi passengers'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get passwordHint;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get loggingIn;

  /// No description provided for @signUpCta.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get signUpCta;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in.'**
  String get loginFailed;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found for this email.'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get errorWrongPassword;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get errorInvalidEmail;

  /// No description provided for @errorCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in was cancelled.'**
  String get errorCancelled;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again later.'**
  String get errorUnknown;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'TAGO, are you going to ride?'**
  String get signUpSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameHint;

  /// No description provided for @companyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyNameLabel;

  /// No description provided for @companyNameHint.
  ///
  /// In en, this message translates to:
  /// **'PSU Taxi'**
  String get companyNameHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordHint;

  /// No description provided for @companyCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Verification Code'**
  String get companyCodeLabel;

  /// No description provided for @companyCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code received from administrator'**
  String get companyCodeHint;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signingUp.
  ///
  /// In en, this message translates to:
  /// **'Signing up...'**
  String get signingUp;

  /// No description provided for @loginCta.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get loginCta;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get errorPasswordMismatch;

  /// No description provided for @errorInvalidCompanyCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid company verification code.'**
  String get errorInvalidCompanyCode;

  /// No description provided for @signUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign up.'**
  String get signUpFailed;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Please use at least 6 characters.'**
  String get errorWeakPassword;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'Email is already in use.'**
  String get errorEmailInUse;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @honorificSuffix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get honorificSuffix;

  /// No description provided for @pendingRideRequestsHeader.
  ///
  /// In en, this message translates to:
  /// **'Pending ride requests'**
  String get pendingRideRequestsHeader;

  /// No description provided for @noPendingTrips.
  ///
  /// In en, this message translates to:
  /// **'No pending trips'**
  String get noPendingTrips;

  /// No description provided for @newRequestNotification.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you when new requests arrive'**
  String get newRequestNotification;

  /// No description provided for @acceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept request'**
  String get acceptRequest;

  /// No description provided for @requestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Request accepted'**
  String get requestAccepted;

  /// No description provided for @defaultDriverName.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get defaultDriverName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @journey.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get journey;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @chatRoomListHeader.
  ///
  /// In en, this message translates to:
  /// **'Chat rooms'**
  String get chatRoomListHeader;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurred(String error);

  /// No description provided for @noChatRooms.
  ///
  /// In en, this message translates to:
  /// **'No chat rooms'**
  String get noChatRooms;

  /// No description provided for @chatRoomCreatedHint.
  ///
  /// In en, this message translates to:
  /// **'Chat rooms will be created when you accept a ride'**
  String get chatRoomCreatedHint;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get noMessages;

  /// No description provided for @settingsHeader.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsHeader;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name, Email'**
  String get editProfileSubtitle;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get changePasswordSubtitle;

  /// No description provided for @termsAndInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Terms and Info'**
  String get termsAndInfoSection;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @termsOfServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Service Terms'**
  String get termsOfServiceSubtitle;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protection Policy'**
  String get privacyPolicySubtitle;

  /// No description provided for @developerInfo.
  ///
  /// In en, this message translates to:
  /// **'Developer Info'**
  String get developerInfo;

  /// No description provided for @developerInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Team Info'**
  String get developerInfoSubtitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutDialogMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you really sure you want to delete your account?'**
  String get deleteAccountDialogMessage;

  /// No description provided for @deleteAccountWarning1.
  ///
  /// In en, this message translates to:
  /// **'• All data will be permanently deleted.'**
  String get deleteAccountWarning1;

  /// No description provided for @deleteAccountWarning2.
  ///
  /// In en, this message translates to:
  /// **'• All reservation information will be lost.'**
  String get deleteAccountWarning2;

  /// No description provided for @deleteAccountWarning3.
  ///
  /// In en, this message translates to:
  /// **'• This action cannot be undone.'**
  String get deleteAccountWarning3;

  /// No description provided for @deleteAccountInputHint.
  ///
  /// In en, this message translates to:
  /// **'To continue, please type DELETE below:'**
  String get deleteAccountInputHint;

  /// No description provided for @deleteAccountInputPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteAccountInputPlaceholder;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @profileInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile information is displayed to taxi drivers and other users.'**
  String get profileInfoMessage;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @currentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get currentPasswordHint;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get newPasswordHint;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @confirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get confirmNewPasswordHint;

  /// No description provided for @passwordRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Rules'**
  String get passwordRulesTitle;

  /// No description provided for @passwordRuleMinLength.
  ///
  /// In en, this message translates to:
  /// **'• 8 characters or more'**
  String get passwordRuleMinLength;

  /// No description provided for @passwordRuleLetters.
  ///
  /// In en, this message translates to:
  /// **'• Includes English letters'**
  String get passwordRuleLetters;

  /// No description provided for @passwordRuleNumbers.
  ///
  /// In en, this message translates to:
  /// **'• Includes numbers'**
  String get passwordRuleNumbers;

  /// No description provided for @passwordChangeInfo.
  ///
  /// In en, this message translates to:
  /// **'Change your password regularly for security.'**
  String get passwordChangeInfo;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @getResetLinkByEmail.
  ///
  /// In en, this message translates to:
  /// **'Get reset link by email'**
  String get getResetLinkByEmail;

  /// No description provided for @termsHeaderInfo.
  ///
  /// In en, this message translates to:
  /// **'This is the TAGO Service Terms of Service.\nPlease review before using the service.'**
  String get termsHeaderInfo;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdated(String date);

  /// No description provided for @termsArticle1Title.
  ///
  /// In en, this message translates to:
  /// **'Article 1 (Purpose)'**
  String get termsArticle1Title;

  /// No description provided for @termsArticle1Content.
  ///
  /// In en, this message translates to:
  /// **'The purpose of these terms and conditions is to stipulate the rights, obligations, and responsibilities between the company and users, and other necessary matters related to the use of the ride-sharing service (hereinafter referred to as \'Service\') provided by TAGO (hereinafter referred to as \'Company\').'**
  String get termsArticle1Content;

  /// No description provided for @termsArticle2Title.
  ///
  /// In en, this message translates to:
  /// **'Article 2 (Definitions)'**
  String get termsArticle2Title;

  /// No description provided for @termsArticle2Content.
  ///
  /// In en, this message translates to:
  /// **'1. \'Service\' refers to the airport-school ride-sharing platform provided by the company.\n\n2. \'User\' refers to a member who receives services provided by the company in accordance with these terms and conditions.\n\n3. \'Member\' refers to a person who agrees to these terms and conditions and enters into a service agreement with the company.\n\n4. \'Taxi Driver\' refers to a transportation service provider affiliated with the company.'**
  String get termsArticle2Content;

  /// No description provided for @termsArticle3Title.
  ///
  /// In en, this message translates to:
  /// **'Article 3 (Effectiveness and Changes to Terms)'**
  String get termsArticle3Title;

  /// No description provided for @termsArticle3Content.
  ///
  /// In en, this message translates to:
  /// **'1. These terms and conditions shall be effective for all users who wish to use the service.\n\n2. The company may change these terms and conditions within the scope that does not violate relevant laws and regulations if necessary.\n\n3. If the terms are changed, the company will notify the changes 7 days before the implementation date.\n\n4. If a user does not agree to the changed terms, they may stop using the service and withdraw.'**
  String get termsArticle3Content;

  /// No description provided for @termsArticle4Title.
  ///
  /// In en, this message translates to:
  /// **'Article 4 (Service Provision)'**
  String get termsArticle4Title;

  /// No description provided for @termsArticle4Content.
  ///
  /// In en, this message translates to:
  /// **'1. The company provides the following services:\n   • Airport-school ride reservations\n   • Taxi driver matching\n   • Payment processing\n   • Reservation management\n\n2. Services are provided 24 hours a day, 365 days a year in principle.\n\n3. The company may temporarily suspend service provision due to system maintenance, repairs, etc.'**
  String get termsArticle4Content;

  /// No description provided for @termsArticle5Title.
  ///
  /// In en, this message translates to:
  /// **'Article 5 (Membership Registration)'**
  String get termsArticle5Title;

  /// No description provided for @termsArticle5Content.
  ///
  /// In en, this message translates to:
  /// **'1. Users apply for membership by filling out the membership information according to the registration form set by the company and expressing their intention to agree to these terms and conditions.\n\n2. The company may refuse membership registration in the following cases:\n   • Use of another person\'s name\n   • False information\n   • Other cases where registration as a member is inappropriate'**
  String get termsArticle5Content;

  /// No description provided for @termsArticle6Title.
  ///
  /// In en, this message translates to:
  /// **'Article 6 (Privacy Protection)'**
  String get termsArticle6Title;

  /// No description provided for @termsArticle6Content.
  ///
  /// In en, this message translates to:
  /// **'The company strives to protect users\' personal information in accordance with relevant laws and regulations. The relevant laws and regulations and the company\'s privacy policy apply to the protection and use of personal information.'**
  String get termsArticle6Content;

  /// No description provided for @termsArticle7Title.
  ///
  /// In en, this message translates to:
  /// **'Article 7 (Member Obligations)'**
  String get termsArticle7Title;

  /// No description provided for @termsArticle7Content.
  ///
  /// In en, this message translates to:
  /// **'1. Members must not engage in the following acts:\n   • Registration of false information and use of others\' information\n   • Modification of the company\'s service information\n   • Transmission or posting of information other than that specified by the company\n   • Infringement of the company\'s copyright, third-party copyright, etc.\n   • Acts that damage others\' reputation or cause disadvantage\n\n2. Members must comply with relevant laws, these terms, usage guidelines, and service announcements.'**
  String get termsArticle7Content;

  /// No description provided for @termsArticle8Title.
  ///
  /// In en, this message translates to:
  /// **'Article 8 (Reservation and Cancellation)'**
  String get termsArticle8Title;

  /// No description provided for @termsArticle8Content.
  ///
  /// In en, this message translates to:
  /// **'1. Members can make ride reservations through the app.\n\n2. Cancellation is free up to 24 hours before departure.\n\n3. Cancellation within 24 hours of departure may incur cancellation fees.\n\n4. Penalties may be imposed for cases such as no contact or refusal to board after reservation.'**
  String get termsArticle8Content;

  /// No description provided for @termsArticle9Title.
  ///
  /// In en, this message translates to:
  /// **'Article 9 (Payment)'**
  String get termsArticle9Title;

  /// No description provided for @termsArticle9Content.
  ///
  /// In en, this message translates to:
  /// **'1. Service usage fees are automatically charged after ride completion.\n\n2. Members can use payment methods specified by the company such as credit cards and check cards.\n\n3. Members\' personal information related to payment is securely protected.'**
  String get termsArticle9Content;

  /// No description provided for @termsArticle10Title.
  ///
  /// In en, this message translates to:
  /// **'Article 10 (Refund)'**
  String get termsArticle10Title;

  /// No description provided for @termsArticle10Content.
  ///
  /// In en, this message translates to:
  /// **'1. If the service is not provided due to the company\'s fault, a full refund will be made.\n\n2. If the service cannot be used due to the member\'s fault, no refund will be made.\n\n3. Refunds may take 3-7 business days depending on the payment method.'**
  String get termsArticle10Content;

  /// No description provided for @termsArticle11Title.
  ///
  /// In en, this message translates to:
  /// **'Article 11 (Limitation of Liability)'**
  String get termsArticle11Title;

  /// No description provided for @termsArticle11Content.
  ///
  /// In en, this message translates to:
  /// **'1. The company is exempt from liability if the service cannot be provided due to natural disasters or force majeure.\n\n2. The company is not responsible for service use disruptions due to the member\'s fault.\n\n3. The company is not responsible for the quality of transportation services provided by taxi drivers, but actively mediates when problems occur.'**
  String get termsArticle11Content;

  /// No description provided for @termsArticle12Title.
  ///
  /// In en, this message translates to:
  /// **'Article 12 (Dispute Resolution)'**
  String get termsArticle12Title;

  /// No description provided for @termsArticle12Content.
  ///
  /// In en, this message translates to:
  /// **'1. Matters not specified in these terms and conditions follow relevant laws and commercial practices.\n\n2. If litigation is necessary for disputes arising from service use, the court having jurisdiction over the company\'s location shall be the exclusive jurisdiction court.'**
  String get termsArticle12Content;

  /// No description provided for @termsContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms Inquiry'**
  String get termsContactTitle;

  /// No description provided for @termsContactMessage.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about the Terms of Service,\nplease contact us through \'Support > Contact Us\'.'**
  String get termsContactMessage;

  /// No description provided for @privacyHeaderInfo.
  ///
  /// In en, this message translates to:
  /// **'TAGO values users\' personal information and\ncomplies with relevant laws and regulations.'**
  String get privacyHeaderInfo;

  /// No description provided for @privacySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Purpose of Personal Information Collection and Use'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Content.
  ///
  /// In en, this message translates to:
  /// **'TAGO (hereinafter referred to as \'the Company\') processes personal information for the following purposes:\n\n• Membership registration and management\n• Service provision and improvement\n• Ride reservation and matching\n• Payment and settlement\n• Customer support and inquiry response\n• Marketing and event information provision (upon consent)'**
  String get privacySection1Content;

  /// No description provided for @privacySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Items of Personal Information Collected'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Content.
  ///
  /// In en, this message translates to:
  /// **'The Company collects the following personal information:\n\n【Required Information】\n• Name\n• Email address\n• Phone number (when providing service)\n• School information\n\n【Optional Information】\n• Profile picture\n\n【Automatically Collected Information】\n• Service usage history\n• Access logs\n• Device information\n• Location information (when using service)'**
  String get privacySection2Content;

  /// No description provided for @privacySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Retention and Use Period of Personal Information'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Content.
  ///
  /// In en, this message translates to:
  /// **'The Company processes and retains personal information within the retention and use period of personal information under relevant laws and regulations, or within the retention and use period of personal information agreed upon when collecting personal information from the information subject.\n\n• Upon membership withdrawal: Immediate destruction\n• However, if retention is required under relevant laws, retention for the relevant period:\n  - Records on contracts or withdrawal of subscription: 5 years\n  - Records on payment and supply of goods: 5 years\n  - Records on consumer complaints or dispute resolution: 3 years'**
  String get privacySection3Content;

  /// No description provided for @privacySection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Provision of Personal Information to Third Parties'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Content.
  ///
  /// In en, this message translates to:
  /// **'The Company does not provide users\' personal information to external parties in principle. However, the following cases are exceptions:\n\n• When the user has consented in advance\n• When necessary for service provision (providing reservation information to taxi drivers)\n• When required by law or when requested by investigative agencies in accordance with procedures and methods prescribed by law for investigative purposes'**
  String get privacySection4Content;

  /// No description provided for @privacySection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Entrustment of Personal Information Processing'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Content.
  ///
  /// In en, this message translates to:
  /// **'The Company entrusts personal information processing tasks to external parties as follows for service improvement:\n\n【Entrusted Companies】\n• Payment services: Stripe, PayPal\n• Cloud services: Firebase (Google)\n• Customer support: Zendesk\n\nThe Company stipulates in the entrustment contract that personal information processing is prohibited for purposes other than performing entrusted tasks, technical and administrative protection measures, and restrictions on re-entrustment in accordance with the Personal Information Protection Act.'**
  String get privacySection5Content;

  /// No description provided for @privacySection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Rights, Obligations, and Exercise Methods of Information Subjects'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Content.
  ///
  /// In en, this message translates to:
  /// **'Users can exercise the following rights:\n\n• Request to view personal information\n• Request correction in case of errors\n• Request deletion\n• Request suspension of processing\n\nRights can be exercised through \'Settings > Edit Profile\' or \'Contact Us\'.'**
  String get privacySection6Content;

  /// No description provided for @privacySection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Destruction of Personal Information'**
  String get privacySection7Title;

  /// No description provided for @privacySection7Content.
  ///
  /// In en, this message translates to:
  /// **'The Company destroys personal information without delay when it becomes unnecessary, such as when the retention period has elapsed or the processing purpose has been achieved.\n\n【Destruction Procedure】\nInformation entered by users is moved to a separate database after the purpose is achieved and destroyed after being stored for a certain period in accordance with internal policies and relevant laws.\n\n【Destruction Method】\n• Electronic files: Complete deletion using technical methods so that they cannot be recovered or reproduced\n• Paper documents: Shredding or incineration'**
  String get privacySection7Content;

  /// No description provided for @privacySection8Title.
  ///
  /// In en, this message translates to:
  /// **'8. Personal Information Protection Officer'**
  String get privacySection8Title;

  /// No description provided for @privacySection8Content.
  ///
  /// In en, this message translates to:
  /// **'The Company is responsible for overseeing personal information processing tasks and has designated a personal information protection officer as follows to handle information subjects\' complaints and damage relief related to personal information processing:\n\n【Personal Information Protection Officer】\n• Name: TAGO Privacy Protection Team\n• Email: privacy@tagoapp.com\n\nFor other reports or consultations regarding personal information infringement, you can contact the following agencies:\n• Personal Information Infringement Report Center: privacy.kisa.or.kr (118 without area code)\n• Personal Information Dispute Mediation Committee: kopico.go.kr (1833-6972)'**
  String get privacySection8Content;

  /// No description provided for @privacySection9Title.
  ///
  /// In en, this message translates to:
  /// **'9. Changes to Privacy Policy'**
  String get privacySection9Title;

  /// No description provided for @privacySection9Content.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy applies from January 1, 2025.\n\nIf there are additions, deletions, or modifications to the content due to changes in laws, policies, or security technology, we will notify you through in-app announcements at least 7 days before the change.'**
  String get privacySection9Content;

  /// No description provided for @privacyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Inquiry'**
  String get privacyContactTitle;

  /// No description provided for @privacyContactMessage.
  ///
  /// In en, this message translates to:
  /// **'Questions about the Privacy Policy:\nprivacy@tagoapp.com'**
  String get privacyContactMessage;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Smart ride service for Korean students'**
  String get appDescription;

  /// No description provided for @developmentTeam.
  ///
  /// In en, this message translates to:
  /// **'Development Team'**
  String get developmentTeam;

  /// No description provided for @inquiry.
  ///
  /// In en, this message translates to:
  /// **'Inquiry'**
  String get inquiry;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 TAGO. All rights reserved.'**
  String get copyright;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature will be available soon.'**
  String get comingSoon;

  /// No description provided for @tripInformation.
  ///
  /// In en, this message translates to:
  /// **'Trip Information'**
  String get tripInformation;

  /// No description provided for @passengerCount.
  ///
  /// In en, this message translates to:
  /// **'Number of Passengers'**
  String get passengerCount;

  /// No description provided for @totalBags.
  ///
  /// In en, this message translates to:
  /// **'Total Bags'**
  String get totalBags;

  /// No description provided for @bags.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} bag} other {{count} bags}}'**
  String bags(int count);

  /// No description provided for @participantList.
  ///
  /// In en, this message translates to:
  /// **'Participant List ({passengerCount} {passengerCount, plural, one {passenger} other {passengers}} + 1 driver)'**
  String participantList(int passengerCount);

  /// No description provided for @participantListNoDriver.
  ///
  /// In en, this message translates to:
  /// **'Participant List ({count} people)'**
  String participantListNoDriver(int count);

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @startRide.
  ///
  /// In en, this message translates to:
  /// **'Start Ride'**
  String get startRide;

  /// No description provided for @leaveChatRoom.
  ///
  /// In en, this message translates to:
  /// **'Leave Chat Room'**
  String get leaveChatRoom;

  /// No description provided for @checkTripRoute.
  ///
  /// In en, this message translates to:
  /// **'Check Trip Route'**
  String get checkTripRoute;

  /// No description provided for @endRide.
  ///
  /// In en, this message translates to:
  /// **'End Ride'**
  String get endRide;

  /// No description provided for @viewOriginal.
  ///
  /// In en, this message translates to:
  /// **'View Original'**
  String get viewOriginal;

  /// No description provided for @viewTranslation.
  ///
  /// In en, this message translates to:
  /// **'View Translation'**
  String get viewTranslation;

  /// No description provided for @enterMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter message'**
  String get enterMessage;

  /// No description provided for @firstMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Send your first message 🙂'**
  String get firstMessageHint;

  /// No description provided for @loadingParticipants.
  ///
  /// In en, this message translates to:
  /// **'Loading participant information...'**
  String get loadingParticipants;

  /// No description provided for @noParticipants.
  ///
  /// In en, this message translates to:
  /// **'No participants'**
  String get noParticipants;

  /// No description provided for @rideStarted.
  ///
  /// In en, this message translates to:
  /// **'Ride started.'**
  String get rideStarted;

  /// No description provided for @leftChatRoom.
  ///
  /// In en, this message translates to:
  /// **'Left the chat room.'**
  String get leftChatRoom;

  /// No description provided for @rideEnded.
  ///
  /// In en, this message translates to:
  /// **'Ride has ended.'**
  String get rideEnded;

  /// No description provided for @endRideDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'End Ride'**
  String get endRideDialogTitle;

  /// No description provided for @endRideDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end the ride?\n\nAll chat history and trip information will be deleted.\nThis action cannot be undone.'**
  String get endRideDialogMessage;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @rideEndError.
  ///
  /// In en, this message translates to:
  /// **'Error ending ride: {error}'**
  String rideEndError(String error);

  /// No description provided for @leaveChatError.
  ///
  /// In en, this message translates to:
  /// **'Error leaving chat room: {error}'**
  String leaveChatError(String error);

  /// No description provided for @updateError.
  ///
  /// In en, this message translates to:
  /// **'Update error: {error}'**
  String updateError(String error);

  /// No description provided for @mapLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading map information: {error}'**
  String mapLoadError(String error);

  /// No description provided for @chatRoomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Chat room document not found.'**
  String get chatRoomNotFound;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @mapLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading map...'**
  String get mapLoading;

  /// No description provided for @systemGuide.
  ///
  /// In en, this message translates to:
  /// **'System Guide'**
  String get systemGuide;

  /// No description provided for @driverEntered.
  ///
  /// In en, this message translates to:
  /// **'{driverName} driver has entered.'**
  String driverEntered(String driverName);

  /// No description provided for @driverEnteredNoName.
  ///
  /// In en, this message translates to:
  /// **'Driver has entered.'**
  String get driverEnteredNoName;

  /// No description provided for @systemGuide1.
  ///
  /// In en, this message translates to:
  /// **'1. Please reconfirm the pickup location with the driver via chat.'**
  String get systemGuide1;

  /// No description provided for @systemGuide2.
  ///
  /// In en, this message translates to:
  /// **'2. Please pay the fare on-site.\n   - Estimated fare: {fareText}\n   - Recommended tip: {tipText}'**
  String systemGuide2(String fareText, String tipText);

  /// No description provided for @systemGuide3.
  ///
  /// In en, this message translates to:
  /// **'3. If you have any questions, please feel free to ask in the chat room.'**
  String get systemGuide3;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusOnProgress.
  ///
  /// In en, this message translates to:
  /// **'On Progress'**
  String get statusOnProgress;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
