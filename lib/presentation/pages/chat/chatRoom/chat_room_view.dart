import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tago_driver/data/models/chat_message_model.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/chat_room_view_model.dart';
import 'package:tago_driver/data/services/translation_service.dart';
import 'package:tago_driver/data/services/translation_config.dart';
import 'package:flutter/foundation.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/widget/chat_room_drawer.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/widget/chat_message_list.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/widget/chat_input_field.dart';

/// 채팅방 메인 화면
/// - 드라이버와 승객 간의 실시간 채팅을 제공
/// - 메시지 번역 기능 포함
/// - 여정 정보 및 참여자 목록을 Drawer에서 확인 가능
class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  // 텍스트 입력 컨트롤러
  final _controller = TextEditingController();
  
  // 메시지 리스트 스크롤 컨트롤러
  final _scrollController = ScrollController();
  
  // 번역된 메시지 캐시 (메시지 ID -> 번역된 텍스트)
  final Map<String, String> _translatedCache = {};
  
  // 번역 서비스 인스턴스
  late final TranslationService _translationService;
  
  // 원문 표시 여부를 저장하는 Set (메시지 ID)
  final Set<String> _showOriginal = {};

  @override
  void initState() {
    super.initState();
    // 번역 서비스 초기화
    // Callable URL이 설정되어 있으면 사용, 없으면 Region 기반으로 초기화
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
    // 리소스 정리
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }


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


  @override
  Widget build(BuildContext context) {
    // 라우트로 넘어온 파라미터 추출
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final rideRequestRefPath = args['rideRequestRefPath'] as String;
    final fromName = args['fromName'] as String? ?? ''; // 출발지 이름
    final toName = args['toName'] as String? ?? ''; // 도착지 이름

    // Firebase Firestore에서 여정 문서 레퍼런스 가져오기
    final rideRequestRef = FirebaseFirestore.instance.doc(rideRequestRefPath);

    // 현재 로그인한 사용자 정보 가져오기
    final loginVm = context.watch<LoginViewModel>();
    final me = loginVm.currentUser!;
    final myId = me.uid; // 내 사용자 ID
    final myName = me.name; // 내 이름

    // ChatViewModel을 Provider로 제공하고 화면 구성
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

        // 우측에서 슬라이드되는 Drawer (여정 정보, 참여자 목록, 액션 버튼 포함)
        // 기존 주석 처리된 코드는 이전 버전
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
        // 우측 Drawer: 여정 정보, 참여자 목록, 액션 버튼들을 포함하는 컴포넌트
        endDrawer: ChatRoomDrawer(
          rideRequestRef: rideRequestRef,
          fromName: fromName,
          toName: toName,
          myId: myId,
        ),

        // 메시지 리스트 영역
        body: Column(
          children: [
            Expanded(
              // 채팅 메시지 리스트 컴포넌트
              // - 실시간 메시지 스트림 표시
              // - 번역 기능 포함
              // - 드라이버 입장 안내 시스템 메시지 처리
              child: ChatMessageList(
                scrollController: _scrollController,
                translationService: _translationService,
                myId: myId,
                myName: myName,
                showOriginal: _showOriginal,
                translatedCache: _translatedCache,
                ensureTranslationOrNull: _ensureTranslationOrNull,
              ),
            ),
          ],
        ),

        // 하단 메시지 입력창 컴포넌트
        footer: ChatInputField(
          controller: _controller,
          myId: myId,
          myName: myName,
        ),
      ),
    );
  }

}
