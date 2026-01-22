import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/core/theme/app_theme.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/widgets/statistics/fire_effect.dart';

/// Calendar day cell widget for statistics screen.
///
/// Displays different states based on record and position:
/// - Completed (has pushups): orange circle with check + number
/// - In streak (2-7 consecutive days): fire effect animation
/// - Missed (null record, past date): gray with X
/// - Today (not completed): gray with orange border
/// - Future: gray with day number
class CalendarDayCell extends StatelessWidget {
  /// Day number in the program (1-30)
  final int day;

  /// Daily record for this day (null if missed)
  final DailyRecord? record;

  /// Whether this cell represents today
  final bool isToday;

  /// Whether this day is in the future
  final bool isFuture;

  /// Whether this day is part of a consecutive streak
  final bool isInStreak;

  /// Length of the streak this day is part of
  final int streakLength;

  const CalendarDayCell({
    super.key,
    required this.day,
    required this.record,
    required this.isToday,
    this.isFuture = false,
    this.isInStreak = false,
    this.streakLength = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Completed day (has at least 1 pushup)
    if (record != null && record!.totalPushups > 0) {
      return _buildCompletedCell();
    }

    // Future day
    if (isFuture) {
      return _buildFutureCell();
    }

    // Today (not completed yet)
    if (isToday) {
      return _buildTodayCell();
    }

    // Missed day (no record)
    return _buildMissedCell();
  }

  /// Completed day cell - orange with check + number
  /// Shows fire effect if part of a streak (2-7 consecutive days)
  Widget _buildCompletedCell() {
    final shouldShowFire = isInStreak && streakLength >= 2 && streakLength <= 7;

    final content = Container(
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        shape: BoxShape.circle,
        border: isToday
            ? Border.all(color: AppColors.primaryOrange, width: 3)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Check icon in background/subtle
          Positioned(
            top: 4,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(
                Icons.check,
                color: Colors.white.withOpacity(0.3),
                size: 32,
              ),
            ),
          ),
          // Pushup number in center
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${record!.totalPushups}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (record!.totalPushups >= 50)
                Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                )
              else
                Text(
                  'pushup${record!.totalPushups == 1 ? '' : 's'}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 8,
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    // Apply fire effect for streaks of 2-7 consecutive days
    if (shouldShowFire) {
      return FireEffect(isActive: true, child: content);
    }
    return content;
  }

  /// Today cell (not completed) - gray with orange border
  Widget _buildTodayCell() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryOrange, width: 2),
      ),
      child: Center(
        child: Text(
          '$day',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Missed day cell - gray background with red day number and X
  /// Shows:
  /// - Day number in red (bold, center)
  /// - Small red X icon in top right corner
  Widget _buildMissedCell() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Day number in red (centered)
          Text(
            '$day',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.red.shade400,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Small red X in top right corner
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Future day cell - gray with day number
  Widget _buildFutureCell() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$day',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary.withOpacity(0.3),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
