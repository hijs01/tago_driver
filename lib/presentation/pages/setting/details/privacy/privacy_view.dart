import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:tago_driver/presentation/common/appScaffold.dart';

/// Privacy Policy Screen
///
/// Features:
/// 1. Display full privacy policy text
/// 2. Section-by-section organization
/// 3. Scrollable
///
/// Characteristics:
/// - Static content (no ViewModel needed)
/// - Read-only
///
/// Usage: "Privacy Policy" in settings_view.dart
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
          "Privacy Policy",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      scrollable: true,
      body: _buildPrivacyContent(),
    );
  }

  /// Privacy Policy Content
  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),

        const SizedBox(height: 24),

        _buildUpdateDate(),

        const SizedBox(height: 32),

        _buildSection(
          title: "TAGO Airport Shuttle Driver Privacy Policy",
          content:
              "This Privacy Notice for People Link One (\"we,\" \"us,\" or \"our\") describes how and why we might access, collect, store, use, and/or share (\"process\") your personal information when you use our services (\"Services\"), including when you:\n\n"
              "• Download and use our mobile application (TAGO Airport Shuttle Driver) or any other application of ours that links to this Privacy Notice.\n"
              "• Engage with us in other related ways, including any sales, marketing, or events.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "USE TAGO AIRPORT SHUTTLE DRIVER",
          content:
              "App purpose\n"
              "Tago Driver is the driver-only companion to the main Tago (Passenger) App. Passengers create ride requests in the main Tago app; drivers use Tago Driver to receive, manage, and complete those ride requests. It is not for passengers. Drivers use this app to: receive ride requests created in the Tago User App; view pickup and destination details on an interactive map; accept or decline assigned rides; communicate with passengers in real time via chat; and receive push notifications for new rides and messages. Because this app functions as part of the two-app ecosystem (User App + Driver App), a test driver account is required to access all features.\n\n"
              "Location permission explanation\n"
              "The app asks for location permission on first map use.\n"
              "Info.plist keys: NSLocationWhenInUseUsageDescription; NSLocationAlwaysAndWhenInUseUsageDescription.\n"
              "Reason: (1) show the driver's current position on Google Maps, (2) display the route from pickup to destination, and (3) assist the driver in navigating to the passenger.\n"
              "Behavior: Location is used only while the driver is actively using the app and viewing a ride. No background tracking outside ride sessions. Purpose string: \"Location information is required to display your current location and show routes on the map.\"\n\n"
              "Notifications (push)\n"
              "Uses Firebase Cloud Messaging / APNs to send: new ride request notifications (triggered when a passenger creates a ride in the User App); new chat message notifications; ride status updates. Notifications are essential for timely driver responses and can be disabled in iOS Settings.\n\n"
              "Network / backend dependencies\n"
              "Uses Firebase (Authentication, Firestore, Cloud Messaging). Uses Google Maps SDK / Directions API for route display. Requires an active internet connection (Wi-Fi or cellular). If offline, real-time features such as ride requests, chat, and maps will not function.\n\n"
              "Third-party services used\n"
              "Firebase Authentication: driver login (email/password or Google).\n"
              "Firebase Firestore: ride requests, statuses, chats (shared with the User App).\n"
              "Firebase Cloud Messaging: push notifications.\n"
              "Google Maps SDK: map display and route visualization.\n"
              "Geolocator / CoreLocation: GPS location access.\n"
              "All network traffic is encrypted via HTTPS.\n\n"
              "Data and privacy\n"
              "Data collected: driver's name, email, and device token for notifications.\n"
              "Location: used only for in-app map rendering and navigation during rides.\n"
              "All data is securely stored in Firebase Firestore (with strict Firestore rules).\n"
              "Privacy Policy and Terms are accessible in-app and via the App Store listing.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "QUESTIONS OR CONCERNS",
          content:
              "Reading this Privacy Notice will help you understand your privacy rights and choices. If you do not agree with our policies and practices, please do not use our Services. Questions or concerns: ploride.dev@gmail.com.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "SUMMARY OF KEY POINTS",
          content:
              "What personal information do we process? We may process personal information depending on how you interact with us and the Services, the choices you make, and the products and features you use.\n\n"
              "Do we process sensitive personal information? We do not process sensitive personal information.\n\n"
              "Do we collect information from third parties? We do not collect any information from third parties.\n\n"
              "How do we process your information? We process information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with law. We also process information for other purposes with your consent and only when we have a valid legal reason.\n\n"
              "When and with whom do we share personal information? We may share information in specific situations and with specific third parties.\n\n"
              "How do we keep your information safe? We use organizational and technical safeguards, but no system is 100% secure.\n\n"
              "What are your rights? Depending on where you live, you may have rights regarding your personal information.\n\n"
              "How do you exercise your rights? Submit a data subject access request or contact us; we will act in accordance with applicable laws.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "WHAT INFORMATION DO WE COLLECT?",
          content:
              "Personal information you disclose to us: We collect personal information that you provide when you register on the Services, express interest in information about us or our products and Services, participate in activities on the Services, or otherwise contact us.\n\n"
              "Personal information provided by you: may include names and email addresses.\n\n"
              "Sensitive information: We do not process sensitive information.\n\n"
              "Social media login data: If you register using a social media account (e.g., Facebook, X), we will receive certain profile information from the provider as described under \"How do we handle your social logins?\"\n\n"
              "Application data:\n"
              "• Geolocation information: we may request access to track location while you use the app to provide location-based services. You can change permissions in device settings.\n"
              "• Push notifications: we may send notifications related to your account and app features. You can opt out in device settings.\n\n"
              "Google API: Our use of information received from Google APIs adheres to the Google API Services User Data Policy, including Limited Use requirements.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "HOW DO WE PROCESS YOUR INFORMATION?",
          content:
              "We process personal information to provide, improve, and administer our Services; communicate with you; for security and fraud prevention; and to comply with law. Examples:\n\n"
              "• To facilitate account creation, authentication, and user account management.\n"
              "• To enable user-to-user communications when you use features that allow communication with another user.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "WHEN AND WITH WHOM DO WE SHARE YOUR PERSONAL INFORMATION?",
          content:
              "We may share information in specific situations, including:\n\n"
              "• Business transfers: in connection with merger, sale of assets, financing, or acquisition.\n\n"
              "Google Maps Platform APIs: when we use Google Maps (e.g., Maps API, Places API), Google may estimate your location using GPS, Wi-Fi, and cell towers. GPS is about 20 meters accurate; Wi-Fi/cell towers improve accuracy indoors. This data helps provide directions but is not always perfectly precise.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?",
          content:
              "We may use cookies and similar tracking technologies (web beacons, pixels) to collect information when you interact with our Services, maintain security, prevent crashes, fix bugs, save preferences, and support basic site functions. Third parties may use tracking technologies on our Services for analytics and advertising, to manage or display ads tailored to your interests, or to send reminders depending on your preferences. To the extent these are considered \"sale\" or \"sharing\" under applicable US state laws, you can opt out by submitting a request as described under US state privacy rights. Details on refusing certain cookies are set out in our Cookie Notice.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "HOW DO WE HANDLE YOUR SOCIAL LOGINS?",
          content:
              "If you register or log in via a third-party social media account, we receive profile information about you from that provider (typically your name, email address, friends list, profile picture, and any information you make public). We use that information only for the purposes described in this Notice or otherwise made clear to you. We are not responsible for other uses of your information by the social media provider; review their privacy notice to understand their practices and controls.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "HOW LONG DO WE KEEP YOUR INFORMATION?",
          content:
              "We keep personal information only as long as necessary for the purposes set out in this Notice or as required/permitted by law (e.g., tax, accounting). When there is no ongoing legitimate business need to process it, we delete or anonymize it, or if not possible (e.g., backups) we securely store and isolate it until deletion is possible.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "HOW DO WE KEEP YOUR INFORMATION SAFE?",
          content:
              "We implement appropriate technical and organizational measures to protect personal information. However, no transmission or storage technology is 100% secure. Transmission of personal information to and from our Services is at your own risk. Access the Services within a secure environment.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "DO WE COLLECT INFORMATION FROM MINORS?",
          content:
              "We do not knowingly collect data from or market to children under 18 years of age, nor do we knowingly sell such personal information. By using the Services, you represent that you are at least 18, or that you are the parent or guardian of a minor who is using the Services with your consent. If we learn that personal information from users under 18 has been collected, we will deactivate the account and take reasonable measures to promptly delete the data. If you become aware of any data we may have collected from children under 18, contact ploride.dev@gmail.com.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "WHAT ARE YOUR PRIVACY RIGHTS?",
          content:
              "You may review, change, or terminate your account at any time, depending on your country, province, or state of residence.\n\n"
              "Withdrawing your consent: If we rely on consent (express or implied, depending on applicable law), you may withdraw it at any time by contacting us using the details in \"How can you contact us about this notice?\"\n\n"
              "Account information: To review or change information in your account or terminate your account, log into your account settings and update your user account. Upon your termination request, we will deactivate or delete your account and information from our active databases. We may retain some information to prevent fraud, troubleshoot problems, assist investigations, enforce legal terms, and/or comply with legal requirements.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "DO UNITED STATES RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?",
          content:
              "If you are a resident of California, Colorado, Connecticut, Delaware, Florida, Indiana, Iowa, Kentucky, Maryland, Minnesota, Montana, Nebraska, New Hampshire, New Jersey, Oregon, Rhode Island, Tennessee, Texas, Utah, or Virginia, you may have rights to request access to and details about the personal information we maintain about you and how we processed it, correct inaccuracies, obtain a copy of it, or delete it. You may also have the right to withdraw consent where applicable. Rights may be limited in some circumstances by law.\n\n"
              "Categories of personal information we collect (past 12 months):\n"
              "A. Identifiers: COLLECTED – YES\n"
              "B. Personal information as defined in the California Customer Records statute: COLLECTED – YES\n"
              "C. Protected classification characteristics: COLLECTED – NO\n"
              "D. Commercial information: COLLECTED – NO\n"
              "E. Biometric information: COLLECTED – NO\n"
              "F. Internet or other similar network activity: COLLECTED – NO\n"
              "G. Geolocation data: COLLECTED – YES\n"
              "H. Audio, electronic, sensory, or similar information: COLLECTED – NO\n"
              "I. Professional or employment-related information: COLLECTED – NO\n"
              "J. Education information: COLLECTED – NO\n"
              "K. Inferences drawn from collected personal information: COLLECTED – NO\n"
              "L. Sensitive personal information: COLLECTED – NO\n\n"
              "Your rights under certain US state laws include:\n"
              "• Right to know whether we are processing your personal data\n"
              "• Right to access your personal data\n"
              "• Right to correct inaccuracies\n"
              "• Right to request deletion\n"
              "• Right to obtain a copy of personal data you previously shared with us\n"
              "• Right to non-discrimination for exercising your rights\n"
              "• Right to opt out of processing for targeted advertising\n\n"
              "How to exercise your rights: submit a data subject access request, email ploride.dev@gmail.com, or use the contact details at the bottom of this document.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "DO WE MAKE UPDATES TO THIS NOTICE?",
          content:
              "Yes. We will update this notice as necessary to stay compliant with relevant laws. The updated version will be indicated by the updated \"Revised\" date at the top. If we make material changes, we may notify you by prominently posting a notice of such changes or by sending a notification. Review this Notice frequently to stay informed about how we protect your information.",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "HOW CAN YOU CONTACT US ABOUT THIS NOTICE?",
          content: "Email: ploride.dev@gmail.com",
        ),

        const SizedBox(height: 24),

        _buildSection(
          title: "HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?",
          content:
              "You may request access to the personal information we collect from you, details about how we processed it, corrections of inaccuracies, or deletion of your personal information. You may also have the right to withdraw consent to our processing, subject to applicable law. To review, update, or delete your personal information, submit a data subject access request.",
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
                  "TAGO values your privacy and complies with all relevant laws and regulations.",
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
        "Last updated: November 10, 2025",
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
                    "Privacy Inquiries",
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
                "Questions about this Privacy Policy:\nploride.dev@gmail.com",
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
