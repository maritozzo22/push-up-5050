import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';

/// Fire effect widget for calendar day cells.
///
/// Shows a pulsing orange glow animation when active.
/// Used to highlight consecutive workout streaks (2-7 days).
class FireEffect extends StatefulWidget {
  /// Whether the fire effect is active
  final bool isActive;

  /// Child widget to wrap with the fire effect
  final Widget child;

  const FireEffect({
    super.key,
    required this.isActive,
    required this.child,
  });

  @override
  State<FireEffect> createState() => _FireEffectState();
}

class _FireEffectState extends State<FireEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(FireEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(_glowAnimation.value),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
                // Second layer for more intense effect
                BoxShadow(
                  color: AppColors.deepOrangeRed.withOpacity(_glowAnimation.value * 0.7),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
