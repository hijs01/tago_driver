import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tago_driver/l10n/app_localizations.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/widget/trip_info_section.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/widget/participants_list.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/widget/drawer_action_buttons.dart';

/// 채팅방 우측 Drawer 컴포넌트
/// - 여정 통계 정보 (승객 수, 가방 수)
/// - 참여자 목록 (드라이버 + 승객들)
/// - 액션 버튼들 (라이드 시작, 나가기, 경로 확인, 라이드 종료)
class ChatRoomDrawer extends StatelessWidget {
  // Firebase Firestore 여정 문서 레퍼런스
  final DocumentReference<Map<String, dynamic>> rideRequestRef;
  
  // 출발지 이름
  final String fromName;
  
  // 도착지 이름
  final String toName;
  
  // 현재 사용자 ID
  final String myId;

  const ChatRoomDrawer({
    super.key,
    required this.rideRequestRef,
    required this.fromName,
    required this.toName,
    required this.myId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: const Color(0xFF0F1419),
      // 실시간으로 여정 데이터를 감시하는 StreamBuilder
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: rideRequestRef.snapshots(),
        builder: (context, snapshot) {
          final rideData = snapshot.data?.data();

          return Column(
            children: [
              // 상단 여백 (상태바 높이 + 추가 여백)
              SizedBox(height: MediaQuery.of(context).padding.top + 20),
              
              // 헤더: "여정 정보" 타이틀
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // 초록색 세로 바 (디자인 요소)
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.tripInformation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 여정 통계 정보 섹션 (승객 수, 가방 수)
              TripInfoSection(rideData: rideData),

              const SizedBox(height: 16),

              // 참여자 목록 섹션 (드라이버 + 승객들)
              ParticipantsList(rideData: rideData),

              const SizedBox(height: 16),

              // Drawer 내부 액션 버튼들 (라이드 시작, 나가기, 경로 확인, 종료)
              DrawerActionButtons(
                rideRequestRef: rideRequestRef,
                fromName: fromName,
                toName: toName,
                myId: myId,
              ),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
