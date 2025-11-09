// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb; // ✅ 추가
// import 'package:tago_driver/presentation/common/appScaffold.dart';
// import 'package:tago_driver/presentation/pages/chat/widget/chat_tile.dart';

// class ChatView extends StatelessWidget {
//   const ChatView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // ✅ 현재 로그인한 유저 uid
//     final myUid = fb.FirebaseAuth.instance.currentUser?.uid;

//     if (myUid == null) {
//       // 로그인 안 돼있을 때 처리
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: Text(
//             '로그인이 필요합니다.',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//     }

//     // rideRequests/airport_to_school/items 컬렉션
//     final chatRoomsRef = FirebaseFirestore.instance
//         .collection('rideRequests')
//         .doc('airport_to_school')
//         .collection('items');

//     return AppScaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text(
//           "채팅방 목록 (airport_to_school)",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       backgroundColor: Colors.black,
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         // ✅ members 배열에 내 uid가 포함된 문서만 가져오기
//         stream: chatRoomsRef
//             .where('members', arrayContains: myUid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 "오류 발생: ${snapshot.error}",
//                 style: const TextStyle(color: Colors.white),
//               ),
//             );
//           }

//           final docs = snapshot.data?.docs ?? [];

//           if (docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "참여중인 채팅방이 없습니다.",
//                 style: TextStyle(color: Colors.white70),
//               ),
//             );
//           }

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final doc = docs[index];
//               final data = doc.data();

//               final chatRoomId = doc.id;
//               final fromName = data['fromName'] as String? ?? '';
//               final toName = data['toName'] as String? ?? '';
//               final title = '$fromName → $toName';

//               final lastMessage =
//                   data['lastMessage'] as String? ?? '메시지가 없습니다.';

//               // 🔹 lastTimestamp가 Timestamp인 경우에만 시간 표시
//               String timeText = '';
//               final rawTs = data['lastTimestamp'];
//               Timestamp? ts;
//               if (rawTs is Timestamp) {
//                 ts = rawTs;
//               } else {
//                 ts = null; // 문자열이거나 없으면 null
//               }

//               if (ts != null) {
//                 final dt = ts.toDate();
//                 final hh = dt.hour.toString().padLeft(2, '0');
//                 final mm = dt.minute.toString().padLeft(2, '0');
//                 timeText = '$hh:$mm';
//               }

//               const unreadCount = 0; // 아직 미구현

//               return ChatListTile(
//                 title: title,
//                 lastMessage: lastMessage,
//                 timeText: timeText,
//                 unreadCount: unreadCount,
//                 onTap: () {
//                   Navigator.pushNamed(
//                     context,
//                     '/chatRoom',
//                     arguments: {
//                       'rideRequestId': chatRoomId,
//                       'rideRequestRefPath': doc.reference.path,
//                       'fromName': fromName,
//                       'toName': toName,
//                     },
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/chat/chatList/chat_list_view_model.dart';
import 'package:tago_driver/presentation/pages/chat/widget/chat_tile.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChatListViewModel>();
    final loginVm = context.watch<LoginViewModel>();
    final me = loginVm.currentUser!;
    final myId = me.uid;
    final myName = me.name ?? '기사';

    return AppScaffold(
      appBar: null,

      backgroundGradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF89CFF0),
          Color(0xFF4169E1),
          Color(0xFF4169E1),
          Color(0xFF000000),
          Color(0xFF000000),
        ],
        stops: [0.0, 0.2, 0.2, 0.53, 1.0],
      ),

      scrollable: false,
      bodyPadding: EdgeInsets.zero,

      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),

          // 글래스모피즘 AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white.withOpacity(0.9),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '채팅방 목록',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 채팅 리스트
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: vm.getChatRoomsForDriver(myId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.white.withOpacity(0.7),
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "오류 발생",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${snapshot.error}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white.withOpacity(0.5),
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "채팅방이 없습니다",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();
                    final fromName = data['fromName'] as String? ?? '';
                    final toName = data['toName'] as String? ?? '';
                    final title = '$fromName → $toName';
                    final lastMessage =
                        data['lastMessage'] as String? ?? '메시지가 없습니다.';

                    String timeText = '';
                    final rawTs = data['lastTimestamp'];
                    if (rawTs is Timestamp) {
                      final dt = rawTs.toDate();
                      timeText =
                          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: InkWell(
                            onTap: () async {
                              await vm.handleChatRoomTap(
                                context: context,
                                doc: doc,
                                fromName: fromName,
                                toName: toName,
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // 아이콘
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.chat,
                                      color: Colors.white.withOpacity(0.9),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // 텍스트 영역
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          lastMessage,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.75,
                                            ),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 시간
                                  if (timeText.isNotEmpty)
                                    Text(
                                      timeText,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
