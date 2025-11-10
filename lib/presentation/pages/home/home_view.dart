import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/rideRequest/widget/ride_request_tile.dart';
import 'package:tago_driver/presentation/rideRequest/ride_request_view_model.dart';
import 'package:tago_driver/data/models/ride_request_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // 설정 화면처럼 Firestore에서 사용자 정보 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginViewModel>().loadUserFromFirestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginVm = context.watch<LoginViewModel>();
    final rideVm = context.watch<RideRequestViewModel>();
    final userName = loginVm.currentUser?.name ?? '기사';

    return AppScaffold(
      backgroundColor: const Color(0xFF0F1419),
      bodyPadding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              MediaQuery.of(context).padding.top + 20,
              24,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '안녕하세요',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$userName 님',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

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
                  '대기 중인 라이드 요청',
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
              stream: rideVm.activeRequestsStream,
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

                final requests = snapshot.data ?? [];

                if (requests.isEmpty) {
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
                              '대기 중인 여정이 없습니다',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '새로운 요청이 오면 알려드릴게요',
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
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final r = requests[index];

                    // DateTime -> 문자열
                    String timeText;
                    if (r.departureAt != null) {
                      final formatter = DateFormat('M월 d일 • h:mm a', 'ko_KR');
                      timeText = formatter.format(r.departureAt!);
                    } else {
                      timeText = '시간 정보 없음';
                    }

                    return RideRequestTile(
                      text: '요청 수락하기',
                      id: r.id,
                      origin: r.fromName,
                      destination: r.toName,
                      time: timeText,
                      passengers: r.peopleCount,
                      status: r.status, // ✅ status 추가
                      docRef: r.ref,
                      onTap: () {
                        rideVm.assignRide(request: r);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('요청이 수락되었습니다.')),
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
