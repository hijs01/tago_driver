import 'package:flutter/material.dart';

class TagoBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TagoBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedFontSize: 13,
      unselectedFontSize: 12,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          activeIcon: Icon(Icons.home_filled),
          label: "홈",
        ),  BottomNavigationBarItem(
          icon: Icon(Icons.travel_explore_outlined),
          activeIcon: Icon(Icons.travel_explore),
          label: "여정",
        ),  BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat),
          label: "채팅",
        ),  BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: "설정",
        ),
      ],
    );
  }
}
