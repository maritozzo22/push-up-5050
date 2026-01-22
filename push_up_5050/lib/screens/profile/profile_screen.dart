import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/core/utils/calculator.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/widgets/design_system/achievement_card_glass.dart';
import 'package:push_up_5050/widgets/design_system/app_background.dart';
import 'package:push_up_5050/widgets/design_system/profile_stat_card.dart';

/// Profile screen - displays user stats and achievements.
///
/// New design with dark glass + orange glow effect.
///
/// Displays:
/// - User stats section (Level, Points, Streak, Days) with ProfileStatCard widgets
/// - Achievements grid with AchievementCardGlass widgets
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppLocalizations? _l10n;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserStatsProvider>().loadStats();
      context.read<AchievementsProvider>().loadAchievements();
    });
  }

  @override
  Widget build(BuildContext context) {
    _l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Top bar with back button and title
                    Row(
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
                          _l10n?.profileTitle ?? 'Profilo',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Stats Row
                    _buildStatsSection(),

                    const SizedBox(height: 28),

                    // Achievements Section
                    _buildAchievementsSection(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build user stats section with 4 ProfileStatCard widgets.
  Widget _buildStatsSection() {
    return Consumer<UserStatsProvider>(
      builder: (context, stats, child) {
        if (stats.isLoading) {
          return _buildLoadingState();
        }

        // Calculate points and level using Calculator
        final points = Calculator.calculatePoints(
          seriesCompleted: stats.daysCompleted * 5,
          totalPushups: stats.totalPushupsAllTime,
          consecutiveDays: stats.currentStreak,
        );
        final level = Calculator.calculateLevel(points);
        final levelName = Calculator.getLevelName(level);

        // Use Wrap for responsive layout
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: _getCardWidth(context),
              child: ProfileStatCard(
                label: _l10n?.level ?? 'Livello',
                value: levelName,
                icon: Icons.military_tech_rounded,
              ),
            ),
            SizedBox(
              width: _getCardWidth(context),
              child: ProfileStatCard(
                label: _l10n?.points ?? 'Punti',
                value: '$points',
                icon: Icons.stars_rounded,
              ),
            ),
            SizedBox(
              width: _getCardWidth(context),
              child: ProfileStatCard(
                label: _l10n?.streak ?? 'Streak',
                value: '${stats.currentStreak}',
                icon: Icons.local_fire_department_rounded,
              ),
            ),
            SizedBox(
              width: _getCardWidth(context),
              child: ProfileStatCard(
                label: _l10n?.daysLabel ?? 'Giorni',
                value: '${stats.daysCompleted}/30',
                icon: Icons.calendar_today_rounded,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Calculate card width based on screen size for responsive layout.
  double _getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 44; // 22 * 2
    final availableWidth = screenWidth - padding;
    final spacing = 12;
    final cardsPerRow = availableWidth > 400 ? 4 : (availableWidth > 280 ? 2 : 1);
    return (availableWidth - (spacing * (cardsPerRow - 1))) / cardsPerRow;
  }

  /// Build achievements section with grid of AchievementCardGlass widgets.
  Widget _buildAchievementsSection() {
    return Consumer<AchievementsProvider>(
      builder: (context, achievements, child) {
        if (achievements.isLoading) {
          return _buildLoadingState();
        }

        final unlockedCount = achievements.unlockedAchievements.length;
        final totalCount = achievements.achievements.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _l10n?.achievementsCount(unlockedCount, totalCount) ??
                  'Achievement ($unlockedCount/$totalCount)',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: achievements.achievements
                  .map((a) => AchievementCardGlass(achievement: a))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  /// Build loading state widget.
  Widget _buildLoadingState() {
    return Column(
      children: [
        const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB347)),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _l10n?.loading ?? 'Caricamento...',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
