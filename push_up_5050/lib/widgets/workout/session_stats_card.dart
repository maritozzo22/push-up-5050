import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/core/utils/calculator.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';

/// Session stats card widget for workout screen.
///
/// Displays live multipliers and points during workout:
/// - Day streak multiplier (1.0x → 2.0x)
/// - Session series multiplier (exponential based on pushups and series)
/// - Points earned in current session
///
/// Uses glassmorphism design with orange accents.
class SessionStatsCard extends StatelessWidget {
  /// Current streak of consecutive days
  final int consecutiveDays;

  /// Number of series completed in current session
  final int completedSeries;

  /// Total pushups in current session (for new exponential formula)
  final int? totalPushups;

  /// Points earned so far in the session (optional, for future use)
  final int? sessionPoints;

  const SessionStatsCard({
    super.key,
    required this.consecutiveDays,
    required this.completedSeries,
    this.totalPushups,
    this.sessionPoints,
  });

  @override
  Widget build(BuildContext context) {
    final dayMultiplier = Calculator.getDayStreakMultiplier(consecutiveDays);

    // Use new exponential formula if totalPushups is provided, otherwise fall back to old
    final seriesMultiplier = totalPushups != null
        ? Calculator.calculateSessionMultiplier(
            totalPushups: totalPushups!,
            seriesCompleted: completedSeries,
          )
        : Calculator.getSessionSeriesMultiplier(completedSeries);

    // Debug logging to track multiplier calculation
    if (kDebugMode) {
      debugPrint('SessionStatsCard: consecutiveDays=$consecutiveDays, dayMultiplier=$dayMultiplier');
      debugPrint('SessionStatsCard: completedSeries=$completedSeries, totalPushups=$totalPushups, seriesMultiplier=$seriesMultiplier');
    }

    return FrostCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF7A18).withOpacity(0.3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bolt,
                  size: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Moltiplicatori Attivi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Multipliers row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MultiplierItem(
                label: 'Giorni',
                value: dayMultiplier,
                subtitle: 'Striscia: $consecutiveDays',
              ),
              _MultiplierItem(
                label: 'Serie',
                value: seriesMultiplier,
                subtitle: 'Completate: $completedSeries',
              ),
            ],
          ),

          // Optional session points
          if (sessionPoints != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0x33FFFFFF)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Punti Sessione',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  sessionPoints.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Individual multiplier item widget.
class _MultiplierItem extends StatelessWidget {
  final String label;
  final double value;
  final String subtitle;

  const _MultiplierItem({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryOrange.withOpacity(0.2),
                AppColors.deepOrangeRed.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primaryOrange.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Text(
            '${value.toStringAsFixed(2)}x',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryOrange,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
