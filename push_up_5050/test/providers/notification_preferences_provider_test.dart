import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/notification_time_slot.dart';
import 'package:push_up_5050/providers/notification_preferences_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple mock SharedPreferences for testing
class FakePrefs implements SharedPreferences {
  final Map<String, dynamic> _data = {};

  @override
  Future<bool> clear() async {
    _data.clear();
    return true;
  }

  @override
  Future<bool> commit() async => true;

  @override
  bool containsKey(String key) => _data.containsKey(key);

  @override
  dynamic get(String key) => _data[key];

  @override
  bool? getBool(String key) => _data[key] as bool?;

  @override
  double? getDouble(String key) => _data[key] as double?;

  @override
  int? getInt(String key) => _data[key] as int?;

  @override
  Set<String> getKeys() => _data.keys.toSet();

  @override
  String? getString(String key) => _data[key] as String?;

  @override
  List<String>? getStringList(String key) => _data[key] as List<String>?;

  @override
  Future<void> reload() async {}

  @override
  Future<bool> remove(String key) async {
    _data.remove(key);
    return true;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setString(String key, String value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> clearAndSetDefaults(Map<String, Object> defaults) async => true;
  @override
  Future<bool> clearAndSetPrefList(Map<String, Object> preferences) async => true;
  @override
  bool getBoolOptional(String key) => throw UnimplementedError();
  @override
  double getDoubleOptional(String key) => throw UnimplementedError();
  @override
  int getIntOptional(String key) => throw UnimplementedError();
  @override
  String getStringOptional(String key) => throw UnimplementedError();
  @override
  List<String> getStringListOptional(String key) => throw UnimplementedError();
  @override
  dynamic getOptional(String key) => throw UnimplementedError();
}

void main() {
  late NotificationPreferencesProvider provider;
  late StorageService storageService;
  late FakePrefs fakePrefs;

  setUp(() async {
    fakePrefs = FakePrefs();
    storageService = StorageService.forTesting(fakePrefs);
    provider = NotificationPreferencesProvider(storage: storageService);
  });

  group('NotificationPreferencesProvider', () {
    group('Initialization', () {
      test('should initialize with default values (9:00)', () {
        expect(provider.personalizedHour, 9);
        expect(provider.personalizedMinute, 0);
        expect(provider.isLoading, false);
      });

      test('should format time correctly', () {
        expect(provider.formattedTime, '9:00');
      });

      test('should format time with leading zero for minute', () {
        provider = NotificationPreferencesProvider(storage: storageService);
        // After update with minute < 10
        provider.updatePersonalizedTime(14, 5);
        expect(provider.formattedTime, '14:05');
      });

      test('should format time with leading zero for hour < 10', () {
        provider.updatePersonalizedTime(8, 30);
        expect(provider.formattedTime, '8:30');
      });
    });

    group('loadPreferences', () {
      test('should load default time when no workout data', () async {
        await provider.loadPreferences();

        expect(provider.personalizedHour, 9);
        expect(provider.personalizedMinute, 0);
        expect(provider.isLoading, false);
      });

      test('should load calculated time when sufficient workout data', () async {
        // Add 7 workout times at 8am
        for (int i = 0; i < 7; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 20 + i, 8, 0),
          );
        }

        await provider.loadPreferences();

        expect(provider.personalizedHour, 8); // 8am is in 8-9 bin
        expect(provider.personalizedMinute, 0);
      });

      test('should notify listeners after loading', () async {
        bool notified = false;
        provider.addListener(() {
          notified = true;
        });

        await provider.loadPreferences();

        expect(notified, true);
      });

      test('should set isLoading to false after loading', () async {
        await provider.loadPreferences();

        expect(provider.isLoading, false);
      });
    });

    group('updatePersonalizedTime', () {
      test('should update hour and minute', () async {
        provider.updatePersonalizedTime(14, 30);

        expect(provider.personalizedHour, 14);
        expect(provider.personalizedMinute, 30);
      });

      test('should save to storage service', () async {
        provider.updatePersonalizedTime(16, 45);

        // Verify storage was called
        final hour = fakePrefs.getInt('personalized_notification_hour');
        final minute = fakePrefs.getInt('personalized_notification_minute');

        expect(hour, 16);
        expect(minute, 45);
      });

      test('should notify listeners after update', () async {
        bool notified = false;
        provider.addListener(() {
          notified = true;
        });

        provider.updatePersonalizedTime(10, 0);

        expect(notified, true);
      });

      test('should update formattedTime correctly', () async {
        provider.updatePersonalizedTime(8, 5);

        expect(provider.formattedTime, '8:05');
      });
    });

    group('recalculatePersonalizedTime', () {
      test('should recalculate based on current workout times', () async {
        // Start with default
        expect(provider.personalizedHour, 9);

        // Add 7 workout times at 14:00
        for (int i = 0; i < 7; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 20 + i, 14, 0),
          );
        }

        // Recalculate
        await provider.recalculatePersonalizedTime();

        expect(provider.personalizedHour, 14); // 14 is in 14-15 bin
        expect(provider.personalizedMinute, 0);
      });

      test('should not change if calculation result is same', () async {
        // Set to 8:00
        provider.updatePersonalizedTime(8, 0);

        // No workout data, so recalculation should keep current value
        // since no personalized time can be calculated
        final beforeHour = provider.personalizedHour;
        await provider.recalculatePersonalizedTime();

        expect(provider.personalizedHour, beforeHour);
      });

      test('should update when calculation differs from current', () async {
        // Set to 10:00
        provider.updatePersonalizedTime(10, 0);

        // Add 7 workouts at 14:00 (14-15 bin)
        for (int i = 0; i < 7; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 20 + i, 14, 0),
          );
        }

        await provider.recalculatePersonalizedTime();

        // Should change from 10 to 14
        expect(provider.personalizedHour, 14);
        expect(provider.personalizedMinute, 0);
      });

