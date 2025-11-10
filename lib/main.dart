import 'dart:async'; // ✅ TimeoutException 사용을 위해
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/presentation/auth/signUp/signUp_view.dart';
import 'package:tago_driver/presentation/auth/signUp/signUp_view_model.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/chat_room_view.dart';
import 'package:tago_driver/presentation/pages/home/home_view.dart';
import 'package:tago_driver/presentation/auth/login/login_view.dart';
import 'package:tago_driver/presentation/pages/main_view/main_view.dart';
import 'package:tago_driver/presentation/pages/setting/settings_view_model.dart';
import 'package:tago_driver/presentation/rideRequest/ride_request_view_model.dart';
import 'package:tago_driver/presentation/pages/chat/chatList/chat_list_view_model.dart';
import 'package:tago_driver/presentation/auth/auth_gate.dart';
import 'firebase_options.dart'; // flutterfire configure로 자동 생성된 파일
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tago_driver/data/services/notification_service.dart';
import 'package:flutter/services.dart'; // ✅ MethodChannel 사용을 위해
import 'package:cloud_functions/cloud_functions.dart'; // ✅ Firebase Functions 사용을 위해

void main() async {
  // Flutter 엔진이 위젯을 그리기 전에 비동기 코드(Firebase init 등) 실행 가능하게 함
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Core 초기화 (firebase_options.dart에서 플랫폼별 설정을 불러옴)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('ko_KR', null);

  await NotificationService().initialize();

  // ✅ Firebase Functions에서 Maps API 키 가져오기 (앱 시작 전에 완료)
  bool apiKeySet = false;

  // ✅ 최대 3번 재시도
  for (int attempt = 1; attempt <= 3; attempt++) {
    try {
      debugPrint('🔍 Firebase Functions에서 Maps API 키 가져오기 시도 ($attempt/3)...');
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('getMapsApiKey');

      // ✅ 타임아웃 설정 (10초)
      final result = await callable.call().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Firebase Functions 호출 타임아웃');
        },
      );

      debugPrint('🔍 Firebase Functions 응답 타입: ${result.data.runtimeType}');
      debugPrint('🔍 Firebase Functions 응답: ${result.data}');

      final rawData = result.data;
      if (rawData is Map) {
        final data = Map<String, dynamic>.from(rawData.cast<String, dynamic>());
        final apiKey = data['apiKey'] as String?;

        debugPrint(
          '🔍 추출된 API 키: ${apiKey != null ? "${apiKey.substring(0, 10)}..." : "null"}',
        );

        if (apiKey != null && apiKey.isNotEmpty) {
          const platform = MethodChannel('com.tago/maps_api_key');
          try {
            await platform.invokeMethod('setApiKey', apiKey);
            apiKeySet = true;
            debugPrint(
              '✅ Google Maps API key 전달 완료 (Firebase Functions에서 가져옴)',
            );
            // ✅ iOS에서 GMSServices.provideAPIKey()가 완료될 시간을 확보
            // Google Maps SDK 초기화가 완료되도록 충분한 시간 대기
            await Future.delayed(const Duration(milliseconds: 1000));
            break; // 성공하면 재시도 루프 종료
          } catch (e) {
            debugPrint('❌ Google Maps API key 전달 실패: $e');
            if (attempt < 3) {
              debugPrint('🔄 재시도 중...');
              await Future.delayed(Duration(milliseconds: 500 * attempt));
              continue;
            }
          }
        } else {
          debugPrint(
            '⚠️ Firebase Functions에서 API 키를 가져올 수 없습니다. (apiKey가 null이거나 비어있음)',
          );
          if (attempt < 3) {
            debugPrint('🔄 재시도 중...');
            await Future.delayed(Duration(milliseconds: 500 * attempt));
            continue;
          }
        }
      } else {
        debugPrint(
          '⚠️ Firebase Functions 응답 형식이 예상과 다릅니다: ${rawData.runtimeType}',
        );
        if (attempt < 3) {
          debugPrint('🔄 재시도 중...');
          await Future.delayed(Duration(milliseconds: 500 * attempt));
          continue;
        }
      }
    } on FirebaseFunctionsException catch (e) {
      debugPrint(
        '❌ Firebase Functions 예외 발생 ($attempt/3): ${e.code} - ${e.message}',
      );
      debugPrint('❌ 상세 정보: ${e.details}');
      if (attempt < 3) {
        debugPrint('🔄 재시도 중...');
        await Future.delayed(Duration(milliseconds: 1000 * attempt));
        continue;
      }
    } on TimeoutException catch (e) {
      debugPrint('❌ 타임아웃 발생 ($attempt/3): $e');
      if (attempt < 3) {
        debugPrint('🔄 재시도 중...');
        await Future.delayed(Duration(milliseconds: 1000 * attempt));
        continue;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Firebase Functions에서 API 키 가져오기 실패 ($attempt/3): $e');
      debugPrint('❌ 스택 트레이스: $stackTrace');
      if (attempt < 3) {
        debugPrint('🔄 재시도 중...');
        await Future.delayed(Duration(milliseconds: 1000 * attempt));
        continue;
      }
    }
  }

  if (!apiKeySet) {
    debugPrint('⚠️ API 키가 설정되지 않았지만 앱을 계속 실행합니다.');
    debugPrint('⚠️ 지도 기능이 작동하지 않을 수 있습니다.');
    debugPrint(
      '⚠️ Firebase Functions 배포 상태를 확인해주세요: firebase deploy --only functions',
    );
  }

  // ✅ Status bar 설정을 앱 전체에 적용
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 투명하게
      statusBarIconBrightness: Brightness.light, // 아이콘 밝게
    ),
  );

  // Android에서 edge-to-edge 활성화
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Provider를 앱 전역에 주입 (MVVM 구조 유지)
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (_) => RideRequestViewModel()),
        ChangeNotifierProvider(create: (_) => ChatListViewModel()),
      ],
      child: const TagoDriverApp(),
    ),
  );
}

class TagoDriverApp extends StatelessWidget {
  const TagoDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TAGO Driver',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),

      // 🔹 초기 화면 (AuthGate: 자동 로그인 처리)
      home: const AuthGate(),

      // 🔹 화면 라우트 정의
      routes: {
        '/login': (_) => const LoginScreen(),
        '/main': (_) => const MainView(),
        '/home': (_) => const HomeView(),
        '/signup': (_) => const SignUpView(),
        '/chatRoom': (_) => const ChatRoomView(),
      },
    );
  }
}
