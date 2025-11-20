import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tago_driver/l10n/app_localizations.dart';
import 'package:tago_driver/presentation/pages/map/ridemap_view.dart';

/// Drawer 내부 액션 버튼들 컴포넌트
/// - 라이드 시작하기: 여정 상태를 'on progress'로 변경
/// - 채팅방 나가기: members 배열에서 제거하고 driverId 삭제
/// - 여정 경로 확인하기: 지도 화면으로 이동
/// - 라이드 종료: 채팅방과 모든 메시지 삭제
class DrawerActionButtons extends StatelessWidget {
  // Firebase Firestore 여정 문서 레퍼런스
  final DocumentReference<Map<String, dynamic>> rideRequestRef;
  
  // 출발지 이름
  final String fromName;
  
  // 도착지 이름
  final String toName;
  
  // 현재 사용자 ID
  final String myId;

  const DrawerActionButtons({
    super.key,
    required this.rideRequestRef,
    required this.fromName,
    required this.toName,
    required this.myId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // 1. 라이드 시작하기 버튼
          // 여정 상태를 'on progress'로 변경하여 라이드 시작
          _buildDrawerItem(
            context: context,
            icon: Icons.play_arrow,
            title: l10n.startRide,
            color: const Color(0xFF4CAF50),
            onTap: () async {
              Navigator.pop(context); // Drawer 닫기
              try {
                // Firebase에서 여정 상태 업데이트
                await rideRequestRef.update({'status': 'on progress'});
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.rideStarted),
                      backgroundColor: const Color(0xFF4CAF50),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                // 에러 발생 시 에러 메시지 표시
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.updateError(e.toString())),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 12),

          // 2. 채팅방 나가기 버튼
          // members 배열에서 제거하고 driverId 삭제, 상태를 'active'로 변경
          _buildDrawerItem(
            context: context,
            icon: Icons.exit_to_app,
            title: l10n.leaveChatRoom,
            color: Colors.redAccent,
            onTap: () async {
              Navigator.pop(context);
              final firestore = FirebaseFirestore.instance;
              final userId = myId;
              final rideRef = rideRequestRef;

              try {
                // 트랜잭션으로 안전하게 처리
                // 드라이버는 people 컬렉션이 없으므로 members 배열에서만 제거
                await firestore.runTransaction((transaction) async {
                  final rideSnap = await transaction.get(rideRef);
                  if (!rideSnap.exists) {
                    throw Exception(l10n.chatRoomNotFound);
                  }

                  final rideData = rideSnap.data()!;
                  final members = List<dynamic>.from(rideData['members'] ?? []);

                  // members 배열에서 내 ID 제거
                  if (members.contains(userId)) {
                    members.remove(userId);

                    // 상태를 'active'로 변경하고 driverId 삭제
                    transaction.update(rideRef, {
                      'members': members,
                      'status': 'active',
                      'driverId': FieldValue.delete(),
                    });
                  }
                });

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.leftChatRoom),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.redAccent,
                    ),
                  );

                  Navigator.pushReplacementNamed(context, '/main');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.leaveChatError(e.toString())),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
          ),

          const SizedBox(height: 12),

          // 3. 여정 경로 확인하기 버튼
          // 지도 화면으로 이동하여 출발지-도착지 경로 확인
          _buildDrawerItem(
            context: context,
            icon: Icons.map,
            title: l10n.checkTripRoute,
            color: const Color(0xFF4CAF50),
            onTap: () async {
              Navigator.pop(context);
              try {
                final doc = await rideRequestRef.get();
                final data = doc.data();
                final fromAddress = data?['fromAddress'] as String?;
                final toAddress = data?['toAddress'] as String?;
                final status = data?['status'] as String? ?? 'pending';
                final useCurrentLocation = status.toLowerCase() == 'on progress';

                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RideMapView(
                        fromAddress: fromAddress,
                        toAddress: toAddress,
                        fromName: fromName,
                        toName: toName,
                        useCurrentLocation: useCurrentLocation,
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.mapLoadError(e.toString())),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 12),

          // 4. 라이드 종료 버튼
          // 확인 다이얼로그 후 채팅방과 모든 메시지 삭제
          _buildDrawerItem(
            context: context,
            icon: Icons.check_circle,
            title: l10n.endRide,
            color: const Color(0xFFFF9800),
            onTap: () async {
              Navigator.pop(context);

              // 확인 다이얼로그 표시 (실수로 누르는 것 방지)
              await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1F26),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  title: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFFF9800),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.endRideDialogTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    l10n.endRideDialogMessage,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final firestore = FirebaseFirestore.instance;
                          final batch = firestore.batch();

                          // 1단계: Chats 서브컬렉션의 모든 메시지 문서 조회 및 삭제
                          final chatsSnapshot = await rideRequestRef
                              .collection('Chats')
                              .get();

                          for (final doc in chatsSnapshot.docs) {
                            batch.delete(doc.reference);
                          }

                          // 2단계: rideRequest 문서 삭제
                          batch.delete(rideRequestRef);

                          // 3단계: 일괄 실행 (모든 삭제 작업)
                          await batch.commit();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.rideEnded),
                                backgroundColor: const Color(0xFFFF9800),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            // 4단계: 메인 화면으로 이동 (모든 이전 화면 제거)
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/main',
                              (route) => false,
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.rideEndError(e.toString())),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }

                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/main',
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        l10n.end,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Drawer 버튼 아이템 빌드 헬퍼 메서드
  /// 재사용 가능한 버튼 UI 생성
  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
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
    );
  }
}
