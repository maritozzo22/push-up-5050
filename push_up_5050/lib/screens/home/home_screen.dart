import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/goal.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/providers/goals_provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/providers/weekly_review_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/services/notification_scheduler.dart';
import 'package:push_up_5050/widgets/design_system/app_background.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';
import 'package:push_up_5050/widgets/design_system/mini_stat.dart';
import 'package:push_up_5050/widgets/design_system/start_button_circle.dart';
import 'package:push_up_5050/widgets/goals/goal_card.dart';
import 'package:push_up_5050/widgets/weekly/weekly_review_popup.dart';

/// Home screen - entry point for the app with new dark glass + orange glow design.
///
/// Displays:
/// - "PUSHUP 5050" title centered
/// - START button circle with glow animation
/// - Today's pushups card
/// - Mini stats cards (This Week, Goal)
///
/// Design specs from PLAN_REDESIGN.md.
class HomeScreen extends StatefulWidget {
  /// Callback when "START" button is tapped
  final VoidCallback? onStartWorkout;

  const HomeScreen({
    super.key,
    this.onStartWorkout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _weeklyReviewChecked = false;

  @override
  void initState() {
    super.initState();
    // Load stats on init after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final statsContext = context;
      if (statsContext.mounted) {
        await statsContext.read<UserStatsProvider>().loadStats();
        await statsContext.read<GoalsProvider>().loadGoals();

        // Schedule notifications after stats load
        await _scheduleNotificationsIfNeeded();

        // Check weekly review after stats loaded
        if (!_weeklyReviewChecked) {
          _weeklyReviewChecked = true;
          await _checkAndShowWeeklyReview(statsContext);
        }
      }
    });
  }

  /// Schedule smart notifications based on current state.
  ///
  /// Called on app start to evaluate and schedule:
  /// - Streak at risk notifications
  /// - Progress notifications
  /// - Weekly challenge notifications
  Future<void> _scheduleNotificationsIfNeeded() async {
    try {
      final scheduler = context.read<NotificationScheduler>();
      await scheduler.scheduleAllSmartNotifications(context);
    } catch (e) {
      debugPrint('HomeScreen: Failed to schedule notifications: $e');
    }
  }

  /// Check and show weekly review popup if conditions are met.
  ///
  /// Triggers when:
  /// - It's Sunday (end of week review)
  /// - Weekly target has been reached (early celebration)
  ///
  /// Only shows once per week (tracked by storage flag).
  Future<void> _checkAndShowWeeklyReview(BuildContext context) async {
    final storage = context.read<StorageService>();
    final stats = context.read<UserStatsProvider>();
    final goals = context.read<GoalsProvider>();
    final reviewProvider = context.read<WeeklyReviewProvider>();

    final now = DateTime.now();
    final weekNumber = storage.getWeekNumber(now);
    final isSunday = now.weekday == 7; // 7 = Sunday

    // Check if review already shown for this week
    if (await storage.hasWeeklyReviewBeenShown(weekNumber)) {
      return;
    }

    // Get weekly progress
    final weeklyTotal = stats.weekTotal;
    final weeklyTarget = goals.weeklyGoals.isNotEmpty
        ? goals.weeklyGoals.first.target
        : storage.getWeeklyGoal();
    final targetReached = weeklyTotal >= weeklyTarget;

    // Trigger if Sunday OR target reached early
    if (isSunday || targetReached) {
      // Load data into provider
      await reviewProvider.loadWeeklyData(weeklyTotal, weeklyTarget);

      // Award bonus if target reached and not yet awarded
      if (targetReached && !(await storage.hasWeeklyBonusBeenAwarded(weekNumber))) {
        await reviewProvider.awardWeeklyBonus(weekNumber);
      }

      // Show popup
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => ChangeNotifierProvider.value(
            value: reviewProvider,
            child: WeeklyReviewPopup(
              onDismiss: () {
                // Mark review as shown
                storage.markWeeklyReviewShown(weekNumber);
              },
            ),
          ),
        );
      }
    }
  }

  /// Build a small streak badge showing icon, label and value.
  Widget _buildStreakBadge({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          '$label: $value',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Consumer<UserStatsProvider>(
                builder: (context, stats, child) {
                  // Loading state
                  if (stats.isLoading) {
                    return _buildLoadingState();
                  }

                  // Normal state with data
                  return _buildNormalState(stats, l10n);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Loading state widget
  Widget _buildLoadingState() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB347)),
        ),
        SizedBox(height: 16),
        Text(
          'Caricamento...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Normal state widget with real stats
  Widget _buildNormalState(UserStatsProvider stats, AppLocalizations l10n) {
    return Column(
      children: [
        const Spacer(),
        // Title
        const Text(
          'PUSHUP 5050',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        // START Button
        Consumer2<UserStatsProvider, ActiveWorkoutProvider>(
          builder: (context, stats, workoutProvider, child) {
            // Check if today's goal is already complete
            final goalComplete = stats.todayPushups >= UserStatsProvider.dailyGoal;

            return StartButtonCircle(
              onTap: widget.onStartWorkout ?? () {},
              isDisabled: goalComplete,
              disabledMessage: 'Obiettivo completato!',
            );
          },
        ),
        const SizedBox(height: 24),
        // Today's Pushups Card
        FrostCard(
          height: 60,
          child: Row(
            children: [
              Text(
                'Oggi · ${stats.todayPushups} Push-up',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Streaks Row - Daily and Weekly streaks
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStreakBadge(
              icon: Icons.local_fire_department,
              label: 'Giorno',
              value: '${stats.currentStreak}',
              color: AppColors.primaryOrange,
            ),
            const SizedBox(width: 24),
            _buildStreakBadge(
              icon: Icons.calendar_today,
              label: 'Settimana',
              value: '${stats.weeklyStreak}',
              color: AppColors.primaryOrange,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Mini Stats Row - Punti totali e Progresso oggi
        Row(
          children: [
            Expanded(
              child: FrostCard(
                height: 120,
                child: MiniStat(
                  label: 'PUNTI',
                  value: '${stats.totalPoints}',
                  showBar: false,
                  icon: Icons.bolt,
                  iconColor: AppColors.primaryOrange,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FrostCard(
                height: 120,
                child: MiniStat(
                  label: 'OGGI',
                  value: '${stats.todayPushups}',
                  showBar: true,
                  barValue: (stats.todayPushups / UserStatsProvider.dailyGoal).clamp(0.0, 1.0),
                  subtitle: '/ ${UserStatsProvider.dailyGoal}',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Goals Section - Weekly and Monthly
        Consumer<GoalsProvider>(
          builder: (context, goals, child) {
            if (goals.isLoading) {
              return const SizedBox.shrink();
            }

            return Row(
              children: [
                Expanded(
                  child: GoalCard(
                    goal: goals.weeklyGoals.isNotEmpty
                        ? goals.weeklyGoals.first
                        : const Goal(
                            id: 'weekly_placeholder',
                            title: 'SETTIMANALE',
                            description: '350 Push-up a settimana',
                            type: GoalType.weekly,
                            target: 350,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GoalCard(
                    goal: goals.monthlyGoals.isNotEmpty
                        ? goals.monthlyGoals.first
                        : const Goal(
                            id: 'monthly_placeholder',
                            title: 'MENSILE',
                            description: '1500 Push-up al mese',
                            type: GoalType.monthly,
                            target: 1500,
                          ),
                ),
              ),
              ],
            );
          },
        ),
        const Spacer(),
      ],
    );
  }
}
