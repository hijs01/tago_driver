import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/rideRequest/widget/ride_request_tile.dart';
import 'package:tago_driver/presentation/rideRequest/ride_request_view_model.dart';
import 'package:tago_driver/data/models/ride_request_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginVm = context.watch<LoginViewModel>();
    final rideVm = context.watch<RideRequestViewModel>();
    final userName = loginVm.currentUser?.name ?? '기사';
    final driverId = loginVm.currentUser?.uid;

    return AppScaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        title: Text(
          '안녕하세요 $userName님 👋\n여정을 선택하세요',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '가장 최근 여정이에요.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<RideRequest>>(
              stream: rideVm.pendingRequestsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final requests = snapshot.data ?? [];

                if (requests.isEmpty) {
                  return const Center(
                    child: Text(
                      '현재 대기 중인 여정이 없습니다.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
                final r = requests.first;

                // 🔹 DateTime -> 문자열
                String timeText;
                if (r.departureAt != null) {
                  final formatter = DateFormat('M월 d일 \nh:mm a 출발', 'ko_KR');
                  timeText = formatter.format(r.departureAt!);
                } else {
                  timeText = '시간 정보 없음';
                }

                return Center(
                  child: RideRequestTile(
                    id: r.id,
                    from: r.fromName,
                    to: r.toName,
                    timeText: timeText,
                    peopleCount: r.peopleCount,
                    docRef: r.ref,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
