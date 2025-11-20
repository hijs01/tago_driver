import 'package:flutter/material.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

/// 여정 통계 정보를 표시하는 컴포넌트
/// - 승객 수 (peopleCount)
/// - 총 가방 수 (luggageCount)
class TripInfoSection extends StatelessWidget {
  // Firebase에서 가져온 여정 데이터
  final Map<String, dynamic>? rideData;

  const TripInfoSection({
    super.key,
    required this.rideData,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // 여정 데이터에서 승객 수와 가방 수 추출 (없으면 0)
    final peopleCount = rideData?['peopleCount'] as int? ?? 0;
    final luggageCount = rideData?['luggageCount'] as int? ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 승객 수 표시 행
            Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  color: Color(0xFF4CAF50),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.passengerCount,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                // 실제 승객 수 표시
                Text(
                  l10n.passengers(peopleCount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 가방 수 표시 행
            Row(
              children: [
                const Icon(
                  Icons.luggage_outlined,
                  color: Color(0xFF4CAF50),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.totalBags,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                // 실제 가방 수 표시
                Text(
                  l10n.bags(luggageCount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
