import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:provider/provider.dart';

import 'package:tago_driver/presentation/auth/login/login_view.dart';
import 'package:tago_driver/presentation/pages/main_view/main_view.dart';
import 'package:tago_driver/data/services/user_services.dart';
import 'package:tago_driver/data/models/user.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';
import 'package:tago_driver/data/services/notification_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fb.User?>(
      stream: fb.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final fbUser = snap.data;
        if (fbUser == null) {
          return const LoginScreen();
        }

        return FutureBuilder<AppUser?>(
          future: UserServices().getUser(fbUser.uid),
          builder: (context, userSnap) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(child: CircularProgressIndicator()),
              );
            }

            AppUser appUser = userSnap.data ??
                AppUser(
                  uid: fbUser.uid,
                  email: fbUser.email ?? '',
                  name: fbUser.displayName ?? '',
                  role: 'driver',
                );

            if (userSnap.data == null) {
              UserServices().saveUser(appUser);
            }

            // 🔽🔽🔽 자동 로그인 시 currentUser 설정 & FCM 토큰 저장
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final loginVm = context.read<LoginViewModel>();

              if (loginVm.currentUser == null ||
                  loginVm.currentUser!.uid != appUser.uid) {
                loginVm.setCurrentUser(appUser);
                
                // 자동 로그인 시에도 FCM 토큰 저장
                print('🔄 자동 로그인 감지 - FCM 토큰 저장 시작');
                _saveFCMTokenOnAutoLogin(appUser.uid);
              }
            });
            // 🔼🔼🔼

            return const MainView();
          },
        );
      },
    );
  }

  /// 자동 로그인 시 FCM 토큰 저장
  Future<void> _saveFCMTokenOnAutoLogin(String userId) async {
    try {
      final notificationService = NotificationService();
      final token = await notificationService.getFCMToken(userId);
      
      if (token != null) {
        notificationService.listenToTokenRefresh(userId);
        print('✅ 자동 로그인: FCM 토큰 저장 완료');
      } else {
        print('⚠️ 자동 로그인: FCM 토큰이 null');
      }
    } catch (e, stackTrace) {
      print('❌ 자동 로그인: FCM 토큰 저장 실패: $e');
      print('스택 트레이스: $stackTrace');
    }
  }
}