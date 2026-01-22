import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StartButtonCircle extends StatefulWidget {
  final VoidCallback onTap;

  /// Static flag to disable animations in tests.
  /// Set this to true in test setUp to prevent pumpAndSettle timeout.
  static bool testMode = false;

  const StartButtonCircle({super.key, required this.onTap});

  @override
  State<StartButtonCircle> createState() => _StartButtonCircleState();
}

class _StartButtonCircleState extends State<StartButtonCircle>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  AnimationController? _glow;

  @override
  void initState() {
    super.initState();
    // Disable animation in tests to prevent pumpAndSettle timeout
    if (!StartButtonCircle.testMode) {
      _glow = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900),
        lowerBound: 0.55,
        upperBound: 1.0,
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _glow?.dispose();
    super.dispose();
  }

  /// Trigger haptic feedback on button press.
  void _triggerHapticFeedback() {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {
      // Silently fail if haptics not available
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _triggerHapticFeedback();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedBuilder(
          animation: _glow ?? const AlwaysStoppedAnimation(0.55),
          builder: (_, __) {
            return Container(
              constraints: const BoxConstraints(
                minWidth: 164,
                maxWidth: 164,
                minHeight: 164,
                maxHeight: 164,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF7A18).withOpacity((_glow?.value ?? 0.55) * 0.55),
                    blurRadius: 38,
                    spreadRadius: 10,
                  ),
                  BoxShadow(
                    color: const Color(0xFFFF7A18).withOpacity((_glow?.value ?? 0.55) * 0.22),
                    blurRadius: 80,
                    spreadRadius: 18,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'START',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
