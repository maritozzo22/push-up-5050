import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';

/// Unlocked goal banner widget for workout screen.
///
/// Displays a slide-in banner when the user reaches their goal during workout.
/// Shows icon, goal name, and points earned.
///
/// Design specs:
/// - Slide-in animation from bottom
/// - Glassmorphism effect with orange border
/// - Auto-dismiss after 4 seconds
class UnlockedGoalBanner extends StatefulWidget {
  /// Goal name (e.g., "50 Push-ups")
  final String goalName;

  /// Points earned for reaching the goal
  final int points;

  const UnlockedGoalBanner({
    super.key,
    required this.goalName,
    required this.points,
  });

  @override
  State<UnlockedGoalBanner> createState() => _UnlockedGoalBannerState();
}

class _UnlockedGoalBannerState extends State<UnlockedGoalBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Slide-in animation from bottom
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom (off-screen)
      end: Offset.zero, // End at final position
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    // Start slide-in animation
    _slideController.forward();

    // Auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _slideController.reverse().then((_) {
          if (mounted) {
            // Remove from parent by calling dismiss callback
            // Parent should handle removal via key or other mechanism
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryOrange.withOpacity(0.2),
              AppColors.deepOrangeRed.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryOrange.withOpacity(0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Trophy icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Goal info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OBIETTIVO RAGGIUNTO!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryOrange,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.goalName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Points
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${widget.points}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
