import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';

/// Max capacity slider widget for onboarding.
///
/// Allows users to select their maximum push-up capacity using a slider
/// with discrete preset values: 5, 10, 20, 30, 40, 50.
///
/// The slider displays the current value prominently and provides visual
/// feedback with an orange gradient track for the active portion.
class CapacitySlider extends StatelessWidget {
  /// Currently selected capacity value (one of preset values)
  final int value;

  /// Callback invoked when slider value changes
  final ValueChanged<int> onChanged;

  /// Available preset capacity values
  static const List<int> presetValues = [5, 10, 20, 30, 40, 50];

  const CapacitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Map current value to slider index (0-5)
    final sliderIndex = presetValues.indexOf(value);
    final validIndex = sliderIndex >= 0 ? sliderIndex : 2; // Default to 20

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          _getCapacityTitle(l10n),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white.withOpacity(0.95),
          ),
        ),
        const SizedBox(height: 32),

        // Large value display
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.0,
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _getMaxPushupsLabel(l10n),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Slider
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1E24).withOpacity(0.40),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  thumbShape: const _RoundSliderThumbShape(
                    enabledThumbRadius: 14,
                    overlayRadius: 22,
                  ),
                  overlayShape: const _RoundSliderOverlayShape(
                    overlayRadius: 22,
                  ),
                  activeTrackColor: const Color(0xFFFFB347),
                  inactiveTrackColor: Colors.white.withOpacity(0.20),
                  thumbColor: const Color(0xFFFFB347),
                  overlayColor: const Color(0xFFFFB347).withOpacity(0.20),
                  trackShape: const _RoundedRectSliderTrackShape(),
                ),
                child: Slider(
                  value: validIndex.toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  onChanged: (index) {
                    final intValue = index.toInt();
                    if (intValue >= 0 && intValue < presetValues.length) {
                      onChanged(presetValues[intValue]);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Helper text
        Text(
          _getCapacityQuestion(l10n),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.55),
          ),
        ),
      ],
    );
  }

  String _getCapacityTitle(AppLocalizations l10n) {
    try {
      return l10n.onboardingCapacityTitle;
    } catch (_) {
      return 'Max Push-Ups';
    }
  }

  String _getMaxPushupsLabel(AppLocalizations l10n) {
    try {
      return l10n.onboardingMaxPushups;
    } catch (_) {
      return 'max push-ups';
    }
  }

  String _getCapacityQuestion(AppLocalizations l10n) {
    try {
      return l10n.onboardingCapacityQuestion;
    } catch (_) {
      return "What's the most push-ups you can do in one set?";
    }
  }
}

/// Custom slider thumb shape with gradient effect.
class _RoundSliderThumbShape extends SliderComponentShape {
  final double enabledThumbRadius;
  final double overlayRadius;

  const _RoundSliderThumbShape({
    required this.enabledThumbRadius,
    required this.overlayRadius,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Outer glow
    final glowPaint = Paint()
      ..color = const Color(0xFFFFB347).withOpacity(0.30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, enabledThumbRadius + 4, glowPaint);

    // Main thumb
    final thumbPaint = Paint()
      ..color = sliderTheme.thumbColor ?? const Color(0xFFFFB347);
    canvas.drawCircle(center, enabledThumbRadius, thumbPaint);

    // Inner highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.30);
    canvas.drawCircle(
      center.translate(-2, -2),
      enabledThumbRadius * 0.4,
      highlightPaint,
    );
  }
}

/// Custom slider overlay shape.
class _RoundSliderOverlayShape extends SliderComponentShape {
  final double overlayRadius;

  const _RoundSliderOverlayShape({
    required this.overlayRadius,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(overlayRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    // No-op - handled by thumb glow
  }
}

/// Custom slider track shape with rounded corners.
class _RoundedRectSliderTrackShape extends SliderTrackShape {
  const _RoundedRectSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 6;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    required bool isDiscrete,
    required bool isEnabled,
    double additionalActiveTrackHeight = 2,
  }) {
    final Canvas canvas = context.canvas;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final RRect roundedTrack = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(trackRect.height / 2),
    );

    // Inactive track
    final inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? Colors.white.withOpacity(0.20);
    canvas.drawRRect(roundedTrack, inactivePaint);

    // Active track
    final activeTrackRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );
    final RRect activeRoundedTrack = RRect.fromRectAndRadius(
      activeTrackRect,
      Radius.circular(trackRect.height / 2),
    );

    final activePaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? const Color(0xFFFFB347);
    canvas.drawRRect(activeRoundedTrack, activePaint);
  }
}
