import 'package:flutter/material.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/chat/widget/chat_tile.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
        final rooms = [
      {
        'title': '인천공항 (10:00 출발)',
        'lastMessage': '네 그 시간에 정문에서 만나요!',
        'timeText': '오전 9:12',
        'unread': 2,
      },
      {
        'title': '김포공항 (내일 새벽)',
        'lastMessage': '혹시 한 자리 더 있나요?',
        'timeText': '어제',
        'unread': 0,
      },
    ];
    return AppScaffold(
      backgroundColor: Colors.black,
      appBar: AppBar( 
        backgroundColor: Colors.black,
        title: Text(
          "채팅",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: rooms.length,
        separatorBuilder: (_, __) => Divider(
          color: Colors.grey[850],
          height: 1,
        ),
        itemBuilder: (context, index) {
          final room = rooms[index];

          return ChatRoomTile(
            title: room['title'] as String,
            lastMessage: room['lastMessage'] as String,
            timeText: room['timeText'] as String,
            unreadCount: room['unread'] as int,
            onTap: () {
              // TODO: 채팅방 화면으로 이동
              // Navigator.pushNamed(context, '/chatRoom', arguments: roomId);
            },
          );
        },
      ),
    );
  }
}
