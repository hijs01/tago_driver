import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFF10B981).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF10B981), // 에메랄드 그린
              unselectedItemColor: Colors.grey.shade600,
              currentIndex: currentIndex,
              onTap: onTap,
              selectedFontSize: 12,
              unselectedFontSize: 11,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                letterSpacing: -0.3,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home_outlined, size: 24),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home, size: 24),
                  ),
                  label: l10n.home,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.explore_outlined, size: 24),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.explore, size: 24),
                  ),
                  label: l10n.journey,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.chat_bubble_outline, size: 24),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.chat_bubble, size: 24),
                  ),
                  label: l10n.chat,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_outline, size: 24),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person, size: 24),
                  ),
                  label: l10n.settings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
