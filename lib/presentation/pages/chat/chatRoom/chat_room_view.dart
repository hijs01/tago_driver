import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tago_driver/data/models/chat_message_model.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/chat_room_view_model.dart';
import 'package:tago_driver/presentation/pages/chat/widget/chat_bubble.dart';
import 'package:tago_driver/presentation/pages/chat/widget/system/driver_guide_notice.dart';
import 'package:tago_driver/data/services/translation_service.dart';
import 'package:tago_driver/data/services/translation_config.dart';
import 'package:flutter/foundation.dart';
import 'package:tago_driver/presentation/pages/map/ridemap_view.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final Map<String, String> _translatedCache = {};
  late final TranslationService _translationService;
  final Set<String> _showOriginal = {};
  bool _hasInitializedDriverJoinNotice = false; // ✅ 한 번만 실행되도록 플래그 추가

  @override
  void initState() {
    super.initState();
    final url = TranslationConfig.translateCallableUrl;
    if (url.isNotEmpty) {
      _translationService = TranslationService.withCallableUrl(url);
    } else {
      _translationService = TranslationService.withRegion(
        TranslationConfig.translateRegion,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 메시지 목록이 업데이트될 때 맨 아래로 스크롤
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  // (이전 버전의 표시 전용 함수는 제거했습니다. 이제 _ensureTranslationOrNull을 사용합니다.)

  /// 번역문을 확보하되, 번역 실패/동일 결과면 null을 반환 (토글 버튼 숨김 목적)
  Future<String?> _ensureTranslationOrNull({
    required ChatMessage message,
    required bool isMe,
    required BuildContext context,
  }) async {
    if (isMe) return null;
    final String original = message.text;
    if (original.trim().isEmpty) return null;
    
    // 현재 앱의 로케일 확인
    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode;
    // 지원되는 언어로만 제한 (ko, en), 그 외는 영어로 fallback
    final targetLanguage = (languageCode == 'ko' || languageCode == 'en') 
        ? languageCode 
        : 'en';
    
    // 메시지 언어 감지 (한국어, 영어, 중국어, 스페인어)
    final bool isKoreanText = RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]').hasMatch(original);
    final bool isChineseText = RegExp(r'[\u4e00-\u9fff]').hasMatch(original);
    
    // 스페인어 감지: 스페인어 특수 문자 포함 (ñ, á, é, í, ó, ú, ü 등)
    final bool isSpanishText = RegExp(r'[ñáéíóúüÑÁÉÍÓÚÜ]').hasMatch(original) ||
                               RegExp(r'\b(hola|gracias|por favor|adiós|sí|no|buenos días|buenas noches)\b', caseSensitive: false).hasMatch(original);
    
    // 영어 텍스트 체크: 영문, 숫자, 공백, 구두점만 포함하고 다른 언어 문자가 아닌 경우
    final String trimmed = original.trim();
    final bool isEnglishText = RegExp(r'^[a-zA-Z0-9\s.,!?;:\-()]+$').hasMatch(trimmed) && 
                               !isKoreanText && !isChineseText && !isSpanishText;
    
    final bool isEnglishLocale = targetLanguage == 'en';
    
    // 번역 필요 여부 판단:
    // 1. 앱이 영어이고 메시지가 영어가 아니면 → 영어로 번역
    // 2. 앱이 한국어이고 메시지가 한국어가 아니면 → 한국어로 번역
    // 3. 같은 언어면 번역 불필요
    if (isEnglishLocale && isEnglishText) return null; // 영어 앱, 영어 메시지
    if (!isEnglishLocale && isKoreanText) return null; // 한국어 앱, 한국어 메시지
    
    // 중국어, 스페인어, 또는 다른 언어는 항상 번역 대상
    
    if (_translatedCache.containsKey(message.id)) {
      final String translated = _translatedCache[message.id]!;
      if (translated.trim().isEmpty || translated == original) return null;
      return translated;
    }
    try {
      final String translated = await _translationService.translateText(
        text: original,
        targetLanguage: targetLanguage, // 동적으로 설정
        // sourceLanguage는 자동 감지되도록 null로 전달
      );
      _translatedCache[message.id] = translated;
      if (translated.trim().isEmpty || translated == original) return null;
      return translated;
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('ensureTranslation failed: $e');
      }
      return null;
    }
  }

  /// 참여자 정보를 가져오는 메서드
  Future<List<Map<String, dynamic>>> _fetchParticipants(
    Map<String, dynamic>? rideData,
  ) async {
    if (rideData == null) return [];

    try {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final rideRequestRefPath = args['rideRequestRefPath'] as String;
      final rideRequestRef = FirebaseFirestore.instance.doc(rideRequestRefPath);

      final participants = <Map<String, dynamic>>[];

      // 1. 드라이버 정보 추가
      final driverId = rideData['driverId'] as String?;
      if (driverId != null && driverId.isNotEmpty) {
        try {
          final driverDoc =
              await FirebaseFirestore.instance
                  .collection('drivers')
                  .doc(driverId)
                  .get();

          if (driverDoc.exists) {
            final driverData = driverDoc.data();
            if (driverData != null) {
              final driverName =
                  driverData['name'] ??
                  driverData['userName'] ??
                  driverData['displayName'] ??
                  '드라이버';

              participants.add({
                'name': driverName,
                'bagCount': 0,
                'membersCount': 0,
                'isDriver': true,
              });

              if (kDebugMode) {
                print('🚗 드라이버 추가: $driverName');
              }
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ 드라이버 조회 오류: $e');
          }
        }
      }

      // 2. people 서브컬렉션에서 승객 정보 가져오기
      final peopleSnapshot = await rideRequestRef.collection('people').get();

      if (peopleSnapshot.docs.isEmpty) {
        if (kDebugMode) {
          print('⚠️ people 컬렉션이 비어있습니다');
        }
        return participants; // 드라이버만 있어도 반환
      }

      if (kDebugMode) {
        print('👥 people 컬렉션에서 ${peopleSnapshot.docs.length}명 발견');
      }

      for (final doc in peopleSnapshot.docs) {
        final data = doc.data();
        final uid = data['uid'] as String?;
        final membersCount = data['membersCount'] as int? ?? 0;
        final luggageCount = data['luggageCount'] as int? ?? 0;

        if (kDebugMode) {
          print(
            '👤 참여자 데이터: uid=$uid, membersCount=$membersCount, luggageCount=$luggageCount',
          );
        }

        String name = '익명';

        // people 문서 자체에서 이름 찾기
        name =
            data['name'] ??
            data['userName'] ??
            data['displayName'] ??
            data['nickname'] ??
            data['user_name'] ??
            '익명';

        // uid가 있으면 users 컬렉션에서 이름 조회
        if (uid != null && uid.isNotEmpty && name == '익명') {
          try {
            var userDoc =
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .get();

            if (userDoc.exists) {
              final userData = userDoc.data();
              if (userData != null) {
                name =
                    userData['name'] ??
                    userData['userName'] ??
                    userData['displayName'] ??
                    userData['nickname'] ??
                    '익명';

                if (kDebugMode) {
                  print('✅ users 컬렉션에서 이름 찾음: $name');
                }
              }
            } else {
              if (kDebugMode) {
                print('⚠️ users 컬렉션에 uid=$uid 문서가 없습니다');
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print('❌ users 조회 오류: $e');
            }
          }
        }

        participants.add({
          'name': name,
          'bagCount': luggageCount,
          'membersCount': membersCount,
          'isDriver': false,
        });
      }

      if (kDebugMode) {
        print('✅ 최종 참여자 목록: ${participants.length}명');
        for (var p in participants) {
          if (p['isDriver'] == true) {
            print('  - ${p['name']} (드라이버)');
          } else {
            print(
              '  - ${p['name']}: ${p['membersCount']}명, 가방 ${p['bagCount']}개',
            );
          }
        }
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
    final myName = me.name;
    final l10n = AppLocalizations.of(context)!;

    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(rideRequestRef),
      child: AppScaffold(
        backgroundColor: const Color(0xFF0F1419),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1419),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  fromName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward,
                  color: const Color(0xFF4CAF50),
                  size: 20,
                ),
              ),
              Flexible(
                child: Text(
                  toName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          centerTitle: true,
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
        endDrawer: Drawer(
          backgroundColor: const Color(0xFF0F1419),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: rideRequestRef.snapshots(),
            builder: (context, snapshot) {
              final rideData = snapshot.data?.data();
              final peopleCount = rideData?['peopleCount'] as int? ?? 0;
              final luggageCount = rideData?['luggageCount'] as int? ?? 0;

              return Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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

                  // 🔹 여정 통계 정보
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
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
                          Row(
                            children: [
                              const Icon(
                                Icons.people_outline,
                                color: Color(0xFF4CAF50),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  l10n.passengerCount,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                l10n.passengers(peopleCount),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(
                                Icons.luggage_outlined,
                                color: Color(0xFF4CAF50),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  l10n.totalBags,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                l10n.bags(luggageCount),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔹 참여자 목록
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchParticipants(rideData),
                      builder: (context, futureSnapshot) {
                        if (futureSnapshot.connectionState ==
                            ConnectionState.waiting) {
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
                            participants
                                .where((p) => p['isDriver'] != true)
                                .length;
                        final hasDriver = participants.any(
                          (p) => p['isDriver'] == true,
                        );

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
                              ...participants.map((participant) {
                                final name =
                                    participant['name'] as String? ?? '익명';
                                final bags =
                                    participant['bagCount'] as int? ?? 0;
                                final membersCount =
                                    participant['membersCount'] as int? ?? 0;
                                final isDriver =
                                    participant['isDriver'] as bool? ?? false;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color:
                                              isDriver
                                                  ? Colors.blue.withOpacity(0.2)
                                                  : const Color(
                                                    0xFF4CAF50,
                                                  ).withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child:
                                              isDriver
                                                  ? const Icon(
                                                    Icons.local_taxi,
                                                    color: Colors.blue,
                                                    size: 18,
                                                  )
                                                  : Text(
                                                    name.isNotEmpty
                                                        ? name[0].toUpperCase()
                                                        : '?',
                                                    style: const TextStyle(
                                                      color: Color(0xFF4CAF50),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
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
                                                if (isDriver) ...[
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      l10n.driver,
                                                      style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            if (!isDriver &&
                                                (membersCount > 0 || bags > 0))
                                              const SizedBox(height: 4),
                                            if (!isDriver)
                                              Row(
                                                children: [
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
                                                  if (membersCount > 0 &&
                                                      bags > 0)
                                                    const SizedBox(width: 12),
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
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Drawer 내부 버튼들
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // ✅ 라이드 시작하기
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.play_arrow,
                          title: l10n.startRide,
                          color: const Color(0xFF4CAF50),
                          onTap: () async {
                            Navigator.pop(context);
                            try {
                              await rideRequestRef.update({
                                'status': 'on progress',
                              });
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

                        // ✅ 채팅방 나가기
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
                              // ✅ 드라이버는 people 컬렉션이 없으므로 members 배열에서만 제거
                              await firestore.runTransaction((
                                transaction,
                              ) async {
                                final rideSnap = await transaction.get(rideRef);
                                if (!rideSnap.exists) {
                                  throw Exception(l10n.chatRoomNotFound);
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

                                Navigator.pushReplacementNamed(
                                  context,
                                  '/main',
                                );
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

                        // ✅ 여정 경로 확인하기 버튼 추가
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
                              final fromAddress =
                                  data?['fromAddress'] as String?;
                              final toAddress = data?['toAddress'] as String?;
                              final status =
                                  data?['status'] as String? ?? 'pending';
                              final useCurrentLocation =
                                  status.toLowerCase() == 'on progress';

                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => RideMapView(
                                          fromAddress: fromAddress,
                                          toAddress: toAddress,
                                          fromName: fromName,
                                          toName: toName,
                                          useCurrentLocation:
                                              useCurrentLocation,
                                        ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.mapLoadError(e.toString()),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 12),

                        // ✅ 라이드 종료 버튼 추가
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.check_circle,
                          title: l10n.endRide,
                          color: const Color(0xFFFF9800),
                          onTap: () async {
                            Navigator.pop(context);

                            // 확인 다이얼로그 표시
                            await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
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
                                        onPressed:
                                            () => Navigator.pop(context, false),
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
                                          // 다이얼로그 닫기

                                          try {
                                            final firestore =
                                                FirebaseFirestore.instance;
                                            final batch = firestore.batch();

                                            // 1. Chats 서브컬렉션의 모든 문서 조회 및 삭제
                                            final chatsSnapshot =
                                                await rideRequestRef
                                                    .collection('Chats')
                                                    .get();

                                            for (final doc
                                                in chatsSnapshot.docs) {
                                              batch.delete(doc.reference);
                                            }

                                            // 2. rideRequest 문서 삭제
                                            batch.delete(rideRequestRef);

                                            // 3. 일괄 실행
                                            await batch.commit();

                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    l10n.rideEnded,
                                                  ),
                                                  backgroundColor: const Color(
                                                    0xFFFF9800,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );

                                              // 4. 메인 화면으로 이동 (모든 이전 화면 제거)
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/main',
                                                (route) => false,
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    l10n.rideEndError(e.toString()),
                                                  ),
                                                  backgroundColor: Colors.red,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                            }
                                          }

                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/main',
                                            (route) => false,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFFF9800,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),

        body: Column(
          children: [
            // 📩 메세지 리스트
            // ChatRoomView 의 Expanded 안
            Expanded(
              child: Consumer<ChatViewModel>(
                builder: (context, vm, _) {
                  // ✅ 한 번만 실행되도록 수정 (build 메서드에서 side-effect 제거)
                  if (!_hasInitializedDriverJoinNotice) {
                    _hasInitializedDriverJoinNotice = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      vm.ensureDriverJoinNoticeSent(
                        driverName: myName,
                        fareText: '앱에 표시된 금액', // TODO: 실제 요금 문자열로 바꾸기
                        tipText: '자유롭게 주시면 됩니다', // TODO: 정책에 맞게 바꾸기
                      );
                    });
                  }
                  
                  return StreamBuilder<List<ChatMessage>>(
                    stream: vm.messagesStream,
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
                        return Center(
                          child: Text(
                            l10n.errorOccurred(snapshot.error.toString()),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        );
                      }

                      final messages = snapshot.data ?? [];

                      if (messages.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.firstMessageHint,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        );
                      }

                      // 메시지가 로드되면 맨 아래로 스크롤
                      _scrollToBottom();

                      // ✅ reverse 안 씀, index도 그대로
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];

                          // 🔹 1) 시스템 메시지: 드라이버 입장 안내
                          if (msg.type == ChatMessageType.system &&
                              msg.systemType == 'driver_join') {
                            final locale = Localizations.localeOf(context);
                            // 지원되는 언어로만 제한 (ko, en)
                            final languageCode = locale.languageCode;
                            final targetLanguage = (languageCode == 'ko' || languageCode == 'en') 
                                ? languageCode 
                                : 'en'; // 지원되지 않는 언어는 영어로 fallback
                            return DriverGuideNotice(
                              driverName: msg.driverName,
                              fareText: msg.fareText ?? '앱에 표시된 금액',
                              tipText: msg.tipText ?? '선택 사항입니다',
                              translationService: _translationService,
                              targetLanguage: targetLanguage,
                            );
                          }

                          // 🔹 2) 일반 채팅 메시지
                          final isMe = msg.senderId == myId;

                          return FutureBuilder<String?>(
                            future: _ensureTranslationOrNull(
                              message: msg,
                              isMe: isMe,
                              context: context,
                            ),
                            builder: (context, snapshot) {
                              final String? translated = snapshot.data;
                              final bool hasTranslation = translated != null;
                              final bool showOriginal = _showOriginal.contains(
                                msg.id,
                              );
                              final String displayText =
                                  hasTranslation && !showOriginal
                                      ? translated
                                      : msg.text;

                              return Column(
                                crossAxisAlignment:
                                    isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: [
                                  ChatBubble(
                                    text: displayText,
                                    isMe: isMe,
                                    senderName: msg.senderName,
                                    createdAt: msg.createdAt,
                                  ),
                                  if (hasTranslation && !isMe)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 2,
                                        left: 8,
                                        right: 8,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (showOriginal) {
                                              _showOriginal.remove(msg.id);
                                            } else {
                                              _showOriginal.add(msg.id);
                                            }
                                          });
                                        },
                                        child: Text(
                                          showOriginal ? l10n.viewTranslation : l10n.viewOriginal,
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
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

        // ✏️ 입력창 (AppScaffold의 footer에 붙임)
        footer: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1419),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: l10n.enterMessage,
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF4CAF50),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Consumer<ChatViewModel>(
                builder: (context, vm, _) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
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
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
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
