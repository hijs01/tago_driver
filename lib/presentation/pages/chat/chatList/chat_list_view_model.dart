import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// 채팅방 목록 + 채팅방 참여(join) 로직을 담당하는 ViewModel
class ChatListViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get myUid => _auth.currentUser!.uid;

  ChatListViewModel(); // 파라미터 없는 기본 생성자

  /// 채팅방 스트림 (rideType별)
  ///
  /// 경로: rideRequests/{rideType}/items
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRoomsForAllTypes(
    String myUid,
  ) {
    return FirebaseFirestore.instance
        .collectionGroup('items') // 👈 모든 rideType의 items 포함
        .where('members', arrayContains: myUid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// 채팅방 클릭 시 처리 로직
  ///
  /// 1. members에 내 uid가 있으면 → 바로 입장
  /// 2. 없으면 → Join 다이얼로그 띄우고
  ///    - 확인 시: members에 내 uid 추가 + 입장
  Future<void> handleChatRoomTap({
    required BuildContext context,
    required QueryDocumentSnapshot<Map<String, dynamic>> doc,
    required String fromName,
    required String toName,
  }) async {
    final data = doc.data();

    // members 배열 파싱
    final rawMembers = data['members'];
    final List<String> members =
        rawMembers is List
            ? rawMembers.map((e) => e.toString()).toList()
            : <String>[];

    // 🔹 이미 멤버면 바로 입장
    if (members.contains(myUid)) {
      _openChatRoom(context, doc, fromName, toName);
      return;
    }

    // 🔹 출발 시간 (departureAt)
    DateTime? departureAt;
    final depRaw = data['departureAt'];
    if (depRaw is Timestamp) {
      departureAt = depRaw.toDate();
    }

    // // 🔹 채팅 참여 확인 다이얼로그
    // final bool? confirm = await JoinChatDialog.show(
    //   context,
    //   fromName: fromName,
    //   toName: toName,
    //   departureAt: departureAt,
    // );

    // if (confirm != true) return;

    // // 🔹 members에 내 uid 추가 후 입장
    // try {
    //   await doc.reference.update({
    //     'members': FieldValue.arrayUnion([myUid]),
    //   });

    //   _openChatRoom(context, doc, fromName, toName);
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('채팅방 참여 중 오류가 발생했습니다: $e'),
    //       backgroundColor: Colors.redAccent,
    //     ),
    //   );
    // }
  }

  /// 실제 채팅방 화면으로 이동
  void _openChatRoom(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    String fromName,
    String toName,
  ) {
    Navigator.pushNamed(
      context,
      '/chatRoom',
      arguments: {
        'rideRequestId': doc.id,
        'rideRequestRefPath': doc.reference.path,
        'fromName': fromName,
        'toName': toName,
      },
    );
  }
}
