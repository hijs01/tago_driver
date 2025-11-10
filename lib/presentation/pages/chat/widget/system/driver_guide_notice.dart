import 'package:flutter/material.dart';
import 'system_message_tile.dart';

class DriverGuideNotice extends StatelessWidget {
  final String? driverName;
  final String fareText;
  final String tipText;

  const DriverGuideNotice({
    super.key,
    this.driverName,
    required this.fareText,
    required this.tipText,
  });

  @override
  Widget build(BuildContext context) {
    return SystemMessageTile(
      icon: Icons.directions_car,
      iconColor: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            driverName == null
                ? '드라이버가 입장했습니다.'
                : '$driverName 드라이버가 입장했습니다.',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. 픽업 위치를 드라이버와 채팅으로 다시 한 번 확인해주세요.',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 4),
          Text(
            '2. 요금은 현장에서 결제해 주세요.\n   - 예상 요금: $fareText\n   - 추천 팁: $tipText',
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 4),
          const Text(
            '3. 궁금한 점이 있으면 언제든지 채팅방에서 이야기해주세요.',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
        ],
      ),
    );
  }
}