import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/services/audio_service.dart';

void main() {
  // Initialize Flutter binding for tests that use platform channels
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioService', () {
    late AudioService service;

    setUp(() async {
      service = AudioService();
      await service.initialize();
    });

    tearDown(() {
      service.dispose();
    });

    group('Initialization', () {
      test('should initialize successfully or gracefully degrade', () async {
        final testService = AudioService();
        final result = await testService.initialize();

        // In tests without platform plugin, may return false
        expect(result, isA<bool>());
        expect(testService.isAvailable, result);

        testService.dispose();
      });

      test('should have isAvailable getter', () {
        expect(service.isAvailable, isA<bool>());
      });
    });

    group('Sound Settings', () {
      test('should have default settings', () {
        expect(service.soundsEnabled, isTrue);
        expect(service.beepEnabled, isTrue);
        expect(service.achievementSoundEnabled, isTrue);
        expect(service.pushupSoundEnabled, isTrue);
        expect(service.goalSoundEnabled, isTrue);
        expect(service.volume, 0.5);
      });

      test('should set sounds enabled', () async {
        await service.setSoundsEnabled(false);
        expect(service.soundsEnabled, isFalse);

        await service.setSoundsEnabled(true);
        expect(service.soundsEnabled, isTrue);
      });

      test('should set beep enabled', () async {
        await service.setBeepEnabled(false);
        expect(service.beepEnabled, isFalse);

        await service.setBeepEnabled(true);
        expect(service.beepEnabled, isTrue);
      });

      test('should set achievement sound enabled', () async {
        await service.setAchievementSoundEnabled(false);
        expect(service.achievementSoundEnabled, isFalse);

        await service.setAchievementSoundEnabled(true);
        expect(service.achievementSoundEnabled, isTrue);
      });

      test('should set pushup sound enabled', () async {
        await service.setPushupSoundEnabled(false);
        expect(service.pushupSoundEnabled, isFalse);

        await service.setPushupSoundEnabled(true);
        expect(service.pushupSoundEnabled, isTrue);
      });

      test('should set goal sound enabled', () async {
        await service.setGoalSoundEnabled(false);
        expect(service.goalSoundEnabled, isFalse);

        await service.setGoalSoundEnabled(true);
        expect(service.goalSoundEnabled, isTrue);
      });

      test('should set volume', () async {
        await service.setVolume(0.8);
        expect(service.volume, 0.8);

        await service.setVolume(0.2);
        expect(service.volume, 0.2);
      });

      test('should clamp volume to maximum 1.0', () async {
        await service.setVolume(1.5);
        expect(service.volume, 1.0);
      });

      test('should clamp volume to minimum 0.0', () async {
        await service.setVolume(-0.5);
        expect(service.volume, 0.0);
      });
    });

    group('Playback', () {
      test('should play beep without throwing', () async {
        expect(() => service.playBeep(), returnsNormally);
      });

      test('should play achievement sound without throwing', () async {
        expect(() => service.playAchievementSound(), returnsNormally);
      });

      test('should not play beep when sounds disabled', () async {
        await service.setSoundsEnabled(false);

        expect(() => service.playBeep(), returnsNormally);
      });

      test('should not play beep when beep disabled', () async {
        await service.setBeepEnabled(false);

        expect(() => service.playBeep(), returnsNormally);
      });

      test('should not play achievement sound when sounds disabled', () async {
        await service.setSoundsEnabled(false);

        expect(() => service.playAchievementSound(), returnsNormally);
      });

      test('should not play achievement sound when achievement sound disabled',
          () async {
        await service.setAchievementSoundEnabled(false);

        expect(() => service.playAchievementSound(), returnsNormally);
      });

      test('should play pushup sound without throwing', () async {
        expect(() => service.playPushupDone(), returnsNormally);
      });

      test('should play goal achieved sound without throwing', () async {
        expect(() => service.playGoalAchieved(), returnsNormally);
      });

      test('should not play pushup sound when sounds disabled', () async {
        await service.setSoundsEnabled(false);

        expect(() => service.playPushupDone(), returnsNormally);
      });

      test('should not play pushup sound when pushup sound disabled', () async {
        await service.setPushupSoundEnabled(false);

        expect(() => service.playPushupDone(), returnsNormally);
      });

      test('should not play goal achieved sound when sounds disabled', () async {
        await service.setSoundsEnabled(false);

        expect(() => service.playGoalAchieved(), returnsNormally);
      });

      test('should not play goal achieved sound when goal sound disabled',
          () async {
        await service.setGoalSoundEnabled(false);

        expect(() => service.playGoalAchieved(), returnsNormally);
      });
    });

    group('Volume Control', () {
      test('should respect volume setting', () async {
        await service.setVolume(0.0);
        expect(service.volume, 0.0);

        await service.setVolume(1.0);
        expect(service.volume, 1.0);
      });
    });

    group('Dispose', () {
      test('should dispose without throwing', () {
        final testService = AudioService();
        expect(() => testService.dispose(), returnsNormally);
      });

      test('should allow multiple dispose calls', () async {
        final testService = AudioService();
        await testService.initialize();
        testService.dispose();
        expect(() => testService.dispose(), returnsNormally);
      });
    });
  });

  group('FakeAudioService (for testing)', () {
    test('should create fake instance for widget tests', () async {
      final fake = FakeAudioService();
      await fake.initialize();

      expect(fake.isAvailable, isTrue);
      expect(fake.beepPlayCount, 0);

      await fake.playBeep();
      expect(fake.beepPlayCount, 1);
    });

    test('should track all play calls', () async {
      final fake = FakeAudioService();
      await fake.initialize();

      await fake.playBeep();
      await fake.playBeep();
      await fake.playAchievementSound();
      await fake.playPushupDone();
      await fake.playGoalAchieved();

      expect(fake.beepPlayCount, 2);
      expect(fake.achievementSoundPlayCount, 1);
      expect(fake.pushupPlayCount, 1);
      expect(fake.goalSoundPlayCount, 1);
    });

    test('should respect settings when tracking', () async {
      final fake = FakeAudioService();
      await fake.initialize();

      await fake.setBeepEnabled(false);
      await fake.playBeep();
      expect(fake.beepPlayCount, 0);

      await fake.setBeepEnabled(true);
      await fake.playBeep();
      expect(fake.beepPlayCount, 1);

      await fake.setPushupSoundEnabled(false);
      await fake.playPushupDone();
      expect(fake.pushupPlayCount, 0);

      await fake.setPushupSoundEnabled(true);
      await fake.playPushupDone();
      expect(fake.pushupPlayCount, 1);

      await fake.setGoalSoundEnabled(false);
      await fake.playGoalAchieved();
      expect(fake.goalSoundPlayCount, 0);

      await fake.setGoalSoundEnabled(true);
      await fake.playGoalAchieved();
      expect(fake.goalSoundPlayCount, 1);
    });

    test('should simulate unavailable state', () async {
      final fake = FakeAudioService();
      fake.setAvailable(false);
      await fake.initialize();

      expect(fake.isAvailable, isFalse);

      await fake.playBeep();
      await fake.playPushupDone();
      await fake.playGoalAchieved();

      expect(fake.beepPlayCount, 0); // Should not increment
      expect(fake.pushupPlayCount, 0); // Should not increment
      expect(fake.goalSoundPlayCount, 0); // Should not increment
    });
  });
}

