import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tago_driver/data/models/chat_message_model.dart';

class ChatViewModel extends ChangeNotifier {
  final DocumentReference<Map<String, dynamic>> rideRequestRef;

  ChatViewModel(this.rideRequestRef);

  Stream<List<ChatMessage>> get messagesStream {
    return rideRequestRef
        .collection('Chats')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => ChatMessage.fromDoc(d)).toList(),
        );
  }

  /// 💬 일반 채팅
  Future<void> sendMessage({
    required String text,
    required String senderId,
    required String senderName,
    String? senderProfileImage,
  }) async {
    if (text.trim().isEmpty) return;

    final messagesRef = rideRequestRef.collection('Chats');

    final msg = ChatMessage.chat(
      text: text.trim(),
      senderId: senderId,
      senderName: senderName,
      senderProfileImage: senderProfileImage,
    );

    await messagesRef.add({
      ...msg.toMap(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    await rideRequestRef.set(
      {
        'lastMessage': text.trim(),
        'lastTimestamp': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// 🚗 드라이버 입장 시스템 메시지
    /// 🚗 드라이버 입장 시스템 메시지 실제로 한 번 보내는 함수
  Future<void> sendDriverJoinNotice({
    required String driverName,
    required String fareText,
    required String tipText,
  }) async {
    final messagesRef = rideRequestRef.collection('Chats');

    await messagesRef.add({
      'text': 'driver_join_notice',
      'type': 'system',
      'systemType': 'driver_join',
      'driverName': driverName,
      'fareText': fareText,
      'tipText': tipText,
      'timestamp': FieldValue.serverTimestamp(),
      'senderId': 'system',
    });

    await rideRequestRef.set(
      {
        'lastMessage': '$driverName 드라이버가 입장했습니다.',
        'lastTimestamp': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// ✅ 이미 만들어진 적 없으면 딱 1번만 시스템 메시지 생성
  Future<void> ensureDriverJoinNoticeSent({
    required String driverName,
    required String fareText,
    required String tipText,
  }) async {
    final messagesRef = rideRequestRef.collection('Chats');

    final existing = await messagesRef
        .where('type', isEqualTo: 'system')
        .where('systemType', isEqualTo: 'driver_join')
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      // 이미 생성된 적 있으면 아무것도 안 함
      return;
    }

    await sendDriverJoinNotice(
      driverName: driverName,
      fareText: fareText,
      tipText: tipText,
    );
  }
}