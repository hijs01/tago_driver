import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/presentation/auth/signUp/signUp_view.dart';
import 'package:tago_driver/presentation/auth/signUp/signUp_view_model.dart';
import 'package:tago_driver/presentation/pages/chat/chatRoom/chat_room_view.dart';
// import 'package:tago_driver/presentation/auth/signUp/signUp_view.dart';
// import 'package:tago/presentation/auth/signUp/signUp_view_model.dart';
import 'package:tago_driver/presentation/pages/home/home_view.dart';
import 'package:tago_driver/presentation/auth/login/login_view.dart';
import 'package:tago_driver/presentation/pages/main_view/main_view.dart';
import 'package:tago_driver/presentation/rideRequest/ride_request_view_model.dart';
import 'firebase_options.dart'; // flutterfire configure로 자동 생성된 파일
import 'package:provider/provider.dart';
import 'package:tago_driver/presentation/auth/login/login_view.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/presentation/pages/main_view/main_view.dart';
import 'package:intl/date_symbol_data_local.dart';
void main() async {
  // Flutter 엔진이 위젯을 그리기 전에 비동기 코드(Firebase init 등) 실행 가능하게 함
  WidgetsFlutterBinding.ensureInitialized();

  //  Firebase Core 초기화 (firebase_options.dart에서 플랫폼별 설정을 불러옴)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await initializeDateFormatting('ko_KR', null);

  //  Provider를 앱 전역에 주입 (MVVM 구조 유지)
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => RideRequestViewModel()),
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

      // 🔹 초기 화면 (로그인)
      home: const LoginScreen(),

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
