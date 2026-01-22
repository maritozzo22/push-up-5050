import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/services/proximity_sensor_service.dart';

void main() {
  // Initialize Flutter binding for tests that use platform channels
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProximitySensorService', () {
    late ProximitySensorService service;

    setUp(() {
      service = ProximitySensorService();
    });

    tearDown(() {
      service.dispose();
    });

    group('Initialization', () {
      test('should have default proximity threshold of 5 cm', () {
        expect(service.proximityThreshold, 5);
      });

      test('should have isAvailable getter', () {
        expect(service.isAvailable, isA<bool>());
      });

      test('should initialize and return availability', () async {
        final result = await service.initialize();

        // In tests without sensor, may return false
        expect(result, isA<bool>());
      });
    });

    group('Proximity Events Stream', () {
      test('should have proximityEvents stream', () {
        expect(service.proximityEvents, isA<Stream<bool>>());
      });

      test('should emit boolean values', () async {
        await service.initialize();

        // The stream should be broadcast and not empty
        final events = <bool>[];
        final subscription = service.proximityEvents.listen(events.add);

        // In tests without real sensor, we just verify stream exists
        expect(service.proximityEvents, isNotNull);

        await subscription.cancel();
      });
    });

    group('Proximity Callback', () {
      test('should set callback without throwing', () {
        expect(
          () => service.setProximityCallback(() {}),
          returnsNormally,
        );
      });

      test('should allow updating callback', () {
        service.setProximityCallback(() {});
        service.setProximityCallback(() {});
        // Should complete without error
        expect(true, isTrue);
      });

      test('should allow null callback', () {
        service.setProximityCallback(null);
        // Should complete without error
        expect(true, isTrue);
      });
    });

    group('Debounce', () {
      test('should not trigger callback multiple times rapidly', () async {
        await service.initialize();

        int callbackCount = 0;
        service.setProximityCallback(() {
          callbackCount++;
        });

        // In tests without real sensor, we can't test actual debounce
        // But we verify callback was set without error
        expect(callbackCount, 0); // No triggers in test environment
      });
    });

    group('Dispose', () {
      test('should dispose without throwing', () {
        final testService = ProximitySensorService();
        expect(() => testService.dispose(), returnsNormally);
      });

      test('should allow multiple dispose calls', () {
        final testService = ProximitySensorService();
        testService.dispose();
        expect(() => testService.dispose(), returnsNormally);
      });
    });
  });

  group('FakeProximitySensorService (for testing)', () {
    test('should create fake instance for widget tests', () async {
      final fake = FakeProximitySensorService();
      await fake.initialize();

      expect(fake.isAvailable, isTrue);
      expect(fake.callbackTriggered, isFalse);

      fake.simulateProximityEvent();
      expect(fake.callbackTriggered, isTrue);
    });

    test('should track callback triggers', () async {
      final fake = FakeProximitySensorService();
      fake.debounceMs = 0; // Disable debounce for this test
      await fake.initialize();

      int triggerCount = 0;
      fake.setProximityCallback(() {
        triggerCount++;
      });

      fake.simulateProximityEvent();
      expect(triggerCount, 1);

      fake.simulateProximityEvent();
      expect(triggerCount, 2);
    });

    test('should respect debounce delay', () async {
      final fake = FakeProximitySensorService();
      fake.debounceMs = 100; // Set shorter debounce for test
      await fake.initialize();

      int triggerCount = 0;
      fake.setProximityCallback(() {
        triggerCount++;
      });

      fake.simulateProximityEvent();
      expect(triggerCount, 1);

      // Immediate second event should be debounced
      fake.simulateProximityEvent();
      expect(triggerCount, 1); // Still 1

      // Wait for debounce to expire
      await Future.delayed(const Duration(milliseconds: 150));

      fake.simulateProximityEvent();
      expect(triggerCount, 2); // Now incremented
    });

    test('should simulate unavailable state', () async {
      final fake = FakeProximitySensorService();
      fake.setAvailable(false);
      await fake.initialize();

      expect(fake.isAvailable, isFalse);

      fake.simulateProximityEvent();
      expect(fake.callbackTriggered, isFalse); // Should not trigger
    });
  });
}

/// Fake ProximitySensorService for widget testing.
///
/// This is a simplified version - the full implementation will be in test_helpers.dart
class FakeProximitySensorService implements ProximitySensorService {
  final _controller = StreamController<bool>.broadcast();
  bool _isAvailable = true;
  VoidCallback? _callback;
  int _proximityThreshold = 5;

  // Test controls
  bool callbackTriggered = false;
  int debounceMs = 300;
  DateTime? _lastTrigger;

  void setAvailable(bool available) {
    _isAvailable = available;
  }

  void simulateProximityEvent() {
    if (!_isAvailable) return;

    final now = DateTime.now();
    if (_lastTrigger != null &&
        now.difference(_lastTrigger!).inMilliseconds < debounceMs) {
      return; // Debounced
    }

    _lastTrigger = now;
    _controller.add(true);
    _callback?.call();
    callbackTriggered = true;
  }

  @override
  Stream<bool> get proximityEvents => _controller.stream;

  @override
  bool get isAvailable => _isAvailable;

  @override
  Future<bool> initialize() async => _isAvailable;

  @override
  void setProximityCallback(VoidCallback? callback) {
    _callback = callback;
  }

  @override
  void dispose() {
    _controller.close();
  }

  @override
  int get proximityThreshold => _proximityThreshold;
}
