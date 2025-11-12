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
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/chat/chatList/chat_list_view_model.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChatListViewModel>();
    final loginVm = context.watch<LoginViewModel>();
    final me = loginVm.currentUser!;
    final myId = me.uid;
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      backgroundColor: const Color(0xFF0F1419),
      bodyPadding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          SizedBox(height: MediaQuery.of(context).padding.top + 32),

          // "채팅방 목록" 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.chatRoomListHeader,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 채팅 리스트
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: vm.getChatRoomsForDriver(myId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF4CAF50),
                      ),
                      strokeWidth: 3,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.errorOccurred(
                                snapshot.error?.toString() ?? '',
                              ),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.noChatRooms,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.chatRoomCreatedHint,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    MediaQuery.of(context).padding.bottom + 16,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();
                    final fromName = data['fromName'] as String? ?? '';
                    final toName = data['toName'] as String? ?? '';
                    final title = '$fromName → $toName';
                    final lastMessage =
                        data['lastMessage'] as String? ?? l10n.noMessages;

                    String timeText = '';
                    final rawTs = data['lastTimestamp'];
                    if (rawTs is Timestamp) {
                      final dt = rawTs.toDate();
                      timeText =
                          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () async {
                          await vm.handleChatRoomTap(
                            context: context,
                            doc: doc,
                            fromName: fromName,
                            toName: toName,
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // 아이콘
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF4CAF50,
                                  ).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Color(0xFF4CAF50),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),

                              // 텍스트 영역
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      lastMessage,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // 시간
                              if (timeText.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Text(
                                  timeText,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
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
