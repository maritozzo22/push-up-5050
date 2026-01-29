import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/core/constants/app_sizes.dart';
import 'package:push_up_5050/core/theme/app_theme.dart';
import 'package:push_up_5050/core/utils/calculator.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/haptic_intensity.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/screens/workout_summary/workout_summary_screen.dart';
import 'package:push_up_5050/services/app_settings_service.dart';
import 'package:push_up_5050/services/audio_service.dart';
import 'package:push_up_5050/services/haptic_feedback_service.dart';
import 'package:push_up_5050/widgets/design_system/app_background.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';
import 'package:push_up_5050/widgets/workout/countdown_circle.dart';
import 'package:push_up_5050/widgets/workout/goal_celebration.dart';
import 'package:push_up_5050/widgets/workout/recovery_ring_button.dart';
import 'package:push_up_5050/widgets/workout/session_stats_card.dart';

/// Workout execution screen - main workout interface.
///
/// Displays:
/// - Title "Allenamento in Corso"
/// - Statistics badges with real-time data
/// - Interactive countdown circle for counting reps
/// - Recovery timer between series
/// - PAUSA and TERMINA buttons
/// - No bottom navigation (full workout screen)
///
/// Design specs from UI_MOCKUPS.md.
class WorkoutExecutionScreen extends StatefulWidget {
  const WorkoutExecutionScreen({super.key});

  @override
  State<WorkoutExecutionScreen> createState() => _WorkoutExecutionScreenState();
}

class _WorkoutExecutionScreenState extends State<WorkoutExecutionScreen> {
  Timer? _recoveryTimer;
  bool _showCelebration = false;
  bool _isCompleting = false;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  @override
  void dispose() {
    _recoveryTimer?.cancel();
    super.dispose();
  }

