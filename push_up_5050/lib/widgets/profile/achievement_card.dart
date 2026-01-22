import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/core/constants/app_sizes.dart';
import 'package:push_up_5050/core/theme/app_theme.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/achievement.dart';

/// Achievement card widget for displaying achievement status.
///
/// Shows:
/// - Achievement icon (emoji)
/// - Achievement name and description
/// - Points (for unlocked) or lock overlay (for locked)
/// - Unlock date (if unlocked with date)
///
/// Visual states:
/// - Unlocked: orange border, full opacity, points displayed
/// - Locked: no border, 0.5 opacity, lock icon overlay
class AchievementCard extends StatelessWidget {
  /// The achievement to display.
  final Achievement achievement;

  /// Optional callback when card is tapped.
  final VoidCallback? onTap;

  const AchievementCard({
    super.key,
    required this.achievement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 150,
          maxWidth: 180,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: achievement.isUnlocked
              ? Border.all(color: AppColors.primaryOrange, width: 2)
              : null,
        ),
        child: Opacity(
          opacity: achievement.isUnlocked ? 1.0 : 0.5,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.m),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon section with lock overlay if locked
                _buildIconSection(),
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
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.s),
                // Footer: points or unlock date
                _buildFooterSection(l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build the icon section with optional lock overlay.
  Widget _buildIconSection() {
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            achievement.icon,
            style: const TextStyle(fontSize: 40),
          ),
          if (!achievement.isUnlocked)
            Icon(
              Icons.lock,
              color: AppColors.textSecondary,
              size: 20,
            ),
        ],
      ),
    );
  }

  /// Build the footer section showing points or unlock date.
  Widget _buildFooterSection(AppLocalizations l10n) {
    // For unlocked achievements with date, show date + points
    if (achievement.isUnlocked && achievement.unlockedAt != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.achievementPoints(achievement.points),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            l10n.unlockedDate(_formatDate(achievement.unlockedAt!)),
            style: AppTextStyles.caption.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
    }

    // For unlocked achievements without date, just show points
    if (achievement.isUnlocked) {
      return Text(
        l10n.achievementPoints(achievement.points),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primaryOrange,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // For locked achievements with date (shouldn't happen in practice)
    if (achievement.unlockedAt != null) {
      return Text(
        l10n.unlockedDate(_formatDate(achievement.unlockedAt!)),
        style: AppTextStyles.caption,
        textAlign: TextAlign.center,
      );
    }

    return const SizedBox.shrink();
  }

  /// Format date as DD/MM/YYYY.
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
