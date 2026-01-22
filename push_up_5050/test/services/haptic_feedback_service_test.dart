import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/services/haptic_feedback_service.dart';

void main() {
  // Initialize Flutter binding for tests that use platform channels
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HapticFeedbackService', () {
    late HapticFeedbackService service;

    setUp(() {
      service = HapticFeedbackService();
    });

    // Note: dispose() is not called in tearDown to avoid MissingPluginException
    // In production, dispose will be called when widget/service is destroyed

    group('Availability', () {
      test('should report availability', () {
        // On platforms without vibration support, isAvailable may be false
        // But the service should still handle calls gracefully
        expect(service.isAvailable, isA<bool>());
      });

      test('should have isAvailable getter', () {
        expect(() => service.isAvailable, returnsNormally);
      });
    });

    group('Light Impact', () {
      test('should call lightImpact without throwing', () async {
        // Should never throw, even if vibration unavailable
        expect(() => service.lightImpact(), returnsNormally);
      });

      test('should return true or false for lightImpact', () async {
        final result = await service.lightImpact();
        expect(result, isA<bool>());
      });

      test('should handle multiple lightImpact calls', () async {
        await service.lightImpact();
        await service.lightImpact();
        await service.lightImpact();

        // Should complete without error
        expect(true, isTrue);
      });
    });

    group('Medium Impact', () {
      test('should call mediumImpact without throwing', () async {
        expect(() => service.mediumImpact(), returnsNormally);
      });

      test('should return true or false for mediumImpact', () async {
        final result = await service.mediumImpact();
        expect(result, isA<bool>());
      });

      test('should handle multiple mediumImpact calls', () async {
        await service.mediumImpact();
        await service.mediumImpact();

        // Should complete without error
        expect(true, isTrue);
      });
    });

    group('Heavy Impact', () {
      test('should call heavyImpact without throwing', () async {
        expect(() => service.heavyImpact(), returnsNormally);
      });

      test('should return true or false for heavyImpact', () async {
        final result = await service.heavyImpact();
        expect(result, isA<bool>());
      });

      test('should handle multiple heavyImpact calls', () async {
        await service.heavyImpact();
        await service.heavyImpact();

        // Should complete without error
        expect(true, isTrue);
      });
    });

    group('All Impact Types', () {
      test('should call all impact types in sequence', () async {
        await service.lightImpact();
        await service.mediumImpact();
        await service.heavyImpact();

        // Should complete without error
        expect(true, isTrue);
      });

      test('should handle rapid successive calls', () async {
        for (int i = 0; i < 10; i++) {
          await service.lightImpact();
        }

        // Should complete without error
        expect(true, isTrue);
      });
    });

    group('Graceful Degradation', () {
      test('should not crash when vibration is unavailable', () async {
        // Even on platforms without vibration, calls should succeed
        await service.lightImpact();
        await service.mediumImpact();
        await service.heavyImpact();

        expect(true, isTrue);
      });
    });
  });

  group('FakeHapticFeedbackService (for testing)', () {
    test('should create fake instance for widget tests', () {
      // This test verifies the pattern for creating fake services
      // Actual fake implementation is in test_helpers.dart
      final fake = FakeHapticFeedbackService();

      expect(fake.isAvailable, isTrue);
      expect(fake.lightImpactCount, 0);

      fake.lightImpact();
      expect(fake.lightImpactCount, 1);
    });

    test('should track all impact types', () async {
      final fake = FakeHapticFeedbackService();

      await fake.lightImpact();
      await fake.lightImpact();
      await fake.mediumImpact();
      await fake.heavyImpact();

      expect(fake.lightImpactCount, 2);
      expect(fake.mediumImpactCount, 1);
      expect(fake.heavyImpactCount, 1);
    });

    test('should simulate unavailable state', () async {
      final fake = FakeHapticFeedbackService();
      fake.setAvailable(false);

      expect(fake.isAvailable, isFalse);

      final result = await fake.lightImpact();
      expect(result, isFalse);
      expect(fake.lightImpactCount, 0); // Should not increment
    });
  });
}

/// Fake HapticFeedbackService for widget testing.
///
/// This is a simplified version - the full implementation will be in test_helpers.dart
class FakeHapticFeedbackService implements HapticFeedbackService {
  bool _isAvailable = true;
  int lightImpactCount = 0;
  int mediumImpactCount = 0;
  int heavyImpactCount = 0;

  void setAvailable(bool available) {
    _isAvailable = available;
  }

  @override
  bool get isAvailable => _isAvailable;

  @override
  Future<bool> lightImpact() async {
    if (!_isAvailable) return false;
    lightImpactCount++;
    return true;
  }

  @override
  Future<bool> mediumImpact() async {
    if (!_isAvailable) return false;
    mediumImpactCount++;
    return true;
  }

  @override
  Future<bool> heavyImpact() async {
    if (!_isAvailable) return false;
    heavyImpactCount++;
    return true;
  }

  @override
  void dispose() {
    // Nothing to dispose for fake
  }
}
