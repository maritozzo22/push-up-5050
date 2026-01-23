import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';

/// Daily goal slider widget for onboarding Screen 4.
///
/// Allows user to select daily push-up goal from preset values
/// [20, 30, 40, 50, 60, 75, 100] using a discrete slider.
///
/// Features:
/// - Large value display (64px Bold)
/// - Slider with 7 discrete positions
/// - Progress preview showing estimated time to reach 5050
/// - Glass effect container matching app design
class DailyGoalSlider extends StatelessWidget {
  /// Currently selected daily goal value
  final int value;

  /// Callback when goal value changes
  final ValueChanged<int> onChanged;

  /// Preset goal values mapped to slider positions
  static const List<int> presetValues = [20, 30, 40, 50, 60, 75, 100];

  /// Total push-up target for calculation
  static const int totalTarget = 5050;

  const DailyGoalSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// Get slider index (0-6) from current value
  int get _sliderIndex {
    for (int i = 0; i < presetValues.length; i++) {
      if (presetValues[i] == value) return i;
    }
    // Default to middle value if not found
    return 3;
  }

  /// Calculate progress preview text based on daily goal
  String _getProgressPreview(BuildContext context) {
    if (value <= 0) return '';

    final l10n = AppLocalizations.of(context)!;
    final daysNeeded = (totalTarget / value).ceil();
    final monthsNeeded = (daysNeeded / 30).ceil();
    final isItalian = l10n.localeName.startsWith('it');

    String timeText;
    if (monthsNeeded <= 1) {
      final unit = isItalian ? 'mese' : 'month';
      timeText = '$monthsNeeded $unit';
    } else if (monthsNeeded <= 6) {
      final unit = isItalian ? 'mesi' : 'months';
      timeText = '$monthsNeeded $unit';
    } else if (monthsNeeded <= 12) {
      timeText = isItalian ? '1 anno' : '1 year';
    } else {
      final years = (monthsNeeded / 12).ceil();
      final unit = isItalian ? 'anni' : 'years';
      timeText = '$years $unit';
    }

    return l10n.onboardingPacePreview(timeText);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 200),
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
                l10n.onboardingDailyGoalTitle,
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
                l10n.onboardingDailyGoalDesc,
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
                l10n.onboardingPushupsPerDay,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),

              const SizedBox(height: 24),

              // Slider
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFFFB347),
                  inactiveTrackColor: Colors.white.withOpacity(0.20),
                  thumbColor: const Color(0xFFFFB347),
                  overlayColor: const Color(0xFFFFB347).withOpacity(0.20),
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 20,
                  ),
                  valueIndicatorColor: const Color(0xFFFF5F1F),
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Slider(
                  value: _sliderIndex.toDouble(),
                  min: 0,
                  max: 6,
                  divisions: 6,
                  label: value.toString(),
                  onChanged: (index) {
                    onChanged(presetValues[index.toInt()]);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Progress preview info box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB347).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFB347).withOpacity(0.30),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFFFFB347),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _getProgressPreview(context),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ),
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
