import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/providers/goals_provider.dart';
import 'package:push_up_5050/widgets/design_system/app_background.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';
import 'package:push_up_5050/widgets/design_system/orange_circle_icon_button.dart';
import 'package:push_up_5050/widgets/statistics/calorie_card.dart';
import 'package:push_up_5050/widgets/statistics/monthly_calendar.dart';
import 'package:push_up_5050/widgets/statistics/total_pushups_card.dart';
import 'package:push_up_5050/widgets/statistics/weekly_chart_painter.dart';

/// Statistics Screen - Redesigned with dark glass + orange glow style.
///
/// Layout:
/// - AppBackground (gradient)
/// - SafeArea
/// - SingleChildScrollView
/// - Padding(22h)
/// - Column:
///   - Row (back arrow + "STATISTICHE GLOBALI")
///   - Row (2 cards): TotalPushupsCard + CalorieCard
///   - WeeklyChartCard (area chart)
///   - Row (3 mini-cards): Streak, Daily Avg, Best Day
///   - MonthlyCalendar
///
/// Design System:
/// - Background: Radial gradient dark
/// - Cards: Frosted glass with blur
/// - Accent: Orange gradient #FFB347 → #FF5F1F
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    // Load stats on init after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserStatsProvider>().loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Consumer<GoalsProvider>(
                  builder: (context, goals, child) {
                    return Consumer<UserStatsProvider>(
                      builder: (context, stats, child) {
                        if (stats.isLoading) {
                          return _buildLoadingState();
                        }
                        return _buildContent(stats, goals);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7A18)),
        ),
      ),
    );
  }

  Widget _buildContent(UserStatsProvider stats, GoalsProvider goals) {
    final total = stats.totalPushupsAllTime;
    final dailyGoal = goals.dailyGoal.target;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Header Row: Back arrow + Title
        Row(
          children: [
            OrangeCircleIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 16),
            const Text(
              'STATISTICHE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Top Row: Total Pushups + Calories
        Row(
          children: [
            Expanded(
              child: TotalPushupsCard(total: total, goal: dailyGoal),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CalorieCard.fromPushups(totalPushups: total),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Weekly Progress Chart
        WeeklyChartCard(
          weeklySeries: stats.weekSeries,
          weekTotal: stats.weekTotal,
          weeklyTarget: goals.weeklyTarget,
        ),

        const SizedBox(height: 16),

        // Mini Stats Row: Streak, Daily Avg, Best Day, Points
        Row(
          children: [
            Expanded(
              child: _MiniStatCard(
                label: 'Streak',
                value: stats.currentStreak.toString(),
                icon: Icons.calendar_today_rounded,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MiniStatCard(
                label: 'Media',
                value: _calculateDailyAvg(stats).toString(),
                icon: Icons.trending_up_rounded,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MiniStatCard(
                label: 'Record',
                value: stats.daysCompleted.toString(),
                icon: Icons.emoji_events_rounded,
                subtitle: 'giorni',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MiniStatCard(
                label: 'Punti',
                value: stats.totalPoints.toString(),
                icon: Icons.stars_rounded,
                subtitle: 'totale',
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Monthly Calendar
        MonthlyCalendar(
          month: DateTime.now(),
          completedDays: stats.monthlyCompletedDays,
          missedDays: stats.monthlyMissedDays,
          blockedDays: stats.monthlyBlockedDays,
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  /// Calculate daily average from total and days completed.
  /// TODO: Implement proper daily average calculation.
  int _calculateDailyAvg(UserStatsProvider stats) {
    if (stats.daysCompleted == 0) return 0;
    return (stats.totalPushupsAllTime / stats.daysCompleted).round();
  }
}

/// Mini stat card for the 3-column stats row.
class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String? subtitle;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return FrostCard(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: const Color(0xFFFF7A18),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: Colors.white.withOpacity(0.60),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.50),
              ),
            ),
        ],
      ),
    );
  }
}
