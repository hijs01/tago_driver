import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tago_driver/data/models/chat_message_model.dart';

class ChatViewModel extends ChangeNotifier {
  final DocumentReference<Map<String, dynamic>> rideRequestRef;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  ChatViewModel(this.rideRequestRef);

  /// ⬆️ 오래된 → 최신 순 (시간순으로 위→아래 정렬)
  Stream<List<ChatMessage>> get messagesStream {
    return rideRequestRef
        .collection('Chats')
        .orderBy('timestamp', descending: false) // ✅ 오래된 → 최신
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => ChatMessage.fromDoc(d)).toList(),
        );
  }

  Future<void> sendMessage({
    required String text,
    required String senderId,
    required String senderName,
    String? senderProfileImage,
  }) async {
    if (text.trim().isEmpty) return;

    final messagesRef = rideRequestRef.collection('Chats');

    await messagesRef.add({
      'text': text.trim(),
      'senderId': senderId,
      'senderName': senderName,
      'senderProfileImage': senderProfileImage,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await rideRequestRef.set({
      'lastMessage': text.trim(),
      'lastTimestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}