import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class TranslationService {
  TranslationService._({
    FirebaseFunctions? functions,
    String? callableUrl,
    String region = 'us-central1',
  })  : _functions = (functions ?? FirebaseFunctions.instanceFor(region: region)),
        _callableUrl = callableUrl,
        _region = region;

  static final TranslationService instance = TranslationService._();

  final FirebaseFunctions _functions;
  final String? _callableUrl;
  final String _region;

  /// 커스텀 URL(다른 프로젝트/리전)로 초기화하고 싶을 때 사용
  static TranslationService withCallableUrl(String callableUrl, {String region = 'us-central1'}) {
    return TranslationService._(callableUrl: callableUrl, region: region);
  }

  /// 동일 프로젝트의 Callable Functions를 특정 리전으로 강제하고 싶을 때 사용
  static TranslationService withRegion(String region) {
    return TranslationService._(region: region);
  }

  Future<String> translateText({
    required String text,
    required String targetLanguage,
    String? sourceLanguage,
    bool htmlFormat = false,
  }) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'text': text,
      'targetLanguage': targetLanguage,
      'htmlFormat': htmlFormat,
      if (sourceLanguage != null && sourceLanguage.isNotEmpty) 'sourceLanguage': sourceLanguage,
    };

    final HttpsCallable callable;
    if (_callableUrl != null) {
      callable = _functions.httpsCallableFromUrl(_callableUrl);
    } else {
      callable = _functions.httpsCallable('translateText');
    }

    final HttpsCallableResult<dynamic> result = await callable.call(payload);

    // 함수는 Google Translate API의 원본 응답(res.data)을 그대로 반환함
    // 형태: { data: { translations: [ { translatedText: "...", ... } ] } }
    final dynamic data = result.data;
    try {
      final dynamic wrapper = data is Map<String, dynamic> ? data : (data as Map);
      final dynamic dataNode = wrapper['data'];
      if (dataNode is Map) {
        final dynamic translations = dataNode['translations'];
        if (translations is List && translations.isNotEmpty) {
          final dynamic first = translations.first;
          if (first is Map && first['translatedText'] is String) {
            return first['translatedText'] as String;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        // print('TranslationService parse error: $e');
      }
    }

    throw Exception('번역 결과를 파싱할 수 없습니다. region=$_region url=${_callableUrl ?? 'default callable'}');
  }
}


