import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String? senderProfileImage;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    this.senderProfileImage,
    required this.createdAt,
  });

  factory ChatMessage.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final rawTimestamp = data['timestamp'];

    DateTime parsedTime;
    if (rawTimestamp is Timestamp) {
      // ✅ 정상 케이스
      parsedTime = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      // ✅ 예전에 String 으로 저장해버린 데이터용
      parsedTime = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    } else {
      // ✅ 둘 다 아니면 그냥 지금 시각
      parsedTime = DateTime.now();
    }

    return ChatMessage(
      id: doc.id,
      text: data['text'] as String? ?? '',
      senderId: data['senderId'] as String? ?? '',
      senderName: data['senderName'] as String? ?? '',
      senderProfileImage: data['senderProfileImage'] as String?,
      createdAt: parsedTime,
    );
  }
}