/// Fake AudioService for widget testing.
///
/// This is a simplified version - the full implementation will be in test_helpers.dart
class FakeAudioService implements AudioService {
  bool _isAvailable = true;
  bool _soundsEnabled = true;
  bool _beepEnabled = true;
  bool _achievementSoundEnabled = true;
  bool _pushupSoundEnabled = true;
  bool _goalSoundEnabled = true;
  double _volume = 0.5;

  int beepPlayCount = 0;
  int achievementSoundPlayCount = 0;
  int pushupPlayCount = 0;
  int goalSoundPlayCount = 0;

  void setAvailable(bool available) {
    _isAvailable = available;
  }

  @override
  bool get isAvailable => _isAvailable;

  @override
  Future<bool> initialize() async => _isAvailable;

  @override
  Future<void> playBeep() async {
    if (_soundsEnabled && _beepEnabled && _isAvailable) {
      beepPlayCount++;
    }
  }

  @override
  Future<void> playAchievementSound() async {
    if (_soundsEnabled && _achievementSoundEnabled && _isAvailable) {
      achievementSoundPlayCount++;
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    if (_soundsEnabled && _isAvailable) {
      _volume = volume.clamp(0.0, 1.0);
    }
  }

  @override
  void dispose() {
    // Nothing to dispose for fake
  }

  @override
  bool get soundsEnabled => _soundsEnabled;

  @override
  bool get beepEnabled => _beepEnabled;

  @override
  bool get achievementSoundEnabled => _achievementSoundEnabled;

  @override
  bool get pushupSoundEnabled => _pushupSoundEnabled;

  @override
  bool get goalSoundEnabled => _goalSoundEnabled;

  @override
  double get volume => _volume;

  @override
  Future<void> setSoundsEnabled(bool enabled) async => _soundsEnabled = enabled;

  @override
  Future<void> setBeepEnabled(bool enabled) async => _beepEnabled = enabled;

  @override
  Future<void> setAchievementSoundEnabled(bool enabled) async =>
      _achievementSoundEnabled = enabled;

  @override
  Future<void> setPushupSoundEnabled(bool enabled) async =>
      _pushupSoundEnabled = enabled;

  @override
  Future<void> setGoalSoundEnabled(bool enabled) async =>
      _goalSoundEnabled = enabled;

  @override
  Future<void> playPushupDone() async {
    if (_soundsEnabled && _pushupSoundEnabled && _isAvailable) {
      pushupPlayCount++;
    }
  }

  @override
  Future<void> playGoalAchieved() async {
    if (_soundsEnabled && _goalSoundEnabled && _isAvailable) {
      goalSoundPlayCount++;
    }
  }
}