  void _startRecoveryTimer(ActiveWorkoutProvider provider, BuildContext context) {
    _recoveryTimer?.cancel();
    _recoveryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final complete = provider.tickRecovery();
      if (complete) {
        timer.cancel();

        // Play beep sound when recovery ends (if enabled)
        final settings = context.read<AppSettingsService>();
        final audio = context.read<AudioService>();
        if (settings.soundsEnabled && settings.beepEnabled) {
          audio.playBeep();
        }

        // Auto-advance to next series when recovery is complete
        provider.advanceToNextSeries();
      }
    });
  }

  void _handleCountRep(ActiveWorkoutProvider provider, BuildContext context) {
    final wasGoalNotReached = provider.session?.goalReached == false;

    provider.countRep();

    // Play push-up sound
    final settings = context.read<AppSettingsService>();
    final audio = context.read<AudioService>();
    if (settings.soundsEnabled && settings.pushupSoundEnabled) {
      audio.playPushupDone();
    }

    // Trigger haptic feedback based on intensity setting
    final haptic = context.read<HapticFeedbackService>();

    switch (settings.hapticIntensity) {
      case HapticIntensity.off:
        // No haptic feedback
        break;
      case HapticIntensity.light:
        haptic.lightImpact();
        break;
      case HapticIntensity.medium:
        haptic.mediumImpact();
        break;
    }

    final session = provider.session;
    if (session != null && session.isSeriesComplete()) {
      // Check if goal was just reached
      if (wasGoalNotReached && session.goalPushups != null) {
        // Temporarily advance to check goal status
        session.advanceToNextSeries();
        if (session.goalReached && mounted) {
          // Play goal achieved sound
          final audio = context.read<AudioService>();
          if (settings.soundsEnabled && settings.goalSoundEnabled) {
            audio.playGoalAchieved();
          }
          setState(() => _showCelebration = true);
        }
      }

      // Check if goal reached - if so, skip recovery and end workout
      // This ensures series finishes before checking goal
      if (session.goalReached) {
        _handleGoalCompletion(provider, context);
        return;
      }

      // Start recovery when series is complete
      provider.startRecovery();
      _startRecoveryTimer(provider, context);
    }
  }

  Future<void> _handleEndWorkout(ActiveWorkoutProvider provider) async {
    final session = provider.session;
    if (session == null) return;

    // 1. Capture data BEFORE endWorkout() (session becomes null after)
    final totalReps = session.totalReps;
    final totalKcal = session.totalKcal;
    final seriesCompleted = session.currentSeries - 1; // -1 because currentSeries is the next one
    final seriesStart = session.startingSeries;
    final duration = DateTime.now().difference(session.startTime);
    final goalReached = session.goalReached;

    // 2. End the workout (must happen before refreshStats)
    await provider.endWorkout();

    // 3. Refresh user stats to get UPDATED streak
    final userStats = context.read<UserStatsProvider>();
    await userStats.refreshStats();

    // 4. FIX #4: If no push-ups done, don't assign points - just return to home
    if (totalReps == 0) {
      if (mounted) {
        Navigator.pop(context);
      }
      return;
    }

    // 5. FIX #5: Calculate multiplier with UPDATED streak (after refreshStats)
    final updatedStreak = userStats.currentStreak;
    final multiplier = Calculator.getMultiplier(updatedStreak);
    final basePoints = Calculator.calculateBasePoints(
      seriesCompleted: seriesCompleted,
      totalPushups: totalReps,
      consecutiveDays: updatedStreak,
    );
    final pointsEarned = Calculator.calculatePoints(
      seriesCompleted: seriesCompleted,
      totalPushups: totalReps,
      consecutiveDays: updatedStreak,
      goalReached: goalReached,
    );

    // 6. Check for newly unlocked achievements
    final achievementsProvider = context.read<AchievementsProvider>();

    // Calculate monthly pushups (current month total)
    final now = DateTime.now();
    int monthlyPushups = totalReps; // Start with current session
    // Note: A more accurate calculation would require loading all records for current month

    // Estimate total points from history (simplified: ~2 points per pushup on average)
    final estimatedTotalPoints = ((userStats.totalPushupsAllTime + totalReps) * 2).floor();

    final statsMap = {
      'totalPushups': userStats.todayPushups + totalReps,
      'totalPushupsAllTime': userStats.totalPushupsAllTime + totalReps,
      'currentStreak': updatedStreak,
      'maxRepsInOneSeries': seriesCompleted > 0 ? seriesCompleted : 0,
      'maxPushupsInOneDay': userStats.todayPushups + totalReps,
      'daysCompleted': userStats.daysCompleted,
      // New data for new achievements
      'monthlyPushups': monthlyPushups,
      'maxConsecutiveSeries': seriesCompleted,
      'totalPoints': estimatedTotalPoints + pointsEarned,
    };
    final newlyUnlocked = achievementsProvider.checkUnlocks(statsMap);

    // Calculate achievement points from newly unlocked achievements
    final achievementPoints = newlyUnlocked.fold<int>(
      0,
      (sum, achievement) => sum + achievement.points,
    );

    // 7. Recalculate basePoints and pointsEarned WITH achievement points
    final basePointsWithAchievement = Calculator.calculateBasePoints(
      seriesCompleted: seriesCompleted,
      totalPushups: totalReps,
      consecutiveDays: updatedStreak,
      achievementPoints: achievementPoints,
    );
    final pointsEarnedWithAchievement = Calculator.calculatePoints(
      seriesCompleted: seriesCompleted,
      totalPushups: totalReps,
      consecutiveDays: updatedStreak,
      achievementPoints: achievementPoints,
    );

    // 8. Calculate session multipliers (use new exponential formula)
    final sessionSeriesMultiplier = Calculator.calculateSessionMultiplier(
      totalPushups: totalReps,
      seriesCompleted: seriesCompleted,
    );
    final achievementMultiplier = Calculator.getAchievementMultiplier(newlyUnlocked.length);

    // 9. Navigate to summary screen
    if (mounted) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutSummaryScreen(
            seriesStart: seriesStart,
            seriesCompleted: seriesCompleted,
            totalReps: totalReps,
            totalKcal: totalKcal,
            totalDuration: duration,
            pointsEarned: pointsEarnedWithAchievement,
            basePoints: basePointsWithAchievement,
            streakMultiplier: multiplier,
            newlyUnlockedAchievements: newlyUnlocked,
            sessionSeriesMultiplier: sessionSeriesMultiplier,
            achievementMultiplier: achievementMultiplier,
            achievementPoints: achievementPoints,
          ),
        ),
      );
    }
  }

  Future<void> _handleGoalCompletion(
    ActiveWorkoutProvider provider,
    BuildContext context,
  ) async {
    // Prevent double-completion
    if (_isCompleting) return;
    _isCompleting = true;

    // End workout (saves session, clears active session)
    await provider.endWorkout();

    // Play goal achievement sound
    final settings = context.read<AppSettingsService>();
    final audio = context.read<AudioService>();
    if (settings.soundsEnabled && settings.goalSoundEnabled) {
      audio.playGoalAchieved();
    }

    // Navigate back to Home (not results screen)
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // AppBackground with dark gradient + orange glow
        const AppBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.l),
                  child: Consumer<ActiveWorkoutProvider>(
                    builder: (context, provider, child) {
                      final session = provider.session;

                      // Show placeholder if no active session
                      if (session == null) {
                        return _buildPlaceholder();
                      }

                      // Check if we need to start recovery timer
                      if (provider.isRecovery && _recoveryTimer?.isActive != true) {
                        _startRecoveryTimer(provider, context);
                      }

                      return _buildWorkoutScreen(provider, session);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        // Goal celebration overlay
        if (_showCelebration)
          GoalCelebrationWidget(
            message: '${context.read<ActiveWorkoutProvider>()?.session?.totalReps ?? 0} Push-up Completati!',
            onComplete: () => setState(() => _showCelebration = false),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      children: [
        const SizedBox(height: AppSizes.xxl),
        Text(
          _l10n.noActiveWorkout,
          style: AppTextStyles.headlineLarge,
        ),
        const SizedBox(height: AppSizes.xl),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: Colors.white,
          ),
          child: Text(_l10n.backToHome),
        ),
      ],
    );
  }

  Widget _buildWorkoutScreen(ActiveWorkoutProvider provider, dynamic session) {
    final isRecovery = provider.isRecovery;
    final recoverySeconds = provider.recoverySecondsRemaining;
    final totalReps = session.totalReps as int;
    final totalKcal = session.totalKcal as double;
    final currentSeries = session.currentSeries as int;
    final remainingReps = session.remainingReps as int;
    final completedSeries = (currentSeries - (session.startingSeries as int)).toInt();

    // Get user stats for multipliers
    final userStats = context.read<UserStatsProvider>();
    final consecutiveDays = userStats.currentStreak;

    return Column(
      children: [
        const SizedBox(height: AppSizes.xxl),

        // Session Stats Card with multipliers (replaces title)
        SessionStatsCard(
          consecutiveDays: consecutiveDays,
          completedSeries: completedSeries,
          totalPushups: totalReps,
          sessionPoints: provider.sessionPoints,
        ),
        const SizedBox(height: AppSizes.m),

        // Statistics Badges Row
        Wrap(
          spacing: AppSizes.m,
          alignment: WrapAlignment.center,
          children: [
            _StatisticsBadge(
              label: _l10n.totalRepsLabel,
              value: totalReps.toString(),
            ),
            _StatisticsBadge(
              label: _l10n.kcalLabel,
              value: totalKcal.toStringAsFixed(1),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.l),

        // Countdown Circle OR Recovery Ring Button
        if (!isRecovery)
          CountdownCircle(
            number: remainingReps,
            subtitle: _l10n.touchToCount,
            onTap: () => _handleCountRep(provider, context),
          )
        else
          RecoveryRingButton(
            totalSeconds: session.restTime,
            remainingSeconds: recoverySeconds,
            currentSeries: currentSeries,
          ),
        const SizedBox(height: AppSizes.l),

        // Level Badge with glass effect
        FrostCard(
          height: 48,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 20,
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
                  size: 12,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _l10n.workoutSeriesBadge(currentSeries),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.xl),

        // Control Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _handleEndWorkout(provider),
              child: Container(
                width: AppSizes.controlButtonWidth * 1.5,
                height: AppSizes.controlButtonHeight,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF7A18).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _l10n.end,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xxl),
      ],
    );
  }
}

/// Statistics badge widget for workout screen with glass effect.
class _StatisticsBadge extends StatelessWidget {
  final String label;
  final String value;
  final bool showOrange;

  const _StatisticsBadge({
    required this.label,
    required this.value,
    this.showOrange = false,
  });

  @override
  Widget build(BuildContext context) {
    return FrostCard(
      height: 44,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
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
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // FittedBox prevents text overflow
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$label $value',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: showOrange ? AppColors.primaryOrange : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
