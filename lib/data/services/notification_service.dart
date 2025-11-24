import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 백그라운드 메시지 핸들러 (최상위 함수여야 함)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('🔔 백그라운드 메시지 수신: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 현재 활성 채팅방 정보 (rideType + chatRoomId 조합)
  // "rideRequests/{rideType}/items/{chatRoomId}" 형식
  String? _activeChatRoomPath;

  /// 초기화
  Future<void> initialize() async {
    print('🚀 NotificationService 초기화 시작');
    
    // 1️⃣ 권한 요청
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ 알림 권한 승인됨');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('⚠️ 임시 알림 권한');
    } else {
      print('❌ 알림 권한 거부됨');
      return;
    }

    // 2️⃣ 로컬 알림 초기화
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // 3️⃣ 백그라운드 메시지 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 4️⃣ 포그라운드 메시지 리스너
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 5️⃣ 알림 탭으로 앱 열었을 때
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // 6️⃣ 앱이 완전히 종료된 상태에서 알림으로 열렸는지 확인
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  /// FCM 토큰 가져오기 및 Firestore에 저장
  Future<String?> getFCMToken(String userId) async {
    try {
      print('🔑 FCM 토큰 요청 중... (userId: $userId)');
      String? token = await _fcm.getToken();
      
      if (token != null) {
        print('🔑 FCM 토큰 받음: ${token.substring(0, 20)}...');
        
        // Firestore에 저장
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('fcmTokens')
            .doc(token)
            .set({
          'token': token,
          'platform': 'ios',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        
        print('✅ FCM 토큰 Firestore 저장 완료');
      } else {
        print('⚠️ FCM 토큰이 null입니다 (APNS 설정 확인 필요)');
      }
      
      return token;
    } catch (e, stackTrace) {
      print('❌ FCM 토큰 가져오기 실패: $e');
      print('스택 트레이스: $stackTrace');
      return null;
    }
  }

  /// 토큰 갱신 리스너 등록
  void listenToTokenRefresh(String userId) {
    _fcm.onTokenRefresh.listen((newToken) {
      print('🔄 FCM 토큰 갱신: $newToken');
      // 새 토큰을 Firestore에 저장
      _firestore
          .collection('users')
          .doc(userId)
          .collection('fcmTokens')
          .doc(newToken)
          .set({
        'token': newToken,
        'platform': 'ios',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// 현재 활성 채팅방 설정 (채팅방 입장 시 호출)
  void setActiveChatRoom(String rideRequestRefPath) {
    _activeChatRoomPath = rideRequestRefPath;
    print('🔔 활성 채팅방 설정: $rideRequestRefPath');
  }

  /// 현재 활성 채팅방 해제 (채팅방 퇴장 시 호출)
  void clearActiveChatRoom() {
    _activeChatRoomPath = null;
    print('🔔 활성 채팅방 해제');
  }

  /// 포그라운드 메시지 처리
  void _handleForegroundMessage(RemoteMessage message) {
    print('🔔 포그라운드 메시지 수신: ${message.notification?.title}');
    print('🔔 메시지 데이터: ${message.data}');
    
    // 채팅 알림인지 확인
    final messageType = message.data['type'] as String?;
    
    // 채팅 알림이고, 현재 활성 채팅방과 동일한 경우 알림 표시하지 않음
    if (messageType == 'chat') {
      final rideType = message.data['rideType'] as String?;
      final chatRoomId = message.data['chatRoomId'] as String?;
      
      if (rideType != null && chatRoomId != null && _activeChatRoomPath != null) {
        // 알림에서 받은 채팅방 경로 구성
        final notificationChatRoomPath = 'rideRequests/$rideType/items/$chatRoomId';
        
        // 현재 활성 채팅방과 비교
        if (notificationChatRoomPath == _activeChatRoomPath) {
          print('⏭️ 현재 활성 채팅방의 알림이므로 표시하지 않음: $notificationChatRoomPath');
          return;
        }
      }
    }
    
    // 로컬 알림으로 표시
    _showLocalNotification(message);
  }

  /// 로컬 알림 표시
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'tago_channel',
      'Tago Notifications',
      channelDescription: '타고 채팅 및 라이드 알림',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? '새 알림',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  /// 알림 탭 처리
  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 알림 탭됨: ${response.payload}');
    // TODO: 채팅방이나 상세 화면으로 네비게이션
  }

  /// 백그라운드에서 알림 탭으로 앱 열었을 때
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('🔔 백그라운드 알림으로 앱 열림: ${message.data}');
    // TODO: 채팅방이나 상세 화면으로 네비게이션
  }

  /// 로그아웃 시 토큰 삭제
  Future<void> removeToken(String userId) async {
    try {
      String? token = await _fcm.getToken();
      if (token != null) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('fcmTokens')
            .doc(token)
            .delete();
        
        await _fcm.deleteToken();
        print('✅ FCM 토큰 삭제 완료');
      }
    } catch (e) {
      print('❌ 토큰 삭제 실패: $e');
    }
  }
}