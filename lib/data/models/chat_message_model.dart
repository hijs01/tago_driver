import 'package:cloud_firestore/cloud_firestore.dart';

/// 메시지 종류
enum ChatMessageType {
  chat,   // 일반 채팅
  system, // 시스템/안내 메시지
}

class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String? senderProfileImage;
  final DateTime createdAt;

  /// 💡 추가: 메시지 타입 (chat / system)
  final ChatMessageType type;

  /// 💡 추가: 시스템 메시지 세부 타입
  /// 예: 'driver_join', 'ride_completed' 등
  final String? systemType;

  /// 💡 추가: 드라이버 입장 안내 등에 쓰는 부가 정보
  final String? driverName;
  final String? fareText;
  final String? tipText;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    this.senderProfileImage,
    required this.createdAt,
    this.type = ChatMessageType.chat,
    this.systemType,
    this.driverName,
    this.fareText,
    this.tipText,
  });

  /// Firestore 문서 → ChatMessage
  factory ChatMessage.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final rawTimestamp = data['timestamp'];

    DateTime parsedTime;
    if (rawTimestamp is Timestamp) {
      parsedTime = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      parsedTime = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    } else {
      parsedTime = DateTime.now();
    }

    // 🔹 type (없으면 기본 chat)
    final rawType = (data['type'] ?? 'chat').toString();
    final messageType =
        rawType == 'system' ? ChatMessageType.system : ChatMessageType.chat;

    return ChatMessage(
      id: doc.id,
      text: data['text'] as String? ?? '',
      senderId: data['senderId'] as String? ?? '',
      senderName: data['senderName'] as String? ?? '',
      senderProfileImage: data['senderProfileImage'] as String?,
      createdAt: parsedTime,
      type: messageType,
      systemType: data['systemType'] as String?, // 'driver_join' 등
      driverName: data['driverName'] as String?,
      fareText: data['fareText'] as String?,
      tipText: data['tipText'] as String?,
    );
  }

  /// (선택) 일반 채팅을 보낼 때 편하게 만드는 팩토리
  factory ChatMessage.chat({
    required String text,
    required String senderId,
    required String senderName,
    String? senderProfileImage,
  }) {
    return ChatMessage(
      id: '',
      text: text,
      senderId: senderId,
      senderName: senderName,
      senderProfileImage: senderProfileImage,
      createdAt: DateTime.now(),
      type: ChatMessageType.chat,
    );
  }

  /// (선택) 드라이버 입장 시스템 메시지 만들 때 사용
  factory ChatMessage.driverJoinNotice({
    required String driverName,
    required String fareText,
    required String tipText,
  }) {
    return ChatMessage(
      id: '',
      text: 'driver_join_notice',
      senderId: 'system',
      senderName: 'System',
      senderProfileImage: null,
      createdAt: DateTime.now(),
      type: ChatMessageType.system,
      systemType: 'driver_join',
      driverName: driverName,
      fareText: fareText,
      tipText: tipText,
    );
  }

  /// Firestore에 저장할 때 사용
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'senderProfileImage': senderProfileImage,
      'timestamp': Timestamp.fromDate(createdAt),
      'type': type == ChatMessageType.system ? 'system' : 'chat',
      if (systemType != null) 'systemType': systemType,
      if (driverName != null) 'driverName': driverName,
      if (fareText != null) 'fareText': fareText,
      if (tipText != null) 'tipText': tipText,
    };
  }
}