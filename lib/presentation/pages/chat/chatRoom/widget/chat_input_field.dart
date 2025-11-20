import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/chat_room_view_model.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

/// 채팅 메시지 입력창 컴포넌트
/// - 텍스트 입력 필드
/// - 전송 버튼
/// - 메시지 전송 기능
class ChatInputField extends StatelessWidget {
  // 텍스트 입력 컨트롤러
  final TextEditingController controller;
  
  // 현재 사용자 ID
  final String myId;
  
  // 현재 사용자 이름
  final String myName;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.myId,
    required this.myName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1419),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: l10n.enterMessage,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFF4CAF50),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Consumer<ChatViewModel>(
            builder: (context, vm, _) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () async {
                    final text = controller.text.trim();
                    // 빈 메시지는 전송하지 않음
                    if (text.isEmpty) return;

                    // 메시지 전송
                    await vm.sendMessage(
                      text: text,
                      senderId: myId,
                      senderName: myName,
                    );
                    // 입력창 초기화
                    controller.clear();
                  },
                  icon: const Icon(Icons.send,),
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
