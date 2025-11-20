import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tago_driver/data/models/chat_message_model.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/chat_room_view_model.dart';
import 'package:tago_driver/presentation/pages/chat/widget/chat_bubble.dart';
import 'package:tago_driver/presentation/pages/chat/widget/system/driver_guide_notice.dart';
import 'package:tago_driver/data/services/translation_service.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

/// 채팅 메시지 리스트 컴포넌트
/// - 실시간 메시지 스트림 표시
/// - 메시지 번역 기능 (원문/번역문 토글)
/// - 드라이버 입장 안내 시스템 메시지 처리
/// - 자동 스크롤 (새 메시지가 오면 맨 아래로)
class ChatMessageList extends StatefulWidget {
  // 스크롤 컨트롤러
  final ScrollController scrollController;
  
  // 번역 서비스
  final TranslationService translationService;
  
  // 현재 사용자 ID
  final String myId;
  
  // 현재 사용자 이름
  final String myName;
  
  // 원문 표시 여부를 저장하는 Set (메시지 ID)
  final Set<String> showOriginal;
  
  // 번역 캐시 (메시지 ID -> 번역된 텍스트)
  final Map<String, String> translatedCache;
  
  // 번역 함수 (부모에서 전달받음)
  final Future<String?> Function({
    required ChatMessage message,
    required bool isMe,
    required BuildContext context,
  }) ensureTranslationOrNull;

  const ChatMessageList({
    super.key,
    required this.scrollController,
    required this.translationService,
    required this.myId,
    required this.myName,
    required this.showOriginal,
    required this.translatedCache,
    required this.ensureTranslationOrNull,
  });

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  // 드라이버 입장 안내 메시지 초기화 플래그 (한 번만 실행)
  bool _hasInitializedDriverJoinNotice = false;

  /// 메시지 리스트를 맨 아래로 스크롤하는 메서드
  /// 새 메시지가 올 때 자동으로 호출됨
  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            widget.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<ChatViewModel>(
      builder: (context, vm, _) {
        // 드라이버 입장 안내 메시지 초기화 (한 번만 실행)
        // build 메서드에서 side-effect를 피하기 위해 플래그 사용
        if (!_hasInitializedDriverJoinNotice) {
          _hasInitializedDriverJoinNotice = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            vm.ensureDriverJoinNoticeSent(
              driverName: widget.myName,
              fareText: '앱에 표시된 금액', // TODO: 실제 요금 문자열로 바꾸기
              tipText: '자유롭게 주시면 됩니다', // TODO: 정책에 맞게 바꾸기
            );
          });
        }

        // 실시간 메시지 스트림 구독
        return StreamBuilder<List<ChatMessage>>(
          stream: vm.messagesStream,
          builder: (context, snapshot) {
            // 로딩 중일 때
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

            // 에러 발생 시
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

            // 메시지가 없을 때
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

            // 메시지가 로드되면 맨 아래로 자동 스크롤
            _scrollToBottom();

            // 메시지 리스트 빌드
            return ListView.builder(
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                // 1) 시스템 메시지: 드라이버 입장 안내
                if (msg.type == ChatMessageType.system &&
                    msg.systemType == 'driver_join') {
                  final locale = Localizations.localeOf(context);
                  final targetLanguage = locale.languageCode;
                  return DriverGuideNotice(
                    driverName: msg.driverName,
                    fareText: msg.fareText ?? '앱에 표시된 금액',
                    tipText: msg.tipText ?? '선택 사항입니다',
                    translationService: widget.translationService,
                    targetLanguage: targetLanguage,
                  );
                }

                // 2) 일반 채팅 메시지
                final isMe = msg.senderId == widget.myId;

                // 번역 여부 확인 및 표시
                return FutureBuilder<String?>(
                  future: widget.ensureTranslationOrNull(
                    message: msg,
                    isMe: isMe,
                    context: context,
                  ),
                  builder: (context, snapshot) {
                    final String? translated = snapshot.data;
                    final bool hasTranslation = translated != null; // 번역이 있는지 여부
                    final bool showOriginal =
                        widget.showOriginal.contains(msg.id); // 원문 표시 여부
                    
                    // 번역이 있고 원문 표시가 아니면 번역문, 아니면 원문 표시
                    final String displayText = hasTranslation && !showOriginal
                        ? translated
                        : msg.text;

                    return Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end // 내 메시지는 오른쪽 정렬
                          : CrossAxisAlignment.start, // 상대방 메시지는 왼쪽 정렬
                      children: [
                        // 채팅 말풍선
                        ChatBubble(
                          text: displayText,
                          isMe: isMe,
                          senderName: msg.senderName,
                          createdAt: msg.createdAt,
                        ),
                        // 번역이 있고 내 메시지가 아니면 원문/번역문 토글 버튼 표시
                        if (hasTranslation && !isMe)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 2,
                              left: 8,
                              right: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // 원문/번역문 토글
                                setState(() {
                                  if (showOriginal) {
                                    widget.showOriginal.remove(msg.id);
                                  } else {
                                    widget.showOriginal.add(msg.id);
                                  }
                                });
                              },
                              child: Text(
                                showOriginal
                                    ? l10n.viewTranslation // 원문 보이는 중이면 "번역 보기"
                                    : l10n.viewOriginal, // 번역 보이는 중이면 "원문 보기"
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
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
    );
  }
}
