import 'package:flutter/material.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/common/bottomNavBar.dart';
import 'package:tago_driver/presentation/pages/chat/chatList/chat_list_view.dart';
import 'package:tago_driver/presentation/pages/home/home_view.dart';
import 'package:tago_driver/presentation/pages/status/status_view.dart';
import 'package:tago_driver/presentation/pages/setting/setting_view.dart';
import 'package:tago_driver/presentation/pages/home/home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  // 탭에서 보여줄 화면들.
  // 중요한 점: 이 각각은 Scaffold 없어야 함 (body만 있으면 됨)
  final List<Widget> _screens = const [
    HomeView(),
    StatusView(),
    ChatView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppScaffold(
      backgroundColor: Colors.black,

      // ✅ Body - 현재 탭의 콘텐츠
      // IndexedStack을 쓰면 탭 전환해도 state 유지돼 (스크롤 위치 등)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bodyPadding: EdgeInsets.all(0),

      // ✅ Bottom Navigation Bar - 한 군데에서만 관리
      bottomNavigationBar: TagoBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    )
    );
    
  }

}