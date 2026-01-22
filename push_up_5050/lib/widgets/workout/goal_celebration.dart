import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';

/// Goal celebration widget with confetti animation.
///
/// Displays a full-screen overlay with:
/// - Animated confetti particles
/// - Achievement message
/// - Auto-dismisses after 3 seconds
class GoalCelebrationWidget extends StatefulWidget {
  final String message;
  final VoidCallback? onComplete;

  const GoalCelebrationWidget({
    super.key,
    required this.message,
    this.onComplete,
  });

  @override
  State<GoalCelebrationWidget> createState() => _GoalCelebrationWidgetState();
}

class _GoalCelebrationWidgetState extends State<GoalCelebrationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final List<ConfettiParticle> _particles = [];
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Generate confetti particles
    _generateParticles();

    // Start animations
    _controller.forward();

    // Auto-dismiss after 3 seconds
    _dismissTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onComplete?.call();
      }
    });
  }

  void _generateParticles() {
    final random = Random();
    for (int i = 0; i < 50; i++) {
      _particles.add(ConfettiParticle(random));
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: GestureDetector(
        onTap: () {
          // Allow tap to dismiss early
          _dismissTimer?.cancel();
          widget.onComplete?.call();
        },
        child: Stack(
          children: [
            // Confetti particles
            ..._particles.map((particle) => _ConfettiWidget(
                  particle: particle,
                  animation: _controller,
                )),

            // Center message
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
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
                      const Icon(
                        Icons.emoji_events,
                        color: AppColors.primaryOrange,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'OBIETTIVO RAGGIUNTO!',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '2x Punti!',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
        final screenSize = MediaQuery.of(context).size;

        // Particle position with falling animation
        double x = particle.x * screenSize.width;
        double y = particle.y * screenSize.height - (progress * 800);
        double rotation = particle.angle + (progress * particle.rotationSpeed * 360);

        // Wrap around horizontally
        while (x < 0) x += screenSize.width;
        while (x > screenSize.width) x -= screenSize.width;

        // Skip if completely off screen
        if (y < -50 || y > screenSize.height + 50) {
          return const SizedBox.shrink();
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
