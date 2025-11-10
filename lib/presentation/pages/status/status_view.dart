import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/rideRequest/widget/ride_request_tile.dart';
import 'package:tago_driver/presentation/rideRequest/ride_request_view_model.dart';
import 'package:tago_driver/data/models/ride_request_model.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginVm = context.watch<LoginViewModel>();
    final rideVm = context.watch<RideRequestViewModel>();
    final driverId = loginVm.currentUser?.uid;
    // driverId를 사용해서 스트림 생성
    final acceptedStream = rideVm.getacceptedRequestsStream(driverId);
    final onProgressStream = rideVm.getOnProgressRequestsStream(driverId);

    return AppScaffold(
      backgroundColor: const Color(0xFF0F1419),
      bodyPadding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          SizedBox(height: MediaQuery.of(context).padding.top + 32),

          // "다음 여정" 헤더
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
                const Text(
                  '배정된 라이드 여정',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 여정 리스트
          Expanded(
            child: StreamBuilder<List<RideRequest>>(
              stream: acceptedStream,
              builder: (context, acceptedSnapshot) {
                return StreamBuilder<List<RideRequest>>(
                  stream: onProgressStream,
                  builder: (context, onProgressSnapshot) {
                    // 두 스트림 모두 로딩 중인지 확인
                    if (acceptedSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        onProgressSnapshot.connectionState ==
                            ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFF4CAF50),
                          ),
                          strokeWidth: 3,
                        ),
                      );
                    }

                    // 두 스트림의 데이터를 합침
                    final acceptedRequests = acceptedSnapshot.data ?? [];
                    final onProgressRequests = onProgressSnapshot.data ?? [];
                    final allRequests = [
                      ...acceptedRequests,
                      ...onProgressRequests,
                    ];

                    if (allRequests.isEmpty) {
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
                                    Icons.local_taxi,
                                    size: 64,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  '배정된 여정이 없습니다',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '라이드를 배정하면 여정 목록에 추가됩니다',
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

                    // 🔥 여러 개의 요청을 ListView로 표시
                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        MediaQuery.of(context).padding.bottom + 16,
                      ),
                      itemCount: allRequests.length,
                      itemBuilder: (context, index) {
                        final r = allRequests[index];

                        // DateTime -> 문자열
                        String timeText;
                        if (r.departureAt != null) {
                          final formatter = DateFormat(
                            'M월 d일 • h:mm a',
                            'ko_KR',
                          );
                          timeText = formatter.format(r.departureAt!);
                        } else {
                          timeText = '시간 정보 없음';
                        }

                        return RideRequestTile(
                          text: '채팅방 입장',
                          id: r.id,
                          origin: r.fromName,
                          destination: r.toName,
                          time: timeText,
                          passengers: r.peopleCount,
                          status: r.status, // ✅ status 추가
                          docRef: r.ref,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/chatRoom',
                              arguments: {
                                'rideRequestRefPath': r.ref.path,
                                'fromName': r.fromName,
                                'toName': r.toName,
                              },
                            );
                          },
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
    );
  }
}
