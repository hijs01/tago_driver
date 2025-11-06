import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';

class RideRequestTile extends StatelessWidget {
  final String id; // ✅ Firestore 문서 id
  final String from;
  final String to;
  final String timeText;
  final int peopleCount;
  final String? note;
  final DocumentReference<Map<String, dynamic>> docRef; // ✅ Firestore 참조

  const RideRequestTile({
    super.key,
    required this.id,
    required this.from,
    required this.to,
    required this.timeText,
    required this.peopleCount,
    this.note,
    required this.docRef,
  });

  Future<void> _assignRide(BuildContext context) async {
    final vm = context.read<LoginViewModel>();
    final driverId = vm.currentUser?.uid;

    if (driverId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 정보가 없습니다.')),
      );
      return;
    }

    try {
      // ✅ 1) Firestore status 변경
      await docRef.update({
        'status': 'accepted',
        'driverId': driverId,
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$from → $to 배정 완료 ✅'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // ✅ 2) 채팅방 이동 (ChatRoomView)
      Navigator.pushNamed(
        context,
        '/chatRoom',
        arguments: {
          'rideRequestId': id,
          'rideRequestRefPath': docRef.path,
          'fromName': from,
          'toName': to,
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('배정 중 오류 발생: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[850]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 출발/도착
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 왼쪽 영역을 Expanded로 감싸서 오른쪽 뱃지와 공간 나눠 쓰게 함
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.radio_button_checked,
                          size: 14,
                          color: Colors.greenAccent,
                        ),
                        const SizedBox(width: 6),
                        // 🔹 텍스트가 너무 길면 ... 처리
                        Expanded(
                          child: Text(
                            from,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 14,
                      width: 1,
                      color: Colors.grey[700],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            to,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 인원 뱃지
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 13, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '$peopleCount명',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 시간
          Text(
            timeText,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 15,
            ),
          ),

          // 메모
          if (note != null && note!.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              note!,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 10),

          // 배정 버튼
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E8B57),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _assignRide(context),
              icon: const Icon(Icons.directions_car, size: 17),
              label:  Text(
                '라이드 배정',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}