import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/core/constants/app_sizes.dart';
import 'package:push_up_5050/core/theme/app_theme.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/services/app_settings_service.dart';
import 'package:push_up_5050/services/audio_service.dart';
import 'package:push_up_5050/widgets/design_system/app_background.dart';
import 'package:push_up_5050/widgets/workout/goal_celebration.dart';

/// Workout summary screen displayed after workout completion.
///
/// Shows:
/// - Completed series range
/// - Total push-ups
/// - Kcal burned
/// - Time spent
/// - Points earned with all multipliers (days, series, achievements)
/// - Newly unlocked achievements (if any) with confetti
///
/// Design specs from plan FASE 9.
class WorkoutSummaryScreen extends StatefulWidget {
  /// Starting series number (e.g., 1, 2, 5, 10)
  final int seriesStart;

  /// Number of series completed
  final int seriesCompleted;

  /// Total push-ups completed
  final int totalReps;

  /// Total kcal burned
  final double totalKcal;

  /// Total duration of the workout
  final Duration totalDuration;

  /// Points earned from this workout
  final int pointsEarned;

  /// Base points without multipliers
  final int basePoints;

  /// Streak multiplier applied to points (1.0, 1.2, 1.5, or 2.0)
  final double streakMultiplier;

  /// List of achievements unlocked during this workout
  final List<Achievement> newlyUnlockedAchievements;

  /// Session series multiplier (1.0 + completedSeries * 0.1)
  final double sessionSeriesMultiplier;

  /// Achievement multiplier (1.0 + achievementCount * 0.5)
  final double achievementMultiplier;

  /// Achievement points earned in this session (added to base points)
  final int achievementPoints;

  const WorkoutSummaryScreen({
    super.key,
    required this.seriesStart,
    required this.seriesCompleted,
    required this.totalReps,
    required this.totalKcal,
    required this.totalDuration,
    required this.pointsEarned,
    required this.basePoints,
    required this.streakMultiplier,
    required this.newlyUnlockedAchievements,
    this.sessionSeriesMultiplier = 1.0,
    this.achievementMultiplier = 1.0,
    this.achievementPoints = 0,
  });

