import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

/// 참여자 목록을 표시하는 컴포넌트
/// - 드라이버 정보 (drivers 컬렉션에서 조회)
/// - 승객 정보 (people 서브컬렉션에서 조회)
/// - 각 참여자의 이름, 동행자 수, 가방 수 표시
class ParticipantsList extends StatelessWidget {
  // Firebase에서 가져온 여정 데이터
  final Map<String, dynamic>? rideData;

  const ParticipantsList({
    super.key,
    required this.rideData,
  });

  /// 참여자 정보를 Firebase에서 가져오는 메서드
  /// 1. 드라이버 정보: drivers 컬렉션에서 조회
  /// 2. 승객 정보: people 서브컬렉션에서 조회
  /// 3. 이름이 없으면 users 컬렉션에서 추가 조회
  Future<List<Map<String, dynamic>>> _fetchParticipants(
    Map<String, dynamic>? rideData,
    BuildContext context,
  ) async {
    if (rideData == null) return [];

    try {
      // 라우트 인자에서 여정 문서 경로 가져오기
      final args = ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>;
      final rideRequestRefPath = args['rideRequestRefPath'] as String;
      final rideRequestRef =
          FirebaseFirestore.instance.doc(rideRequestRefPath);

      final participants = <Map<String, dynamic>>[];

      // 1단계: 드라이버 정보 추가
      final driverId = rideData['driverId'] as String?;
      if (driverId != null && driverId.isNotEmpty) {
        try {
          // drivers 컬렉션에서 드라이버 정보 조회
          final driverDoc = await FirebaseFirestore.instance
              .collection('drivers')
              .doc(driverId)
              .get();

          if (driverDoc.exists) {
            final driverData = driverDoc.data();
            if (driverData != null) {
              // 드라이버 이름 추출 (여러 필드명 시도)
              final driverName = driverData['name'] ??
                  driverData['userName'] ??
                  driverData['displayName'] ??
                  '드라이버';

              participants.add({
                'name': driverName,
                'bagCount': 0, // 드라이버는 가방 없음
                'membersCount': 0, // 드라이버는 동행자 없음
                'isDriver': true, // 드라이버 플래그
              });
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ 드라이버 조회 오류: $e');
          }
        }
      }

      // 2단계: people 서브컬렉션에서 승객 정보 가져오기
      final peopleSnapshot = await rideRequestRef.collection('people').get();

      if (peopleSnapshot.docs.isEmpty) {
        return participants; // 승객이 없으면 드라이버만 반환
      }

      // 각 승객 문서 처리
      for (final doc in peopleSnapshot.docs) {
        final data = doc.data();
        final uid = data['uid'] as String?;
        final membersCount = data['membersCount'] as int? ?? 0; // 동행자 수
        final luggageCount = data['luggageCount'] as int? ?? 0; // 가방 수

        // 이름 추출 시도 (people 문서에서 직접)
        String name = data['name'] ??
            data['userName'] ??
            data['displayName'] ??
            data['nickname'] ??
            data['user_name'] ??
            '익명';

        // 3단계: 이름이 없고 uid가 있으면 users 컬렉션에서 추가 조회
        if (uid != null && uid.isNotEmpty && name == '익명') {
          try {
            var userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get();

            if (userDoc.exists) {
              final userData = userDoc.data();
              if (userData != null) {
                // users 컬렉션에서 이름 추출
                name = userData['name'] ??
                    userData['userName'] ??
                    userData['displayName'] ??
                    userData['nickname'] ??
                    '익명';
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print('❌ users 조회 오류: $e');
            }
          }
        }

        // 승객 정보 추가
        participants.add({
          'name': name,
          'bagCount': luggageCount,
          'membersCount': membersCount,
          'isDriver': false, // 승객 플래그
        });
      }

      return participants;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching participants: $e');
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // 참여자 정보를 비동기로 가져오는 FutureBuilder
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchParticipants(rideData, context),
        builder: (context, futureSnapshot) {
          // 로딩 중일 때
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  l10n.loadingParticipants,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }

          final participants = futureSnapshot.data ?? [];

          // 참여자가 없을 때
          if (participants.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  l10n.noParticipants,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }

          // 승객 수 계산 (드라이버 제외)
          final passengerCount =
              participants.where((p) => p['isDriver'] != true).length;
          // 드라이버 존재 여부 확인
          final hasDriver = participants.any((p) => p['isDriver'] == true);

          // 참여자 목록 컨테이너
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더: 참여자 목록 타이틀
                Row(
                  children: [
                    const Icon(
                      Icons.group,
                      color: Color(0xFF4CAF50),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        // 드라이버가 있으면 승객 수만, 없으면 전체 참여자 수 표시
                        hasDriver
                            ? l10n.participantList(passengerCount)
                            : l10n.participantListNoDriver(participants.length),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 12),
                
                // 각 참여자 정보를 리스트로 표시
                ...participants.map((participant) {
                  final name = participant['name'] as String? ?? '익명';
                  final bags = participant['bagCount'] as int? ?? 0;
                  final membersCount = participant['membersCount'] as int? ?? 0;
                  final isDriver = participant['isDriver'] as bool? ?? false;

                  // 개별 참여자 정보 행
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        // 프로필 아바타 (드라이버는 택시 아이콘, 승객은 이름 첫 글자)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isDriver
                                ? Colors.blue.withOpacity(0.2) // 드라이버는 파란색
                                : const Color(0xFF4CAF50).withOpacity(0.2), // 승객은 초록색
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: isDriver
                                ? const Icon(
                                    Icons.local_taxi,
                                    color: Colors.blue,
                                    size: 18,
                                  )
                                : Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                                    style: const TextStyle(
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 이름과 드라이버 뱃지
                              Row(
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // 드라이버인 경우 뱃지 표시
                                  if (isDriver) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        l10n.driver,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              // 승객인 경우 동행자 수와 가방 수 표시
                              if (!isDriver && (membersCount > 0 || bags > 0))
                                const SizedBox(height: 4),
                              if (!isDriver)
                                Row(
                                  children: [
                                    // 동행자 수
                                    if (membersCount > 0) ...[
                                      const Icon(
                                        Icons.people,
                                        color: Colors.white54,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        l10n.passengers(membersCount),
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                    if (membersCount > 0 && bags > 0)
                                      const SizedBox(width: 12),
                                    // 가방 수
                                    if (bags > 0) ...[
                                      const Icon(
                                        Icons.luggage,
                                        color: Colors.white54,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        l10n.bags(bags),
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
