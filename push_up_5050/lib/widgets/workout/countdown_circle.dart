import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';

/// Countdown circle widget for workout screen.
///
/// Displays the target number of reps in a large tappable circle.
///
/// Design specs from UI_MOCKUPS.md:
/// - Size: 280px (mobile), 320px (desktop)
/// - Gradient: Radial #FF8C00 (secondaryOrange) → #FF4500 (deepOrangeRed)
/// - Number text: 120px Bold White
/// - Subtitle: 24px Regular White below number
/// - Animation: Scale 1.1 on tap (200ms)
/// - Outer glow: 2px rgba(255, 140, 0, 0.3)
/// - Shadow: 8px rgba(0, 0, 0, 0.4)
class CountdownCircle extends StatefulWidget {
  /// Target number of reps to display
  final int number;

  /// Subtitle text to display below the number
  final String subtitle;

  /// Callback when the circle is tapped
  final VoidCallback? onTap;

  const CountdownCircle({
    super.key,
    required this.number,
    required this.subtitle,
    this.onTap,
  });

  @override
  State<CountdownCircle> createState() => _CountdownCircleState();
}

class _CountdownCircleState extends State<CountdownCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  /// Track if the user has tapped at least once
  /// When true, the subtitle is hidden
  bool _hasFirstTap = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Hide subtitle after first tap
    if (!_hasFirstTap) {
      setState(() => _hasFirstTap = true);
    }

    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive size: 280px mobile, 320px desktop
    final circleSize = MediaQuery.of(context).size.width > 600 ? 320.0 : 280.0;

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: circleSize,
          height: circleSize,
          child: Stack(
            children: [
              // Gradient circle with glow and shadow
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      AppColors.secondaryOrange,
                      AppColors.deepOrangeRed,
                    ],
                  ),
                  boxShadow: [
                    // Outer glow
                    BoxShadow(
                      color: AppColors.secondaryOrange.withOpacity(0.3),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                    // Drop shadow
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              // Centered content: number and subtitle (only shown before first tap)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.number.toString(),
                      style: const TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // Only show subtitle before first tap
                    if (!_hasFirstTap) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
