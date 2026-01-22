import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:push_up_5050/models/achievement.dart';

/// Achievement card with glass effect.
/// Displays achievement info with different styles for locked/unlocked states.
class AchievementCardGlass extends StatelessWidget {
  final Achievement achievement;

  const AchievementCardGlass({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnlocked
                ? const Color(0xFF1A2028).withOpacity(0.70)
                : const Color(0xFF161A20).withOpacity(0.45),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isUnlocked
                  ? const Color(0xFFFFB347).withOpacity(0.25)
                  : Colors.white.withOpacity(0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row: icon + unlocked badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isUnlocked
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                            )
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.12),
                                Colors.white.withOpacity(0.06),
                              ],
                            ),
                    ),
                    child: Icon(
                      _getIconForAchievement(achievement.id),
                      size: 22,
                      color: isUnlocked
                          ? Colors.black.withOpacity(0.75)
                          : Colors.white.withOpacity(0.40),
                    ),
                  ),
                  // Unlocked badge
                  if (isUnlocked)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'UNLOCKED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                achievement.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isUnlocked ? Colors.white : Colors.white.withOpacity(0.50),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Description
              Text(
                achievement.description,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(isUnlocked ? 0.60 : 0.35),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForAchievement(String achievementId) {
    // Return appropriate icon based on achievement type
    if (achievementId.contains('first') || achievementId.contains('beginner')) {
      return Icons.star_rounded;
    } else if (achievementId.contains('streak') || achievementId.contains('week')) {
      return Icons.local_fire_department_rounded;
    } else if (achievementId.contains('hundred') || achievementId.contains('thousand')) {
      return Icons.military_tech_rounded;
    } else if (achievementId.contains('warrior') || achievementId.contains('master')) {
      return Icons.emoji_events_rounded;
    } else if (achievementId.contains('consistent')) {
      return Icons.calendar_today_rounded;
    } else if (achievementId.contains('beast')) {
      return Icons.fitness_center_rounded;
    }
    return Icons.workspace_premium_rounded;
  }
}
