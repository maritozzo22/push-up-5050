import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';

/// Workout frequency selector widget for onboarding Screen 3.
///
/// Allows user to select workout frequency from 1-7 days per week
/// using a simple counter pattern with +/- buttons.
///
/// Features:
/// - Large central value display (64px Bold)
/// - Minus button (disabled at value 1)
/// - Plus button (disabled at value 7)
/// - Glass effect container matching app design
class FrequencySelector extends StatelessWidget {
  /// Currently selected frequency value (1-7 days per week)
  final int value;

  /// Callback when frequency value changes
  final ValueChanged<int> onChanged;

  const FrequencySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canDecrement = value > 1;
    final canIncrement = value < 7;

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 160),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1E24).withOpacity(0.55),
            border: Border.all(color: Colors.white.withOpacity(0.10), width: 1),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                l10n.onboardingFrequencyTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.75),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                l10n.onboardingFrequencyDesc,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.55),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Large value display
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),

              const SizedBox(height: 4),

              // Label below value
              Text(
                l10n.onboardingDaysPerWeek,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),

              const SizedBox(height: 20),

              // +/- buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Minus button
                  _CircleIconButton(
                    icon: Icons.remove_rounded,
                    isEnabled: canDecrement,
                    onTap: canDecrement
                        ? () => onChanged(value - 1)
                        : null,
                  ),

                  const SizedBox(width: 48),

                  // Plus button
                  _CircleIconButton(
                    icon: Icons.add_rounded,
                    isEnabled: canIncrement,
                    onTap: canIncrement
                        ? () => onChanged(value + 1)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circle icon button with gradient and press animation.
///
/// Matches the styling from SeriesSelectionScreen _CircleIconButton:
/// - Orange gradient when enabled
/// - Semi-transparent white when disabled
/// - 56x56 size with 28px icon
class _CircleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isEnabled;

  const _CircleIconButton({
    required this.icon,
    this.onTap,
    required this.isEnabled,
  });

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.08),
        ),
        child: Icon(
          widget.icon,
          color: Colors.white.withOpacity(0.25),
          size: 28,
        ),
      );
    }

    Widget button = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A18).withOpacity(0.35),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        widget.icon,
        color: Colors.black.withOpacity(0.82),
        size: 28,
      ),
    );

    return GestureDetector(
      onTap: () {
        setState(() => _pressed = true);
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) setState(() => _pressed = false);
        });
        widget.onTap?.call();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: button,
      ),
    );
  }
}
