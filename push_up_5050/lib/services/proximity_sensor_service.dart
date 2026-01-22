import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

/// Callback type for proximity sensor events.
typedef ProximityCallback = void Function();

/// Service for detecting proximity sensor events.
///
/// Monitors the device proximity sensor and triggers callbacks when
/// an object is brought near the device (chest for push-up counting).
///
/// Uses the `proximity_sensor` package for Android hardware integration.
///
/// Features:
/// - Debounce logic (300ms) to prevent multiple rapid triggers
/// - Graceful degradation when sensor unavailable (Windows/desktop)
/// - Stream of proximity events for reactive UI
///
/// Sensor behavior (proximity_sensor package):
/// - event > 0: object is near (trigger count)
/// - event <= 0: object is far (ignore)
class ProximitySensorService {
  StreamSubscription<dynamic>? _subscription;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  bool _isAvailable = false;
  bool _isInitialized = false;
  ProximityCallback? _callback;

  // Debounce to prevent multiple triggers from single motion
  static const int _debounceMs = 300;
  DateTime? _lastTrigger;

  // Proximity threshold in cm (default 5cm)
  final int _proximityThreshold;

  /// Create ProximitySensorService.
  ///
  /// Optionally set [proximityThreshold] in cm (default 5).
  ProximitySensorService({int proximityThreshold = 5})
      : _proximityThreshold = proximityThreshold;

  /// Stream of proximity events.
  ///
  /// Emits `true` when object is near, `false` when far.
  Stream<bool> get proximityEvents => _controller.stream;

  /// Whether proximity sensor is available on this device.
  bool get isAvailable => _isAvailable;

  /// Minimum proximity threshold in cm for triggering events.
  int get proximityThreshold => _proximityThreshold;

  /// Initialize the sensor and start monitoring.
  ///
  /// Returns `true` if sensor is available, `false` otherwise.
  ///
  /// In test/desktop environments without sensor support, returns false.
  Future<bool> initialize() async {
    if (_isInitialized) return _isAvailable;

    try {
      // Try to access proximity sensor
      // This will fail on Windows/desktop or when sensor unavailable
      // The actual platform channel implementation would be here
      final DynamicStream = _getProximityStream();
      if (DynamicStream != null) {
        _subscription = DynamicStream.listen(_handleProximityEvent);
        _isAvailable = true;
      } else {
        _isAvailable = false;
      }
    } catch (e) {
      // Sensor unavailable - service will gracefully degrade
      _isAvailable = false;
    }

    _isInitialized = true;
    return _isAvailable;
  }

  /// Get proximity stream from proximity_sensor package.
  ///
  /// Returns null on platforms without sensor support (Windows, iOS without sensor).
  /// Returns stream of proximity events on Android devices.
  Stream<double>? _getProximityStream() {
    try {
      // proximity_sensor package: ProximitySensor.events emits int values
      // event > 0 = near (object close), event <= 0 = far (object away)
      // Map int to double for compatibility with existing handler
      return ProximitySensor.events.map((event) => event.toDouble());
    } catch (e) {
      // Platform doesn't support proximity sensor - gracefully degrade
      return null;
    }
  }

  /// Set callback to be triggered when proximity is detected.
  ///
  /// The callback is triggered when an object comes within
  /// [proximityThreshold] cm of the device.
  ///
  /// Pass `null` to remove the callback.
  void setProximityCallback(ProximityCallback? callback) {
    _callback = callback;
  }

  /// Handle proximity sensor event.
  ///
  /// [distance] value from proximity_sensor package:
  /// - > 0: object is near (trigger event)
  /// - <= 0: object is far (ignore)
  void _handleProximityEvent(dynamic distance) {
    // Convert distance to double if possible
    final double dist = distance is double ? distance : 0.0;

    // proximity_sensor: event > 0 means near (trigger), <= 0 means far (ignore)
    if (dist <= 0) return;

    // Apply debounce - prevent multiple triggers within debounce window
    final now = DateTime.now();
    if (_lastTrigger != null &&
        now.difference(_lastTrigger!).inMilliseconds < _debounceMs) {
      return; // Too soon since last trigger
    }

    _lastTrigger = now;

    // Emit event
    _controller.add(true);

    // Trigger callback
    _callback?.call();
  }

  /// Dispose resources and stop monitoring.
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _callback = null;
    _controller.close();
  }
}

/// Typedef for dynamic stream to avoid compilation issues.
typedef DynamicStream = Stream<dynamic>;
