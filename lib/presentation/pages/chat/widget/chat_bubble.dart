import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String? senderName;
  final DateTime? createdAt;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.senderName,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    String? timeText;

    if (createdAt != null) {
      timeText =
          '${createdAt!.hour.toString().padLeft(2, '0')}:${createdAt!.minute.toString().padLeft(2, '0')}';
    }

    final bubbleColor = isMe ? Colors.blueAccent : const Color.fromARGB(255, 96, 96, 96);

    final textColor = Colors.white;

    final bubbleRadius = BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
      bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (senderName != null || timeText != null)
            Padding(
              padding: EdgeInsets.only(bottom: 2, left: 4, right: 4),
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe && senderName != null)
                    Text(
                      senderName!,
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  if (!isMe && senderName != null && timeText != null)
                    SizedBox(width: 6),
                  
                ],
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                 if (isMe && timeText != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4, bottom: 2),
                  child: Text(
                    timeText,
                    style:  TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: bubbleRadius,
                  ),
                  child: Text(
                    text,
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                ),
              ),
                // ✅ 상대방의 경우: 말풍선 → 시간 순서
              if (!isMe && timeText != null)
                
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 2),
                  child: Text(
                    timeText,
                    style:  TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
          
            ],
          ),
        ],
      ),
    );
  }
}
