import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/goal.dart';
import 'package:push_up_5050/providers/goals_provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/widgets/design_system/app_background.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';
import 'package:push_up_5050/widgets/design_system/mini_stat.dart';
import 'package:push_up_5050/widgets/design_system/start_button_circle.dart';
import 'package:push_up_5050/widgets/goals/goal_card.dart';

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
  @override
  void initState() {
    super.initState();
    // Load stats on init after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserStatsProvider>().loadStats();
      context.read<GoalsProvider>().loadGoals();
    });
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
        StartButtonCircle(
          onTap: widget.onStartWorkout ?? () {},
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
        const SizedBox(height: 16),
        // Mini Stats Row
        Row(
          children: [
            Expanded(
              child: FrostCard(
                height: 120,
                child: MiniStat(
                  label: 'SETTIMANA',
                  value: '${stats.weekTotal}',
                  showBar: true,
                  barValue: stats.weekProgress,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Consumer<GoalsProvider>(
                builder: (context, goals, child) {
                  return FrostCard(
                    height: 120,
                    child: MiniStat(
                      label: 'OBIETTIVO',
                      value: '${goals.dailyGoal.target}',
                    ),
                  );
                },
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
