import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequest {
  final String id;
  final DocumentReference<Map<String, dynamic>> ref;
  final String fromName;
  final String toName;
  final int peopleCount;
  final int luggageCount;
  final String status;
  final DateTime? departureAt;

  RideRequest({
    required this.id,
    required this.ref,
    required this.fromName,
    required this.toName,
    required this.peopleCount,
    required this.luggageCount,
    required this.status,
    required this.departureAt
  });

  factory RideRequest.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
        // 🔹 departureAt 타임스탬프 -> DateTime 변환
    final ts = data['departureAt'] as Timestamp?;
    final departureAt = ts?.toDate();
    return RideRequest(
      id: doc.id,
      ref: doc.reference,
      fromName: data['fromName'] as String? ?? '',
      toName: data['toName'] as String? ?? '',
      peopleCount: (data['peopleCount'] ?? 0) as int,
      luggageCount: (data['luggageCount'] ?? 0) as int,
      departureAt: departureAt , 
      status: data['status'] as String? ?? 'pending',
    );
  }
}