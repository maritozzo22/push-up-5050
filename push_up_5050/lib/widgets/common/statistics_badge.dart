import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';

/// Reusable statistics badge widget.
///
/// Displays a stat with an orange circle icon and label/value text.
/// Used across Home, WorkoutExecution, and Statistics screens.
///
/// Design specs from UI_MOCKUPS.md:
/// - Height: 40px
/// - Padding: 12px horizontal, 12px vertical
/// - Icon: Orange circle 12px with white border 2px
/// - Background: #2A2A2A (card background)
/// - Border radius: 20px (pill shape)
/// - Text: 18px Regular White
class StatisticsBadge extends StatelessWidget {
  /// Label for the statistic (e.g., "Push-up Oggi")
  final String label;

  /// Value to display (e.g., "15 / 50")
  final String value;

  const StatisticsBadge({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 40,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Orange circle icon with white border
          Container(
            constraints: const BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          const SizedBox(width: 8),
          // Label and value combined
          Text(
            '$label: $value',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
