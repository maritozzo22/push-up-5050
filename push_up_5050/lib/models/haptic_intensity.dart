import 'package:flutter/material.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';

/// Haptic feedback intensity levels.
///
/// Used to configure the strength of vibration feedback
/// for different user interactions.
enum HapticIntensity {
  /// No haptic feedback
  off,

  /// Light vibration for push-up counting
  light,

  /// Medium vibration for achievements
  medium,
}

/// Extension to convert HapticIntensity to localized display name.
extension HapticIntensityExtension on HapticIntensity {
  /// Get the display label for this intensity.
  /// NOTE: This method returns Italian only. Use localizedLabel() for i18n.
  String get label {
    switch (this) {
      case HapticIntensity.off:
        return 'Spento';
      case HapticIntensity.light:
        return 'Leggero';
      case HapticIntensity.medium:
        return 'Medio';
    }
  }

  /// Get the localized display label for this intensity.
  /// Requires a BuildContext to access AppLocalizations.
  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case HapticIntensity.off:
        return l10n.hapticOff;
      case HapticIntensity.light:
        return l10n.hapticLight;
      case HapticIntensity.medium:
        return l10n.hapticMedium;
    }
  }
}
