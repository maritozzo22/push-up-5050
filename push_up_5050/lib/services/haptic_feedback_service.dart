import 'dart:io';
import 'package:vibration/vibration.dart';

/// Service for providing haptic feedback.
///
/// Offers three intensity levels:
/// - Light: For push-up count feedback
/// - Medium: For achievement unlock
/// - Heavy: For workout completion
///
/// Gracefully degrades on platforms without vibration support.
class HapticFeedbackService {
  bool _isAvailable = false;
  bool _hasInitialized = false;

  /// Create HapticFeedbackService.
  ///
  /// Automatically checks vibration availability.
  HapticFeedbackService() {
    _initialize();
  }

  /// Initialize the service and check availability.
  Future<void> _initialize() async {
    _hasInitialized = true;
    _isAvailable = await Vibration.hasVibrator() ?? false;
  }

  /// Whether vibration is available on this device.
  ///
  /// Returns false if:
  /// - Platform doesn't support vibration (e.g., some desktops)
  /// - Device has no vibrator
  bool get isAvailable {
    if (!_hasInitialized) {
      // Fallback check if not yet initialized
      return Platform.isAndroid || Platform.isIOS;
    }
    return _isAvailable;
  }

  /// Trigger light vibration impact.
  ///
  /// Use for: Each push-up count.
  ///
  /// Returns true if vibration was triggered, false if unavailable.
  Future<bool> lightImpact() async {
    if (!_isAvailable) return false;

    try {
      // Vibrate for 50ms with default amplitude
      await Vibration.vibrate(duration: 50, amplitude: 128);
      return true;
    } catch (e) {
      // Silently fail - vibration is optional
      return false;
    }
  }

  /// Trigger medium vibration impact.
  ///
  /// Use for: Achievement unlock.
  ///
  /// Returns true if vibration was triggered, false if unavailable.
  Future<bool> mediumImpact() async {
    if (!_isAvailable) return false;

    try {
      // Vibrate for 100ms with medium amplitude
      await Vibration.vibrate(duration: 100, amplitude: 180);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Trigger heavy vibration impact.
  ///
  /// Use for: Workout completion, major milestones.
  ///
  /// Returns true if vibration was triggered, false if unavailable.
  Future<bool> heavyImpact() async {
    if (!_isAvailable) return false;

    try {
      // Vibrate with pattern: 200ms on, 100ms off, 200ms on
      await Vibration.vibrate(
        pattern: [0, 200, 100, 200],
        amplitude: 255,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Dispose resources.
  ///
  /// Cancels any ongoing vibration.
  void dispose() {
    // Don't cancel in tests or if plugin not available
    try {
      Vibration.cancel();
    } catch (e) {
      // Ignore cancel errors - plugin may not be available in tests
    }
  }
}
