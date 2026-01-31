import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';

/// Goal completion dialog widget with confetti animation.
///
/// Displays a centered modal dialog with:
/// - Animated confetti particles
/// - Italian congratulatory message
/// - "Continua" button for dismissal
/// - Auto-dismisses after 5 seconds (unless disabled)
class GoalCompletionDialog extends StatefulWidget {
  final VoidCallback? onDismiss;
  final bool disableAutoDismiss;

  const GoalCompletionDialog({
    super.key,
    this.onDismiss,
    this.disableAutoDismiss = false,
  });

  @override
  State<GoalCompletionDialog> createState() => _GoalCompletionDialogState();
}

class _GoalCompletionDialogState extends State<GoalCompletionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final List<ConfettiParticle> _particles = [];
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Generate confetti particles
    _generateParticles();

    // Start animations
    _controller.forward();

    // Auto-dismiss after 5 seconds (unless disabled)
    if (!widget.disableAutoDismiss) {
      _dismissTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          _handleDismiss();
        }
      });
    }
  }

  void _generateParticles() {
    final random = Random();
    for (int i = 0; i < 50; i++) {
      _particles.add(ConfettiParticle(random));
    }
  }

  void _handleDismiss() {
    _dismissTimer?.cancel();
    widget.onDismiss?.call();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Confetti particles overlay
          SizedBox(
            width: 400,
            height: 500,
            child: Stack(
              children: _particles
                  .map((particle) => _ConfettiWidget(
                        particle: particle,
                        animation: _controller,
                      ))
                  .toList(),
            ),
          ),

          // Dialog content
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryOrange,
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    const Icon(
                      Icons.emoji_events,
                      color: AppColors.primaryOrange,
                      size: 64,
                    ),
                    const SizedBox(height: 16),

                    // Title
                    const Text(
                      'Complimenti!',
                      style: TextStyle(
                        color: AppColors.primaryOrange,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Message
                    const Text(
                      'Hai completato il tuo obiettivo di oggi.\nCi vediamo domani!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Continua button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleDismiss,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continua',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Confetti particle data class.
class ConfettiParticle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double speed;
  final double angle;
  final double rotationSpeed;

  ConfettiParticle(Random random)
      : x = random.nextDouble(),
        y = random.nextDouble(),
        size = 8 + random.nextDouble() * 12,
        color = _getRandomColor(random),
        speed = 0.3 + random.nextDouble() * 0.5,
        angle = random.nextDouble() * 360,
        rotationSpeed = (random.nextDouble() - 0.5) * 10;

  static Color _getRandomColor(Random random) {
    final colors = [
      AppColors.primaryOrange,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.yellow,
      Colors.cyan,
    ];
    return colors[random.nextInt(colors.length)];
  }
}

/// Widget that renders a single confetti particle.
class _ConfettiWidget extends StatelessWidget {
  final ConfettiParticle particle;
  final Animation<double> animation;

  const _ConfettiWidget({
    required this.particle,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = animation.value;
        final screenSize = const Size(400, 500);

        // Particle position with falling animation
        double x = particle.x * screenSize.width;
        double y = particle.y * 50 - (progress * 400);
        double rotation = particle.angle + (progress * particle.rotationSpeed * 360);

        // Wrap around horizontally
        while (x < 0) x += screenSize.width;
        while (x > screenSize.width) x -= screenSize.width;

        // Skip if completely off screen
        if (y < -50 || y > screenSize.height + 50) {
          return const Positioned(child: SizedBox.shrink());
        }

        return Positioned(
          left: x,
          top: y,
          child: Transform.rotate(
            angle: rotation * 3.14159 / 180,
            child: Container(
              width: particle.size,
              height: particle.size,
              decoration: BoxDecoration(
                color: particle.color,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      },
    );
  }
}
