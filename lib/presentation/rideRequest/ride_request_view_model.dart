import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tago_driver/presentation/rideRequest/ride_request_model.dart';

class RideRequestViewModel extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  /// 대기중(pending) 여정 스트림
  Stream<List<RideRequest>> get pendingRequestsStream {
    return _db
        .collectionGroup('items')
        // .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => RideRequest.fromDoc(d)).toList(),
        );
  }

  /// 라이드를 배정하면서 status 업데이트
  Future<void> assignRide({
    required RideRequest request,
    required String driverId,
  }) async {
    await request.ref.update({
      'status': 'accepted',
      'driverId': driverId,
      'acceptedAt': FieldValue.serverTimestamp(),
    });
  }
}