/// 번역 Callable 함수 설정
/// - 다른 Firebase 프로젝트/리전에 배포된 함수를 사용할 경우 아래 URL에 전체 엔드포인트를 넣어주세요.
///   예) https://us-central1-YOUR_PROJECT_ID.cloudfunctions.net/translateText
/// - 같은 프로젝트를 쓰고 리전만 다르면 [translateRegion]만 변경하세요.
/// - 런타임에서 --dart-define 으로 지정 가능:
///   flutter run --dart-define=TRANSLATE_URL=https://us-central1-XXX.cloudfunctions.net/translateText
///   flutter run --dart-define=TRANSLATE_REGION=us-central1
class TranslationConfig {
  static const String translateCallableUrl =
      String.fromEnvironment('TRANSLATE_URL', defaultValue: ''); // 전체 URL을 넣으면 우선 사용
  static const String translateRegion =
      String.fromEnvironment('TRANSLATE_REGION', defaultValue: 'us-central1'); // URL 미지정 시 사용할 리전
}


