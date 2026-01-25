import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/providers/weekly_review_provider.dart';
import 'package:provider/provider.dart';

class WeeklyReviewPopup extends StatelessWidget {
  final VoidCallback onDismiss;

  const WeeklyReviewPopup({
    super.key,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<WeeklyReviewProvider>();

    final progress = provider.progressPercent;
    final targetReached = provider.targetReached;

    return WillPopScope(
      onWillPop: () async => false, // Prevent back button dismiss
      child: AlertDialog(
        backgroundColor: const Color(0xFF1A1F28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryOrange, width: 2),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                targetReached
                    ? l10n.weeklyTargetAchieved
                    : l10n.weeklyReviewTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Progress bar
              _buildProgressBar(progress, targetReached),
              const SizedBox(height: 16),

              // Stats
              Text(
                '${provider.weeklyTotal} / ${provider.weeklyTarget}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFB347),
                ),
              ),
              const SizedBox(height: 8),

              // Percentage
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),

              // Bonus notice if achieved
              if (targetReached) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        color: AppColors.primaryOrange,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.weeklyBonusAwarded(provider.weeklyBonus),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Goal adjustment options
              ..._buildGoalOptions(context, provider, targetReached, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, bool targetReached) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(6),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: targetReached ? AppColors.primaryOrange : Colors.grey[600],
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGoalOptions(
    BuildContext context,
    WeeklyReviewProvider provider,
    bool targetReached,
    AppLocalizations l10n,
  ) {
    final currentGoal = provider.weeklyTarget ~/ 5; // Approximate daily goal

    if (targetReached) {
      // Show increase options (maintain, +10%, +20%)
      return [
        _buildOptionCard(
          context: context,
          title: l10n.weeklyGoalMaintain,
          adjustment: GoalAdjustment.maintain,
          monthsToGoal: provider.calculateMonthsToGoal(currentGoal),
          icon: Icons.block,
          onTap: () => _selectOption(context, GoalAdjustment.maintain),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          context: context,
          title: l10n.weeklyGoalIncrease10,
          adjustment: GoalAdjustment.increase10,
          monthsToGoal: provider.calculateMonthsToGoal(
            provider.calculateAdjustedGoal(currentGoal, GoalAdjustment.increase10),
          ),
          icon: Icons.trending_up,
          onTap: () => _selectOption(context, GoalAdjustment.increase10),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          context: context,
          title: l10n.weeklyGoalIncrease20,
          adjustment: GoalAdjustment.increase20,
          monthsToGoal: provider.calculateMonthsToGoal(
            provider.calculateAdjustedGoal(currentGoal, GoalAdjustment.increase20),
          ),
          icon: Icons.trending_up,
          onTap: () => _selectOption(context, GoalAdjustment.increase20),
        ),
      ];
    } else {
      // Show decrease options (-10%, -20%, -30%)
      return [
        _buildOptionCard(
          context: context,
          title: l10n.weeklyGoalDecrease10,
          adjustment: GoalAdjustment.decrease10,
          monthsToGoal: provider.calculateMonthsToGoal(
            provider.calculateAdjustedGoal(currentGoal, GoalAdjustment.decrease10),
          ),
          icon: Icons.trending_down,
          onTap: () => _selectOption(context, GoalAdjustment.decrease10),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          context: context,
          title: l10n.weeklyGoalDecrease20,
          adjustment: GoalAdjustment.decrease20,
          monthsToGoal: provider.calculateMonthsToGoal(
            provider.calculateAdjustedGoal(currentGoal, GoalAdjustment.decrease20),
          ),
          icon: Icons.trending_down,
          onTap: () => _selectOption(context, GoalAdjustment.decrease20),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          context: context,
          title: l10n.weeklyGoalDecrease30,
          adjustment: GoalAdjustment.decrease30,
          monthsToGoal: provider.calculateMonthsToGoal(
            provider.calculateAdjustedGoal(currentGoal, GoalAdjustment.decrease30),
          ),
          icon: Icons.trending_down,
          onTap: () => _selectOption(context, GoalAdjustment.decrease30),
        ),
      ];
    }
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required GoalAdjustment adjustment,
    required int monthsToGoal,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.monthlyToGoal(monthsToGoal),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _selectOption(BuildContext context, GoalAdjustment adjustment) async {
    final provider = context.read<WeeklyReviewProvider>();
    await provider.applyGoalAdjustment(adjustment);

    if (context.mounted) {
      Navigator.of(context).pop(); // Close dialog
      onDismiss();
    }
  }
}
