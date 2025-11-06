import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tago_driver/data/models/chat_message_model.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/chat_room_view_model.dart';
import 'package:tago_driver/presentation/pages/chat/widget/chat_bubble.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 라우트로 넘어온 파라미터
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final rideRequestRefPath = args['rideRequestRefPath'] as String;
    final fromName = args['fromName'] as String;
    final toName = args['toName'] as String;

    // ✅ 여정 문서 레퍼런스
    final rideRequestRef = FirebaseFirestore.instance.doc(rideRequestRefPath);

    // ✅ 로그인 유저 정보
    final loginVm = context.watch<LoginViewModel>();
    final me = loginVm.currentUser!;
    final myId = me.uid;
    final myName = me.name ?? '기사';

    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(rideRequestRef),
      child: AppScaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.black,
          title: Text(
            '$fromName\n↓\n$toName',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            // 📩 메세지 리스트
            // ChatRoomView 의 Expanded 안
            Expanded(
              child: Consumer<ChatViewModel>(
                builder: (context, vm, _) {
                  return StreamBuilder<List<ChatMessage>>(
                    stream: vm.messagesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '오류 발생: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final messages = snapshot.data ?? [];

                      if (messages.isEmpty) {
                        return const Center(
                          child: Text(
                            '첫 메세지를 보내보세요 🙂',
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      }

                      // ✅ reverse 안 씀, index도 그대로
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe = msg.senderId == myId;

                          return ChatBubble(
                            text: msg.text,
                            isMe: isMe,
                            senderName: msg.senderName,
                            createdAt: msg.createdAt,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),

        // ✏️ 입력창 (AppScaffold의 footer에 붙임)
        footer: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '메세지를 입력하세요',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Consumer<ChatViewModel>(
              builder: (context, vm, _) {
                return IconButton(
                  onPressed: () async {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;

                    await vm.sendMessage(
                      text: text,
                      senderId: myId,
                      senderName: myName,
                    );
                    _controller.clear();
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.blueAccent,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
