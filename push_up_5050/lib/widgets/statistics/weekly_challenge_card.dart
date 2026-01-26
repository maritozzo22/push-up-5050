import 'package:flutter/material.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';

/// Weekly Challenge Card - displays weekly challenge progress.
///
/// Shows:
/// - Trophy icon and title
/// - Challenge target (daily goal x 7)
/// - Progress bar (orange when in progress, green when complete)
/// - Current progress / target display
/// - Completed badge and bonus text when finished
///
/// The weekly challenge has a higher target than the weekly goal
/// (7 days vs 5 workout days) and awards bonus points on completion.
class WeeklyChallengeCard extends StatelessWidget {
  /// Total push-ups completed this week.
  final int weekTotal;

  /// Daily goal target used to calculate challenge target (daily goal x 7).
  final int dailyGoal;

  /// Whether the challenge has been completed.
  final bool isCompleted;

  const WeeklyChallengeCard({
    super.key,
    required this.weekTotal,
    required this.dailyGoal,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final challengeTarget = dailyGoal * 7;
    final progress = (weekTotal / challengeTarget).clamp(0.0, 1.0);

    return FrostCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: Trophy icon + Title
          Row(
            children: [
              const Text(
                '🏆',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  loc.weeklyChallenge,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    loc.weeklyChallengeCompleted,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Target text
          Text(
            loc.weeklyChallengeTarget(challengeTarget.toString()),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.70),
            ),
          ),
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? const Color(0xFF4CAF50) : const Color(0xFFFF7A18),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),

          // Progress text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.weeklyChallengeProgress(
                  weekTotal.toString(),
                  challengeTarget.toString(),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (isCompleted)
                Text(
                  loc.weeklyChallengeBonus,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
