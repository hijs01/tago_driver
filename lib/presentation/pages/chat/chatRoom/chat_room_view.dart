import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import 'package:tago_driver/data/models/chat_message_model.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/chat_room_view_model.dart';
import 'package:tago_driver/presentation/pages/chat/widget/chat_bubble.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 라우트로 넘어온 파라미터
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final rideRequestRefPath = args['rideRequestRefPath'] as String;
    final fromName = args['fromName'] as String? ?? ''; // ✅ null 안전 처리
    final toName = args['toName'] as String? ?? ''; // ✅ null 안전 처리

    // ✅ 여정 문서 레퍼런스
    final rideRequestRef = FirebaseFirestore.instance.doc(rideRequestRefPath);

    // ✅ 로그인 유저 정보
    final loginVm = context.watch<LoginViewModel>();
    final me = loginVm.currentUser!;
    final myId = me.uid;
    final myName = me.name ?? '기사';

    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(rideRequestRef),
      child: AppScaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.black,
          title: Text(
            '$fromName\n↓\n$toName',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        // ✅ 우측에서 슬라이드되는 Drawer 추가
        // endDrawer: Drawer(
        //   backgroundColor: Colors.black,
        //   child: SafeArea(
        //     child: Column(
        //       children: [
        //         // 헤더
        //         Container(
        //           padding: const EdgeInsets.all(24),
        //           decoration: BoxDecoration(
        //             color: Colors.grey[900],
        //             border: Border(
        //               bottom: BorderSide(color: Colors.grey[800]!, width: 1),
        //             ),
        //           ),
        //           child: Row(
        //             children: [
        //               const Icon(
        //                 Icons.info_outline,
        //                 color: Colors.white,
        //                 size: 24,
        //               ),
        //               const SizedBox(width: 12),
        //               Expanded(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       '여정 정보',
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                         fontSize: 18,
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                     const SizedBox(height: 4),
        //                     Text(
        //                       '$fromName → $toName',
        //                       style: TextStyle(
        //                         color: Colors.white70,
        //                         fontSize: 14,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),

        //         // 메뉴 항목들
        //         Expanded(
        //           child: ListView(
        //             padding: EdgeInsets.zero,
        //             children: [
        //               ListTile(
        //                 leading: const Icon(
        //                   Icons.info_outline,
        //                   color: Colors.white,
        //                 ),
        //                 title: const Text(
        //                   '여정 상세 정보',
        //                   style: TextStyle(color: Colors.white),
        //                 ),
        //                 onTap: () {
        //                   Navigator.pop(context);
        //                   // 여정 상세 정보 화면으로 이동
        //                 },
        //               ),
        //               Divider(color: Colors.grey[800]),
        //               ListTile(
        //                 leading: const Icon(
        //                   Icons.exit_to_app,
        //                   color: Colors.red,
        //                 ),
        //                 title: const Text(
        //                   '채팅방 나가기',
        //                   style: TextStyle(color: Colors.red),
        //                 ),
        //                 onTap: () {
        //                   Navigator.pop(context);
        //                   // 채팅방 나가기 로직
        //                 },
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        endDrawer: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Drawer(
              backgroundColor: Colors.black.withOpacity(0.3),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble,
                          color: Colors.white.withOpacity(0.8),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '$toName 님과의 대화',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Drawer 내부 버튼들
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // ✅ 라이드 시작하기
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.play_arrow, // ✅ 아이콘 변경
                          title: '라이드 시작하기', // ✅ 텍스트 변경
                          color: Colors.white,
                          onTap: () async {
                            Navigator.pop(context);
                            try {
                              await rideRequestRef.update({
                                'status': 'on progress',
                              }); // ✅ status 변경
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      '라이드를 시작합니다.', // ✅ 텍스트 변경
                                    ),
                                    backgroundColor: Colors.green.withOpacity(
                                      0.8,
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('업데이트 중 오류 발생: $e'),
                                    backgroundColor: Colors.red.withOpacity(
                                      0.8,
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 12),

                        // ✅ 채팅방 나가기
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.exit_to_app,
                          title: '채팅방 나가기',
                          color: Colors.redAccent,
                          onTap: () async {
                            Navigator.pop(context);
                            final firestore = FirebaseFirestore.instance;
                            final userId = myId;
                            final rideRef = rideRequestRef;

                            try {
                              // ✅ 드라이버는 people 컬렉션이 없으므로 members 배열에서만 제거
                              await firestore.runTransaction((
                                transaction,
                              ) async {
                                final rideSnap = await transaction.get(rideRef);
                                if (!rideSnap.exists) {
                                  throw Exception('채팅방 문서를 찾을 수 없습니다.');
                                }

                                final rideData = rideSnap.data()!;
                                final members = List<dynamic>.from(
                                  rideData['members'] ?? [],
                                );

                                // members 배열에서 내 ID 제거
                                if (members.contains(userId)) {
                                  members.remove(userId);

                                  // ✅ status를 'active'로 변경하고 driverId 제거
                                  transaction.update(rideRef, {
                                    'members': members,
                                    'status':
                                        'active', // ✅ accepted -> active로 변경
                                    'driverId':
                                        FieldValue.delete(), // ✅ driverId 제거
                                  });
                                }
                              });

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('채팅방에서 나갔습니다.'),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );

                                Navigator.pushReplacementNamed(
                                  context,
                                  '/main',
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('채팅방 나가기 중 오류 발생: $e'),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        body: Column(
          children: [
            // 📩 메세지 리스트
            // ChatRoomView 의 Expanded 안
            Expanded(
              child: Consumer<ChatViewModel>(
                builder: (context, vm, _) {
                  return StreamBuilder<List<ChatMessage>>(
                    stream: vm.messagesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '오류 발생: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final messages = snapshot.data ?? [];

                      if (messages.isEmpty) {
                        return const Center(
                          child: Text(
                            '첫 메세지를 보내보세요 🙂',
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      }

                      // ✅ reverse 안 씀, index도 그대로
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe = msg.senderId == myId;

                          return ChatBubble(
                            text: msg.text,
                            isMe: isMe,
                            senderName: msg.senderName,
                            createdAt: msg.createdAt,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),

        // ✏️ 입력창 (AppScaffold의 footer에 붙임)
        footer: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '메세지를 입력하세요',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Consumer<ChatViewModel>(
              builder: (context, vm, _) {
                return IconButton(
                  onPressed: () async {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;

                    await vm.sendMessage(
                      text: text,
                      senderId: myId,
                      senderName: myName,
                    );
                    _controller.clear();
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.blueAccent,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
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
}
