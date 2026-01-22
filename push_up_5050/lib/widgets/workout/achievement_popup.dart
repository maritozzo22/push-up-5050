import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/models/achievement.dart';

/// Achievement popup widget for workout screen.
///
/// Non-intrusive notification when achievement is unlocked.
/// Slides in from top, displays for 3-4 seconds, then slides out.
///
/// Design specs from UI_MOCKUPS.md:
/// - Width: 90% screen width
/// - Position: top 20px
/// - Animation: SlideTransition (300ms slide-in/out)
/// - Auto-dismiss: 3-4 seconds
/// - Border: Orange 2px
/// - Border radius: 16px
class AchievementPopup extends StatefulWidget {
  /// Achievement to display
  final Achievement achievement;

  /// Whether to disable auto-dismiss timer (for testing only).
  /// When true, the popup will not auto-dismiss and must be manually dismissed.
  final bool disableAutoDismiss;

  const AchievementPopup({
    super.key,
    required this.achievement,
    this.disableAutoDismiss = false,
  });

  @override
  State<AchievementPopup> createState() => _AchievementPopupState();
}

class _AchievementPopupState extends State<AchievementPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isDismissing = false;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // Start off-screen (top)
      end: const Offset(0, -0.1), // End at top position
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Slide in
    _controller.forward();

    // Auto-dismiss after 4 seconds (unless disabled for testing)
    if (!widget.disableAutoDismiss) {
      _autoDismissTimer = Timer(const Duration(seconds: 4), () {
        if (mounted && !_isDismissing) {
          _dismiss();
        }
      });
    }
  }

  void _dismiss() {
    _isDismissing = true;
    _controller.reverse().then((_) {
      if (mounted) {
        // Widget will be removed by parent
      }
    });
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: _dismiss,
        behavior: HitTestBehavior.opaque,
        child: Center(
          heightFactor: 1,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.9),
              border: Border.all(color: AppColors.primaryOrange, width: 2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button in top right
                SizedBox(
                  height: 24,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _dismiss,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Icon
                Text(
                  widget.achievement.icon,
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 8),
                // Name
                Text(
                  widget.achievement.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  widget.achievement.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Points
                Text(
                  '+${widget.achievement.points} punti',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
