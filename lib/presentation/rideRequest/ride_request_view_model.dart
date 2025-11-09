import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:tago_driver/data/models/ride_request_model.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';

class RideRequestViewModel extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = fb.FirebaseAuth.instance;

  /// 대기중(pending) 여정 스트림
  Stream<List<RideRequest>> get pendingRequestsStream {
    return _db
        .collectionGroup('items')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snap) => snap.docs.map((d) => RideRequest.fromDoc(d)).toList());
  }

  /// 활성화된(active) 여정 스트림
  Stream<List<RideRequest>> get activeRequestsStream {
    return _db
        .collectionGroup('items')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snap) => snap.docs.map((d) => RideRequest.fromDoc(d)).toList());
  }

  /// 배정된(accepted) 여정 스트림
  Stream<List<RideRequest>> getacceptedRequestsStream(String? driverId) {
    if (driverId == null || driverId.isEmpty) {
      return Stream.value(<RideRequest>[]);
    }

    return _db
        .collectionGroup('items')
        .where('status', isEqualTo: 'accepted')
        .where('driverId', isEqualTo: driverId)
        .snapshots()
        .map((snap) => snap.docs.map((d) => RideRequest.fromDoc(d)).toList());
  }

  /// 진행중인(on progress) 여정 스트림
  Stream<List<RideRequest>> getOnProgressRequestsStream(String? driverId) {
    // ✅ 메서드명 수정
    if (driverId == null || driverId.isEmpty) {
      return Stream.value(<RideRequest>[]);
    }

    return _db
        .collectionGroup('items')
        .where('status', isEqualTo: 'on progress')
        .where('driverId', isEqualTo: driverId)
        .snapshots()
        .map((snap) => snap.docs.map((d) => RideRequest.fromDoc(d)).toList());
  }

  /// 라이드를 배정하면서 status 업데이트 + members에 현재 드라이버 uid 추가
  Future<void> assignRide({required RideRequest request}) async {
    final driver = _auth.currentUser;
    if (driver == null) return; // 혹시 모를 로그인 안 된 경우 방어

    await request.ref.update({
      'status': 'accepted',
      'driverId': driver.uid,
      'acceptedAt': FieldValue.serverTimestamp(),
      'members': FieldValue.arrayUnion([driver.uid]), // 🔥 여기 중요
    });
  }
}
