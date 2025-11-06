import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequest {
  final String id;
  final DocumentReference<Map<String, dynamic>> ref;
  final String fromName;
  final String toName;
  final int peopleCount;
  final int luggageCount;
  final String timeText;
  final String status;

  RideRequest({
    required this.id,
    required this.ref,
    required this.fromName,
    required this.toName,
    required this.peopleCount,
    required this.luggageCount,
    required this.timeText,
    required this.status,
  });

  factory RideRequest.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return RideRequest(
      id: doc.id,
      ref: doc.reference,
      fromName: data['fromName'] as String? ?? '',
      toName: data['toName'] as String? ?? '',
      peopleCount: (data['peopleCount'] ?? 0) as int,
      luggageCount: (data['luggageCount'] ?? 0) as int,
      timeText: data['timeText'] as String? ?? '시간 정보 없음',
      status: data['status'] as String? ?? 'pending',
    );
  }
}