      test('should notify listeners after recalculation', () async {
        bool notified = false;
        provider.addListener(() {
          notified = true;
        });

        // Add 7 workouts at different time
        for (int i = 0; i < 7; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 20 + i, 18, 0),
          );
        }

        await provider.recalculatePersonalizedTime();

        expect(notified, true);
      });
    });

    group('Integration - Full Workflow', () {
      test('should load preferences with existing workout history', () async {
        // Simulate user history: 10 workouts at 8am
        for (int i = 0; i < 10; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 20 + i, 8, 0),
          );
        }

        await provider.loadPreferences();

        expect(provider.personalizedHour, 8); // 8am in 8-9 bin
        expect(provider.formattedTime, '8:00');
      });

      test('should allow manual override of calculated time', () async {
        // Add 7 workouts at 8am (would calculate to 8)
        for (int i = 0; i < 7; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 20 + i, 8, 0),
          );
        }

        await provider.loadPreferences();
        expect(provider.personalizedHour, 8);

        // User manually overrides to 14:00
        provider.updatePersonalizedTime(14, 0);
        expect(provider.personalizedHour, 14);
      });

      test('should support weekly recalculation workflow', () async {
        // Week 1: User works out at 8am
        for (int i = 0; i < 7; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 20 + i, 8, 0),
          );
        }

        await provider.loadPreferences();
        expect(provider.personalizedHour, 8);

        // Week 2: User shifts to evening workouts (add 7 more)
        for (int i = 0; i < 7; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 27 + i, 18, 0),
          );
        }

        // Recalculate - should now prefer 18-19 bin (more recent/additional data)
        await provider.recalculatePersonalizedTime();

        // With 7 at 8am and 7 at 6pm, it depends on which bin has more
        // Since we added 7 more at 18:00, there are now 14 total
        // The 18-19 bin will have 7, 8-9 bin will have 7
        // In case of tie, earliest bin is returned
        // But actually, we're adding 7 more at 18:00 (18-19 bin)
        // So both bins have 7, earliest wins
        // Let's add more at 18:00 to make it the winner
        await storageService.saveWorkoutCompletionTime(
          DateTime(2025, 2, 3, 18, 30),
        );

        await provider.recalculatePersonalizedTime();
        expect(provider.personalizedHour, 18); // 18-19 bin now has 8
      });
    });
  });
}
