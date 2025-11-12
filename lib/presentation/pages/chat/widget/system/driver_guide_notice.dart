import 'package:flutter/material.dart';
import 'system_message_tile.dart';
import 'package:tago_driver/data/services/translation_service.dart';

class DriverGuideNotice extends StatefulWidget {
  final String? driverName;
  final String fareText;
  final String tipText;
  final TranslationService translationService;
  final String targetLanguage;

  const DriverGuideNotice({
    super.key,
    this.driverName,
    required this.fareText,
    required this.tipText,
    required this.translationService,
    required this.targetLanguage,
  });

  @override
  State<DriverGuideNotice> createState() => _DriverGuideNoticeState();
}

class _DriverGuideNoticeState extends State<DriverGuideNotice> {
  final Map<String, String> _translatedCache = {};
  bool _isTranslating = false;

  // 원본 한국어 텍스트
  String get _originalText1 => widget.driverName == null
      ? '드라이버가 입장했습니다.'
      : '${widget.driverName} 드라이버가 입장했습니다.';
  
  String get _originalText2 => '1. 픽업 위치를 드라이버와 채팅으로 다시 한 번 확인해주세요.';
  
  String get _originalText3 => '2. 요금은 현장에서 결제해 주세요.\n   - 예상 요금: ${widget.fareText}\n   - 추천 팁: ${widget.tipText}';
  
  String get _originalText4 => '3. 궁금한 점이 있으면 언제든지 채팅방에서 이야기해주세요.';

  Future<String> _translateText(String original) async {
    if (widget.targetLanguage == 'ko') return original;
    if (_translatedCache.containsKey(original)) {
      return _translatedCache[original]!;
    }
    
    try {
      final translated = await widget.translationService.translateText(
        text: original,
        targetLanguage: widget.targetLanguage,
      );
      _translatedCache[original] = translated;
      return translated;
    } catch (e) {
      return original;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.targetLanguage != 'ko') {
      _isTranslating = true;
      Future.microtask(() async {
        await Future.wait([
          _translateText(_originalText1),
          _translateText(_originalText2),
          _translateText(_originalText3),
          _translateText(_originalText4),
        ]);
        if (mounted) {
          setState(() {
            _isTranslating = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isTranslating && widget.targetLanguage != 'ko') {
      return SystemMessageTile(
        icon: Icons.directions_car,
        iconColor: Colors.blueAccent,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SystemMessageTile(
      icon: Icons.directions_car,
      iconColor: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<String>(
            future: _translateText(_originalText1),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? _originalText1,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          FutureBuilder<String>(
            future: _translateText(_originalText2),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? _originalText2,
                style: const TextStyle(color: Colors.white70, height: 1.4),
              );
            },
          ),
          const SizedBox(height: 4),
          FutureBuilder<String>(
            future: _translateText(_originalText3),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? _originalText3,
                style: const TextStyle(color: Colors.white70, height: 1.4),
              );
            },
          ),
          const SizedBox(height: 4),
          FutureBuilder<String>(
            future: _translateText(_originalText4),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? _originalText4,
                style: const TextStyle(color: Colors.white70, height: 1.4),
              );
            },
          ),
        ],
      ),
    );
  }
}