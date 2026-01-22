import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/core/constants/app_sizes.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/widgets/design_system/app_background.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';

/// Achievements screen - displays all achievements.
///
/// Shows:
/// - Header with back button and title
/// - Progress bar (unlocked/total)
/// - Grid of all achievements with lock/unlock status
/// - Each achievement shows: icon, name, description, points
///
/// Design: Dark glass + orange glow effect.
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  void initState() {
    super.initState();
    // Load achievements when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AchievementsProvider>().loadAchievements();
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
            child: Consumer<AchievementsProvider>(
              builder: (context, provider, child) {
                final achievements = provider.achievements;
                final unlockedCount = provider.unlockedAchievements.length;
                final totalCount = achievements.length;
                final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;

                return Column(
                  children: [
                    // Header
                    _buildHeader(context, l10n),

                    // Progress Card
                    _buildProgressCard(unlockedCount, totalCount, progress, l10n),

                    // Achievements Grid
                    Expanded(
                      child: provider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryOrange,
                              ),
                            )
                          : _buildAchievementsGrid(achievements),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: const Color(0xFFFFB347).withOpacity(0.95),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Achievement',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    int unlockedCount,
    int totalCount,
    double progress,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: FrostCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progresso',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$unlockedCount / $totalCount',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsGrid(List<Achievement> achievements) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          return _AchievementTile(achievement: achievements[index]);
        },
      ),
    );
  }
}

/// Achievement tile widget for displaying a single achievement.
class _AchievementTile extends StatelessWidget {
  final Achievement achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isUnlocked
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryOrange.withOpacity(0.15),
                  AppColors.deepOrangeRed.withOpacity(0.15),
                ],
              )
            : null,
        color: isUnlocked ? null : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked
              ? AppColors.primaryOrange.withOpacity(0.4)
              : Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and lock row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: isUnlocked
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                        )
                      : null,
                  color: isUnlocked ? null : Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isUnlocked
                      ? Text(
                          achievement.icon,
                          style: const TextStyle(fontSize: 24),
                        )
                      : Icon(
                          Icons.lock,
                          color: Colors.white.withOpacity(0.3),
                          size: 20,
                        ),
                ),
              ),
              // Points badge (only if unlocked)
              if (isUnlocked)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+${achievement.points}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Name
          Text(
            achievement.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isUnlocked ? Colors.white : Colors.white.withOpacity(0.5),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Description
          Text(
            achievement.description,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isUnlocked
                  ? Colors.white.withOpacity(0.7)
                  : Colors.white.withOpacity(0.3),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          // Status indicator
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? AppColors.recoveryFull
                      : Colors.white.withOpacity(0.3),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isUnlocked ? 'Sbloccato' : 'Bloccato',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked
                      ? AppColors.recoveryFull
                      : Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
