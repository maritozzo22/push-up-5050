import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:push_up_5050/models/notification_time_slot.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

// Simple mock SharedPreferences for testing (reused from storage_service_test.dart)
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
  late StorageService storageService;
  late FakePrefs fakePrefs;

  setUp(() {
    fakePrefs = FakePrefs();
    storageService = StorageService.forTesting(fakePrefs);
  });

  group('StorageService - Notification Time Tracking - Phase 03.5', () {
    group('saveWorkoutCompletionTime', () {
      test('should save first workout completion time', () async {
        final timestamp = DateTime(2025, 1, 26, 14, 30);

        await storageService.saveWorkoutCompletionTime(timestamp);

        expect(fakePrefs.containsKey('workout_completion_times'), true);
      });

      test('should maintain last 90 entries', () async {
        // Add 91 workout times
        for (int i = 0; i < 91; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 1).add(Duration(days: i)),
          );
        }

        final times = await storageService.getWorkoutCompletionTimes();

        // Should only have 90 entries (oldest removed)
        expect(times.length, 90);
        // First entry should be day 2, not day 1
        expect(times.first.hour, DateTime(2025, 1, 2).hour);
      });

      test('should append to existing workout times', () async {
        final time1 = DateTime(2025, 1, 26, 8, 0);
        final time2 = DateTime(2025, 1, 27, 9, 0);

        await storageService.saveWorkoutCompletionTime(time1);
        await storageService.saveWorkoutCompletionTime(time2);

        final times = await storageService.getWorkoutCompletionTimes();

        expect(times.length, 2);
        expect(times.first.hour, 8);
        expect(times.last.hour, 9);
      });
    });

    group('getWorkoutCompletionTimes', () {
      test('should return empty list when no data', () async {
        final times = await storageService.getWorkoutCompletionTimes();

        expect(times, isEmpty);
      });

      test('should load saved workout completion times', () async {
        await storageService.saveWorkoutCompletionTime(DateTime(2025, 1, 26, 14, 30));
        await storageService.saveWorkoutCompletionTime(DateTime(2025, 1, 27, 9, 0));

        final times = await storageService.getWorkoutCompletionTimes();

        expect(times.length, 2);
        expect(times.first.hour, 14);
        expect(times.last.hour, 9);
      });

      test('should handle corrupted data gracefully', () async {
        await fakePrefs.setString('workout_completion_times', 'invalid json');

        final times = await storageService.getWorkoutCompletionTimes();

        expect(times, isEmpty);
      });

      test('should deserialize NotificationTimeSlot correctly', () async {
        final timestamp = DateTime(2025, 1, 26, 14, 30);
        await storageService.saveWorkoutCompletionTime(timestamp);

        final times = await storageService.getWorkoutCompletionTimes();

        expect(times.length, 1);
        expect(times.first.hour, 14);
        expect(times.first.minute, 30);
      });
    });

    group('getPersonalizedNotificationTime', () {
      test('should return default (9, 0) when insufficient data (<7)', () async {
        // Add only 6 workout times
        for (int i = 0; i < 6; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 20 + i, 8, 0),
          );
        }

        final (hour, minute) = await storageService.getPersonalizedNotificationTime();

        expect(hour, 9);
        expect(minute, 0);
      });

      test('should return default (9, 0) when no data', () async {
        final (hour, minute) = await storageService.getPersonalizedNotificationTime();

        expect(hour, 9);
        expect(minute, 0);
      });

      test('should return calculated time when sufficient data (>=7)', () async {
        // Add 7 workout times, all in 8-9 hour bin
        for (int i = 0; i < 7; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 20 + i, 8 + (i % 2), 0), // Hours 8, 9, 8, 9, etc.
          );
        }

        final (hour, minute) = await storageService.getPersonalizedNotificationTime();

        // 8-9 bin should be selected (hour 8)
        expect(hour, 8);
        expect(minute, 0);
      });

      test('should return mode hour bin with >=7 data points', () async {
        // 4 workouts in 10-11 bin
        await storageService.saveWorkoutCompletionTime(DateTime(2025, 1, 20, 10, 0));
        await storageService.saveWorkoutCompletionTime(DateTime(2025, 1, 21, 11, 0));
        await storageService.saveWorkoutCompletionTime(DateTime(2025, 1, 22, 10, 30));
        await storageService.saveWorkoutCompletionTime(DateTime(2025, 1, 23, 11, 30));
        // 3 workouts in 14-15 bin
        await storageService.saveWorkoutCompletionTime(DateTime(2025, 1, 24, 14, 0));
        await storageService.saveWorkoutCompletionTime(DateTime(2025, 1, 25, 15, 0));
        await storageService.saveWorkoutCompletionTime(DateTime(2025, 1, 26, 14, 30));

        final (hour, minute) = await storageService.getPersonalizedNotificationTime();

        // 10-11 bin has more workouts
        expect(hour, 10);
        expect(minute, 0);
      });
    });

    group('setPersonalizedNotificationTime', () {
      test('should save manual override hour and minute', () async {
        await storageService.setPersonalizedNotificationTime(14, 30);

        expect(fakePrefs.containsKey('personalized_notification_hour'), true);
        expect(fakePrefs.containsKey('personalized_notification_minute'), true);
      });

      test('should persist manual override across instances', () async {
        await storageService.setPersonalizedNotificationTime(16, 45);

        // Create new instance (simulating app restart)
        final newStorage = StorageService.forTesting(fakePrefs);
        final hour = fakePrefs.getInt('personalized_notification_hour');
        final minute = fakePrefs.getInt('personalized_notification_minute');

        expect(hour, 16);
        expect(minute, 45);
      });

      test('should allow updating override time', () async {
        await storageService.setPersonalizedNotificationTime(10, 0);
        await storageService.setPersonalizedNotificationTime(18, 30);

        final hour = fakePrefs.getInt('personalized_notification_hour');
        final minute = fakePrefs.getInt('personalized_notification_minute');

        expect(hour, 18);
        expect(minute, 30);
      });
    });

    group('Integration - Full Workflow', () {
      test('should track workouts and calculate personalized time', () async {
        // Simulate user working out at 8am most days
        for (int i = 0; i < 10; i++) {
          // 7 workouts at 8am
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 20 + i, 8, 0),
          );
        }

        final (hour, minute) = await storageService.getPersonalizedNotificationTime();

        expect(hour, 8); // 8am is in 8-9 bin
        expect(minute, 0);
      });

      test('should transition from default to personalized time', () async {
        // Start with default (no data)
        final (h1, m1) = await storageService.getPersonalizedNotificationTime();
        expect(h1, 9);

        // Add 6 workouts (still not enough)
        for (int i = 0; i < 6; i++) {
          await storageService.saveWorkoutCompletionTime(
            DateTime(2025, 1, 20 + i, 14, 0),
          );
        }

        final (h2, m2) = await storageService.getPersonalizedNotificationTime();
        expect(h2, 9); // Still default

        // Add 7th workout
        await storageService.saveWorkoutCompletionTime(
          DateTime(2025, 1, 27, 14, 0),
        );

        final (h3, m3) = await storageService.getPersonalizedNotificationTime();
        expect(h3, 14); // Now personalized to 14-15 bin
        expect(m3, 0);
      });
    });
  });
}
