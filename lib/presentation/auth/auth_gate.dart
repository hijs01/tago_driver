import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:provider/provider.dart';

import 'package:tago_driver/presentation/auth/login/login_view.dart';
import 'package:tago_driver/presentation/pages/main_view/main_view.dart';
import 'package:tago_driver/data/services/user_services.dart';
import 'package:tago_driver/data/models/user.dart';
import 'package:tago_driver/presentation/auth/login/login_view_model.dart';

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

            // 🔽🔽🔽 여기만 변경
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final loginVm = context.read<LoginViewModel>();

              if (loginVm.currentUser == null ||
                  loginVm.currentUser!.uid != appUser.uid) {
                loginVm.setCurrentUser(appUser);
              }
            });
            // 🔼🔼🔼

            return const MainView();
          },
        );
      },
    );
  }
}