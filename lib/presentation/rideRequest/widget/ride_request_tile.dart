// lib/presentation/rideRequest/widget/ride_request_tile.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

class RideRequestTile extends StatelessWidget {
  final String text; // 버튼 라벨 (ex. '채팅방 입장')
  final String id; // 요청 ID
  final String origin; // 출발지
  final String destination; // 도착지
  final String time; // 시간 텍스트 (이미 포맷된 문자열)
  final int passengers; // 인원 수
  final String status; // ✅ status 필드 추가
  final DocumentReference<Map<String, dynamic>>? docRef; // 파이어스토어 문서 참조
  final VoidCallback? onTap; // 선택: 버튼 onTap

  const RideRequestTile({
    super.key,
    required this.text,
    required this.id,
    required this.origin,
    required this.destination,
    required this.time,
    required this.passengers,
    required this.status, // ✅ status 필드 추가
    required this.docRef,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: const Color(0xFF161B22),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 상단: 출발지 -> 도착지
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 점/선 아이콘 스택
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 28,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.white.withOpacity(0.15),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF90CAF9),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // 텍스트들
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _kv(l10n.origin, origin),
                      const SizedBox(height: 6),
                      _kv(l10n.destination, destination),
                    ],
                  ),
                ),
                // 우측 status 뱃지 (ID 대신 status 표시)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    _getStatusText(l10n, status), // 상태 텍스트 번역
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.white.withOpacity(0.08), height: 1),

            const SizedBox(height: 12),
            // 하단: 시간/인원
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: Colors.white.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.people_rounded,
                  size: 18,
                  color: Colors.white.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.passengers(passengers),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // docRef 존재 여부 간단 표시 (선택)
                if (docRef != null)
                  Icon(
                    Icons.link,
                    size: 16,
                    color: Colors.white.withOpacity(0.45),
                  ),
              ],
            ),

            const SizedBox(height: 16),
            // 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap ?? () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // key-value 라인 위젯
  static Widget _kv(String k, String v) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$k  ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: v,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // 상태 텍스트 번역
  static String _getStatusText(AppLocalizations l10n, String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return l10n.statusActive;
      case 'on progress':
        return l10n.statusOnProgress;
      case 'pending':
        return l10n.statusPending;
      case 'accepted':
        return l10n.statusAccepted;
      default:
        return status; // 알 수 없는 상태는 원본 반환
    }
  }
}
