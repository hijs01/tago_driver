import 'package:flutter/material.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

/// 모든 시스템 메시지 카드가 공통으로 사용하는 UI 틀
/// - 배경, 패딩, border, margin 등 공통 스타일 담당
/// - 내부에 들어가는 내용(child)은 각 notice 위젯이 정의
class SystemMessageTile extends StatelessWidget {
  final Widget child; // 실제 내용
  final IconData? icon; // 상단 표시 아이콘 (선택)
  final Color? iconColor;

  const SystemMessageTile({
    super.key,
    required this.child,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Row(
                children: [
                  Icon(icon, size: 18, color: iconColor ?? Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context)!.systemGuide,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            if (icon != null) const SizedBox(height: 8),
            child, // ✅ 개별 안내 내용 삽입
          ],
        ),
      ),
    );
  }
}
