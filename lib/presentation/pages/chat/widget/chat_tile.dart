import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  final String title;          // 방 이름 (예: 인천공항 가는 택시팟)
  final String lastMessage;    // 마지막 메세지
  final String timeText;       // 시간 표시 (예: 오후 3:21)
  final int unreadCount;       // 안 읽은 메세지 수
  final VoidCallback onTap;    // 탭 했을 때 액션

  const ChatListTile({
    super.key,
    required this.title,
    required this.lastMessage,
    required this.timeText,
    this.unreadCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            // 왼쪽: 프로필/방 아이콘 (원형)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.local_taxi,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // 가운데: 방 제목 + 마지막 메세지
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 방 제목
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // 마지막 메세지
                  Text(
                    lastMessage,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // 오른쪽: 시간 + 안읽은 메세지 뱃지
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeText,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                if (hasUnread)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}