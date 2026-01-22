import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';

/// Recovery ring button widget for workout screen.
///
/// Displays recovery countdown in a circular ring with color transitions:
/// - Green (100-66%) → Orange (66-33%) → Red (33-0%)
/// - Flashing animation when < 5 seconds remaining
///
/// Design specs:
/// - Size: 200px diameter
/// - Ring thickness: 8px
/// - Countdown number: 72px Bold at center
/// - Animated ring fills clockwise from top
class RecoveryRingButton extends StatefulWidget {
  /// Total recovery time in seconds
  final int totalSeconds;

  /// Remaining seconds in recovery
  final int remainingSeconds;

  /// Current series number (for display)
  final int currentSeries;

  const RecoveryRingButton({
    super.key,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.currentSeries,
  });

  @override
  State<RecoveryRingButton> createState() => _RecoveryRingButtonState();
}

class _RecoveryRingButtonState extends State<RecoveryRingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<double> _flashAnimation;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _flashAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
    );
    _flashController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  /// Get the current ring color based on remaining percentage
  Color _getRingColor(double progress) {
    if (progress >= 0.66) return AppColors.recoveryFull;
    if (progress >= 0.33) return AppColors.recoveryWarning;
    return AppColors.recoveryCritical;
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.remainingSeconds / widget.totalSeconds;
    final ringColor = _getRingColor(progress);
    final isCritical = progress < 0.05;

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          // Background ring (dark gray)
          CustomPaint(
            size: const Size(200, 200),
            painter: _RingPainter(
              progress: 1.0,
              color: const Color(0xFF2A2A2A),
              strokeWidth: 8,
            ),
          ),

          // Progress ring with color transition
          AnimatedBuilder(
            animation: _flashAnimation,
            builder: (context, child) {
              final effectiveColor = isCritical
                  ? Color.fromARGB(
                      (ringColor.alpha * _flashAnimation.value).round(),
                      ringColor.red,
                      ringColor.green,
                      ringColor.blue,
                    )
                  : ringColor;

              return CustomPaint(
                size: const Size(200, 200),
                painter: _RingPainter(
                  progress: progress.clamp(0.0, 1.0),
                  color: effectiveColor,
                  strokeWidth: 8,
                ),
              );
            },
          ),

          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.remainingSeconds.toString(),
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'recupero',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ringColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Serie ${widget.currentSeries}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the recovery ring.
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw arc from -90 degrees (top) clockwise
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