  @override
  State<WorkoutSummaryScreen> createState() => _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState extends State<WorkoutSummaryScreen> {
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();
    // Play achievement sound and show celebration if achievements unlocked
    if (widget.newlyUnlockedAchievements.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final settings = context.read<AppSettingsService>();
        final audio = context.read<AudioService>();
        if (settings.soundsEnabled && settings.achievementSoundEnabled) {
          audio.playAchievementSound();
        }
        setState(() => _showCelebration = true);
      });
    }
  }

  AppLocalizations _l10n(BuildContext context) =>
      AppLocalizations.of(context)!;

  /// Format duration as HH:MM:SS
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n(context);
    final seriesEnd = widget.seriesStart + widget.seriesCompleted - 1;
    final hasAchievements = widget.newlyUnlockedAchievements.isNotEmpty;

    return Stack(
      children: [
        const AppBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.l),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSizes.xxxl),

                      // Title
                      Text(
                        l10n.workoutComplete,
                        style: AppTextStyles.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.xl),

                      // Main Statistics Card
                      _buildMainStatsCard(context, seriesEnd),
                      const SizedBox(height: AppSizes.xl),

                      // Points Card
                      _buildPointsCard(context),
                      const SizedBox(height: AppSizes.xl),

                      const SizedBox(height: AppSizes.xl),

                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.buttonHeight,
                        child: ElevatedButton(
                          onPressed: () => Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMedium,
                              ),
                            ),
                          ),
                          child: Text(
                            l10n.continueToHome,
                            style: AppTextStyles.buttonLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.xl),

                      // Achievements Section (if any) - AFTER Continue button
                      if (hasAchievements) ...[
                        _buildAchievementsSection(context),
                        const SizedBox(height: AppSizes.xl),
                      ],
                      const SizedBox(height: AppSizes.xl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Goal celebration overlay for achievements
        if (_showCelebration)
          GoalCelebrationWidget(
            message: widget.newlyUnlockedAchievements.length == 1
                ? 'Achievement Sbloccato!'
                : '${widget.newlyUnlockedAchievements.length} Achievement Sbloccati!',
            onComplete: () => setState(() => _showCelebration = false),
          ),
      ],
    );
  }

  Widget _buildMainStatsCard(BuildContext context, int seriesEnd) {
    final l10n = _l10n(context);
    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Column(
        children: [
          // Series Completed
          _StatRow(
            label: l10n.seriesCompletedLabel,
            value: l10n.seriesRange(widget.seriesStart, seriesEnd),
          ),
          const Divider(height: AppSizes.xl),
          // Total Push-ups
          _StatRow(
            label: l10n.pushupsTotal,
            value: '${widget.totalReps}',
          ),
          const Divider(height: AppSizes.xl),
          // Kcal Burned
          _StatRow(
            label: l10n.kcal,
            value: widget.totalKcal.toStringAsFixed(1),
          ),
          const Divider(height: AppSizes.xl),
          // Time Spent
          _StatRow(
            label: l10n.timeSpent,
            value: _formatDuration(widget.totalDuration),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard(BuildContext context) {
    final l10n = _l10n(context);

    // Determine if we have multiple active multipliers (> 1.0)
    final hasStreakMult = widget.streakMultiplier > 1.0;
    final hasSeriesMult = widget.sessionSeriesMultiplier > 1.0;
    // Achievement multiplier is no longer used - points added to base instead
    final activeMultiplierCount = (hasStreakMult ? 1 : 0) +
        (hasSeriesMult ? 1 : 0);

    // Use compact spacing when we have multiple active multipliers or achievements
    final useCompactSpacing = activeMultiplierCount >= 2 ||
        widget.newlyUnlockedAchievements.isNotEmpty;

    // Only show multipliers that are > 1.0
    final showStreak = hasStreakMult;
    final showSeries = hasSeriesMult;
    // Achievement multiplier no longer shown - points added to base instead

    return Container(
      padding: EdgeInsets.all(useCompactSpacing ? AppSizes.m : AppSizes.l),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: AppColors.primaryOrange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Base Points Row (without multipliers)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Punti Base',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: useCompactSpacing ? 14 : 16,
                ),
              ),
              Text(
                '${widget.basePoints}',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white70,
                  fontSize: useCompactSpacing ? 16 : 18,
                ),
              ),
            ],
          ),
          // Base Points Breakdown - Series, Pushups, Achievement
          if (widget.achievementPoints > 0) ...[
            SizedBox(height: useCompactSpacing ? AppSizes.xs : AppSizes.s),
            // Series points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Serie',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.7),
                      fontSize: useCompactSpacing ? 11 : 12,
                    ),
                  ),
                ),
                Text(
                  '${widget.seriesCompleted * 10}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white54,
                    fontSize: useCompactSpacing ? 12 : 13,
                  ),
                ),
              ],
            ),
            // Pushups points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Push-up',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.7),
                      fontSize: useCompactSpacing ? 11 : 12,
                    ),
                  ),
                ),
                Text(
                  '${widget.totalReps}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white54,
                    fontSize: useCompactSpacing ? 12 : 13,
                  ),
                ),
              ],
            ),
            // Achievement points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Achievement',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.7),
                      fontSize: useCompactSpacing ? 11 : 12,
                    ),
                  ),
                ),
                Text(
                  '+${widget.achievementPoints}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryOrange.withOpacity(0.8),
                    fontSize: useCompactSpacing ? 12 : 13,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: useCompactSpacing ? AppSizes.xs : AppSizes.m),
          const Divider(height: 1, color: Color(0x33FFFFFF)),
          SizedBox(height: useCompactSpacing ? AppSizes.xs : AppSizes.m),

          // Multipliers Section
          Text(
            'Moltiplicatori',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: useCompactSpacing ? 13 : 16,
            ),
          ),
          SizedBox(height: useCompactSpacing ? AppSizes.xs : AppSizes.s),

          // Day Streak Multiplier (only show if > 1.0)
          if (showStreak) ...[
            _MultiplierRow(
              label: 'Giorni consecutivi',
              value: widget.streakMultiplier,
              compact: useCompactSpacing,
            ),
            SizedBox(height: useCompactSpacing ? AppSizes.xs : AppSizes.s),
          ],

          // Session Series Multiplier (only show if > 1.0)
          if (showSeries) ...[
            _MultiplierRow(
              label: 'Serie completate',
              value: widget.sessionSeriesMultiplier,
              compact: useCompactSpacing,
            ),
            SizedBox(height: useCompactSpacing ? AppSizes.xs : AppSizes.s),
          ],

          // Achievement multiplier removed - points now added to base instead

          Divider(height: 1, color: const Color(0x33FFFFFF)),
          SizedBox(height: useCompactSpacing ? AppSizes.xs : AppSizes.m),

          // Total Points Row (with multipliers) - Large and Orange
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Punti Totali',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: useCompactSpacing ? 16 : 18,
                ),
              ),
              Text(
                '${widget.pointsEarned}',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: useCompactSpacing ? 24 : 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    final l10n = _l10n(context);
    return Column(
      children: [
        // Section Title
        Text(
          l10n.newlyUnlocked,
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: AppSizes.m),
        // Achievements Grid - 2 cards per row
        Wrap(
          spacing: AppSizes.s,
          runSpacing: AppSizes.s,
          alignment: WrapAlignment.center,
          children: widget.newlyUnlockedAchievements
              .map((achievement) => SizedBox(
                width: 160,
                child: _AchievementCard(achievement: achievement),
              ))
              .toList(),
        ),
      ],
    );
  }
}

/// Stat row widget for displaying label-value pairs.
class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Achievement card widget for displaying unlocked achievements.
class _AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 140,
        maxWidth: 160,
      ),
      padding: const EdgeInsets.all(AppSizes.m),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.primaryOrange,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Icon
          Text(
            achievement.icon,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(height: AppSizes.s),
          // Name
          Text(
            achievement.name,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSizes.xs),
          // Description
          Text(
            achievement.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSizes.s),
          // Points
          Text(
            '+${achievement.points} ${AppLocalizations.of(context)!.pointsLowercase}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Multiplier row widget for displaying label-value pairs.
class _MultiplierRow extends StatelessWidget {
  final String label;
  final double value;
  final bool compact;

  const _MultiplierRow({
    required this.label,
    required this.value,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: compact ? 13 : 16,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? AppSizes.xs : AppSizes.m,
            vertical: AppSizes.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Text(
            '${value.toStringAsFixed(1)}x',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.bold,
              fontSize: compact ? 13 : 16,
            ),
          ),
        ),
      ],
    );
  }
}
