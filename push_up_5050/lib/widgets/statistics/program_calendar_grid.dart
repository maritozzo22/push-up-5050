import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_sizes.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/widgets/statistics/calendar_connector_line.dart';
import 'package:push_up_5050/widgets/statistics/calendar_day_cell.dart';

/// Program calendar grid widget for statistics screen.
///
/// Displays a 5x6 grid (30 days) showing the user's workout progress
/// from program start date. Completed days are connected with orange lines.
/// Consecutive streaks of 2-7 days show fire animation.
class ProgramCalendarGrid extends StatelessWidget {
  /// List of 30 daily records (null for missed/future days)
  final List<DailyRecord?> records;

  /// Program start date
  final DateTime? programStartDate;

  /// Callback when a day is tapped
  final ValueChanged<int>? onDayTap;

  const ProgramCalendarGrid({
    super.key,
    required this.records,
    this.programStartDate,
    this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(
        child: Text(
          'Nessun dato disponibile',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    // Determine today's index in the program
    final int todayIndex = _getTodayIndex();

    // Calculate grid dimensions dynamically
    const int columns = 5;
    const int rows = 6;
    const double spacing = AppSizes.s;

    // Get available width (constrained by maxContentWidth from parent)
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = AppSizes.l * 2; // From StatisticsScreen
    final availableWidth = screenWidth.clamp(0.0, AppSizes.maxContentWidth) - horizontalPadding;

    // Calculate cell size (square cells)
    final cellSize = (availableWidth - (columns - 1) * spacing) / columns;

    // Calculate total grid height
    final gridHeight = (cellSize * rows) + ((rows - 1) * spacing);

    return SizedBox(
      height: gridHeight,
      child: Stack(
        children: [
          // Connector lines layer (behind cells)
          if (programStartDate != null)
            Positioned.fill(
              child: _buildConnectorLayer(cellSize),
            ),

          // Grid cells layer
          GridView.count(
            crossAxisCount: 5,
            mainAxisSpacing: AppSizes.s,
            crossAxisSpacing: AppSizes.s,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              30,
              (index) {
                final record = index < records.length ? records[index] : null;
                final isToday = index == todayIndex;
                final isFuture = _isFutureDay(index);

                // Calculate streak information for this day
                final streakInfo = _calculateStreakInfo(index);

                return GestureDetector(
                  onTap: onDayTap != null ? () => onDayTap!(index + 1) : null,
                  child: CalendarDayCell(
                    day: index + 1,
                    record: record,
                    isToday: isToday,
                    isFuture: isFuture,
                    isInStreak: streakInfo['isInStreak'] ?? false,
                    streakLength: streakInfo['streakLength'] ?? 0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build the connector lines layer
  Widget _buildConnectorLayer(double cellSize) {
    const columns = 5;
    const spacing = AppSizes.s;

    return Center(
      child: CalendarConnectorLine(
        records: records,
        columns: columns,
        cellSize: Size(cellSize, cellSize),
        spacing: spacing,
      ),
    );
  }

  /// Calculate streak information for a given day index
  /// Returns {'isInStreak': bool, 'streakLength': int}
  Map<String, dynamic> _calculateStreakInfo(int index) {
    // Day must have a record with pushups to be in a streak
    if (index >= records.length || records[index] == null || records[index]!.totalPushups == 0) {
      return {'isInStreak': false, 'streakLength': 0};
    }

    int streakLength = 1;

    // Count consecutive days BEFORE this day
    for (int i = index - 1; i >= 0; i--) {
      if (i < records.length && records[i] != null && records[i]!.totalPushups > 0) {
        streakLength++;
      } else {
        break;
      }
    }

    // Count consecutive days AFTER this day
    for (int i = index + 1; i < records.length; i++) {
      if (records[i] != null && records[i]!.totalPushups > 0) {
        streakLength++;
      } else {
        break;
      }
    }

    // In a streak if at least 2 consecutive days
    final isInStreak = streakLength >= 2;

    return {'isInStreak': isInStreak, 'streakLength': streakLength};
  }

  /// Get the index of today in the program
  int _getTodayIndex() {
    if (programStartDate == null) return -1;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(
      programStartDate!.year,
      programStartDate!.month,
      programStartDate!.day,
    );

    final difference = today.difference(start).inDays;

    if (difference < 0 || difference >= 30) return -1;
    return difference;
  }

  /// Check if a given day index is in the future
  bool _isFutureDay(int index) {
    if (programStartDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(
      programStartDate!.year,
      programStartDate!.month,
      programStartDate!.day,
    );

    final dayDate = start.add(Duration(days: index));
    return dayDate.isAfter(today);
  }
}
