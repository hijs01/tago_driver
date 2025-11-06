import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/chat/widget/chat_tile.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    // rideRequests/airport_to_school/items 컬렉션
    final chatRoomsRef = FirebaseFirestore.instance
        .collection('rideRequests')
        .doc('airport_to_school')
        .collection('items');

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "채팅방 목록 (airport_to_school)",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: chatRoomsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "오류 발생: ${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "채팅방이 없습니다.",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();

              final chatRoomId = doc.id;
              final fromName = data['fromName'] as String? ?? '';
              final toName = data['toName'] as String? ?? '';
              final title = '$fromName → $toName';

              final lastMessage =
                  data['lastMessage'] as String? ?? '메시지가 없습니다.';

              // 🔹 lastTimestamp가 Timestamp인 경우에만 시간 표시
              String timeText = '';
              final rawTs = data['lastTimestamp'];
              Timestamp? ts;
              if (rawTs is Timestamp) {
                ts = rawTs;
              } else {
                ts = null; // 문자열이거나 없으면 null
              }

              if (ts != null) {
                final dt = ts.toDate();
                final hh = dt.hour.toString().padLeft(2, '0');
                final mm = dt.minute.toString().padLeft(2, '0');
                timeText = '$hh:$mm';
              }

              const unreadCount = 0; // 아직 미구현

              return ChatListTile(
                title: title,
                lastMessage: lastMessage,
                timeText: timeText,
                unreadCount: unreadCount,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/chatRoom',
                    arguments: {
                      'rideRequestId': chatRoomId,
                      'rideRequestRefPath': doc.reference.path,
                      'fromName': fromName,
                      'toName': toName,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}