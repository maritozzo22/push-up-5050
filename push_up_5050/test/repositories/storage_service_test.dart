import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

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

  // Not used in our tests
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

  group('StorageService - Active Session', () {
    test('should save workout session correctly', () async {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        currentSeries: 3,
        repsInCurrentSeries: 2,
        totalReps: 5,
      );

      await storageService.saveActiveSession(session);

      expect(fakePrefs.containsKey('active_session'), true);
    });

    test('should load workout session correctly', () async {
      final startTime = DateTime(2025, 1, 14, 10, 0);
      final json = '''
      {
        "startingSeries": 1,
        "restTime": 30,
        "currentSeries": 3,
        "repsInCurrentSeries": 2,
        "totalReps": 5,
        "isPaused": false,
        "isActive": true,
        "startTime": "${startTime.toIso8601String()}"
      }
      ''';

      await fakePrefs.setString('active_session', json);

      final session = await storageService.loadActiveSession();

      expect(session, isNotNull);
      expect(session!.startingSeries, 1);
      expect(session.currentSeries, 3);
      expect(session.totalReps, 5);
      expect(session.restTime, 30);
    });

    test('should return null when no active session', () async {
      final session = await storageService.loadActiveSession();

      expect(session, isNull);
    });

    test('should clear active session correctly', () async {
      await fakePrefs.setString('active_session', 'some json');

      await storageService.clearActiveSession();

      expect(fakePrefs.containsKey('active_session'), false);
    });

    test('should handle corrupted session data gracefully', () async {
      await fakePrefs.setString('active_session', 'invalid json{');

      final session = await storageService.loadActiveSession();

      expect(session, isNull);
      expect(fakePrefs.containsKey('active_session'), false);
    });
  });

  group('StorageService - Daily Record', () {
    test('should save daily record correctly', () async {
      final record = DailyRecord(
        date: DateTime(2025, 1, 14),
        totalPushups: 100,
        seriesCompleted: 10,
      );

      await storageService.saveDailyRecord(record);

      expect(fakePrefs.containsKey('daily_records'), true);
    });

    test('should load all daily records correctly', () async {
      final json = '''
      {
        "2025-01-14": {
          "date": "2025-01-14",
          "totalPushups": 100,
          "seriesCompleted": 10,
          "totalKcal": 45.0,
          "goalReached": true
        },
        "2025-01-15": {
          "date": "2025-01-15",
          "totalPushups": 75,
          "seriesCompleted": 8,
          "totalKcal": 33.75,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      final records = await storageService.loadDailyRecords();

      expect(records, isNotNull);
      expect(records.length, 2);
      expect(records['2025-01-14']?['totalPushups'], 100);
      expect(records['2025-01-15']?['totalPushups'], 75);
    });

    test('should return empty map when no records exist', () async {
      final records = await storageService.loadDailyRecords();

      expect(records, isEmpty);
    });

    test('should get specific daily record by date', () async {
      final date = DateTime(2025, 1, 14);
      final json = '''
      {
        "2025-01-14": {
          "date": "2025-01-14",
          "totalPushups": 100,
          "seriesCompleted": 10,
          "totalKcal": 45.0,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      final record = await storageService.getDailyRecord(date);

      expect(record, isNotNull);
      expect(record!.totalPushups, 100);
      expect(record.goalReached, true);
    });

    test('should return null when specific record not found', () async {
      final date = DateTime(2025, 1, 14);

      final record = await storageService.getDailyRecord(date);

      expect(record, isNull);
    });

    test('should merge new record with existing records', () async {
      final existingJson = '''
      {
        "2025-01-13": {
          "date": "2025-01-13",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', existingJson);

      final newRecord = DailyRecord(
        date: DateTime(2025, 1, 14),
        totalPushups: 100,
        seriesCompleted: 10,
      );

      await storageService.saveDailyRecord(newRecord);

      final records = await storageService.loadDailyRecords();
      expect(records.length, 2);
      expect(records.containsKey('2025-01-13'), true);
      expect(records.containsKey('2025-01-14'), true);
    });

    test('should handle corrupted records data gracefully', () async {
      await fakePrefs.setString('daily_records', 'invalid{json');

      final records = await storageService.loadDailyRecords();

      expect(records, isEmpty);
    });
  });

  group('StorageService - Streak Calculation', () {
    test('should calculate streak from consecutive days', () async {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      final dayBefore = today.subtract(const Duration(days: 2));

      final json = '''
      {
        "${_formatDate(today)}": {
          "date": "${_formatDate(today)}",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        },
        "${_formatDate(yesterday)}": {
          "date": "${_formatDate(yesterday)}",
          "totalPushups": 60,
          "seriesCompleted": 6,
          "totalKcal": 27.0,
          "goalReached": true
        },
        "${_formatDate(dayBefore)}": {
          "date": "${_formatDate(dayBefore)}",
          "totalPushups": 55,
          "seriesCompleted": 5,
          "totalKcal": 24.75,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      final streak = await storageService.calculateCurrentStreak();

      expect(streak, 3);
    });

    test('should break streak on missed day', () async {
      final today = DateTime.now();
      final twoDaysAgo = today.subtract(const Duration(days: 2));

      final json = '''
      {
        "${_formatDate(today)}": {
          "date": "${_formatDate(today)}",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        },
        "${_formatDate(twoDaysAgo)}": {
          "date": "${_formatDate(twoDaysAgo)}",
          "totalPushups": 60,
          "seriesCompleted": 6,
          "totalKcal": 27.0,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      final streak = await storageService.calculateCurrentStreak();

      expect(streak, 1);
    });

    test('should return 0 for no records', () async {
      final streak = await storageService.calculateCurrentStreak();

      expect(streak, 0);
    });

    test('should not count days with less than 50 push-ups', () async {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      final json = '''
      {
        "${_formatDate(today)}": {
          "date": "${_formatDate(today)}",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        },
        "${_formatDate(yesterday)}": {
          "date": "${_formatDate(yesterday)}",
          "totalPushups": 30,
          "seriesCompleted": 3,
          "totalKcal": 13.5,
          "goalReached": false
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      final streak = await storageService.calculateCurrentStreak();

      expect(streak, 1);
    });

    test('should handle today not completed yet', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final dayBefore = DateTime.now().subtract(const Duration(days: 2));

      final json = '''
      {
        "${_formatDate(yesterday)}": {
          "date": "${_formatDate(yesterday)}",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        },
        "${_formatDate(dayBefore)}": {
          "date": "${_formatDate(dayBefore)}",
          "totalPushups": 60,
          "seriesCompleted": 6,
          "totalKcal": 27.0,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      final streak = await storageService.calculateCurrentStreak();

      expect(streak, greaterThanOrEqualTo(2));
    });
  });

  group('StorageService - Achievements', () {
    test('should save achievement unlock status', () async {
      final achievement = Achievement(
        id: 'first_pushup',
        name: 'Primo Passo',
        description: 'Completa il tuo primo push-up',
        points: 50,
        icon: '🎯',
      );
      achievement.unlock();

      await storageService.saveAchievement(achievement);

      expect(fakePrefs.containsKey('achievements'), true);
    });

    test('should load all achievements correctly', () async {
      final now = DateTime.now();
      final json = '''
      {
        "first_pushup": {
          "id": "first_pushup",
          "name": "Primo Passo",
          "description": "Completa il tuo primo push-up",
          "points": 50,
          "icon": "🎯",
          "isUnlocked": true,
          "unlockedAt": "${now.toIso8601String()}"
        }
      }
      ''';

      await fakePrefs.setString('achievements', json);

      final achievements = await storageService.loadAchievements();

      expect(achievements, isNotNull);
      expect(achievements['first_pushup']?['isUnlocked'], true);
    });

    test('should return empty map when no achievements exist', () async {
      final achievements = await storageService.loadAchievements();

      expect(achievements, isEmpty);
    });

    test('should handle corrupted achievements data gracefully', () async {
      await fakePrefs.setString('achievements', 'invalid{json');

      final achievements = await storageService.loadAchievements();

      expect(achievements, isEmpty);
    });
  });

  group('StorageService - User Stats', () {
    test('should calculate all-time totals correctly', () async {
      final json = '''
      {
        "2025-01-14": {
          "date": "2025-01-14",
          "totalPushups": 100,
          "seriesCompleted": 10,
          "totalKcal": 45.0,
          "goalReached": true
        },
        "2025-01-15": {
          "date": "2025-01-15",
          "totalPushups": 75,
          "seriesCompleted": 8,
          "totalKcal": 33.75,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      final stats = await storageService.getUserStats();

      expect(stats['totalPushupsAllTime'], 175);
      expect(stats['maxPushupsInOneDay'], 100);
      expect(stats['daysCompleted'], 2);
    });

    test('should find max push-ups in one day', () async {
      final json = '''
      {
        "2025-01-14": {
          "date": "2025-01-14",
          "totalPushups": 100,
          "seriesCompleted": 10,
          "totalKcal": 45.0,
          "goalReached": true
        },
        "2025-01-15": {
          "date": "2025-01-15",
          "totalPushups": 200,
          "seriesCompleted": 15,
          "totalKcal": 90.0,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      final stats = await storageService.getUserStats();

      expect(stats['maxPushupsInOneDay'], 200);
    });

    test('should count completed days correctly', () async {
      final json = '''
      {
        "2025-01-14": {
          "date": "2025-01-14",
          "totalPushups": 100,
          "seriesCompleted": 10,
          "totalKcal": 45.0,
          "goalReached": true
        },
        "2025-01-15": {
          "date": "2025-01-15",
          "totalPushups": 30,
          "seriesCompleted": 3,
          "totalKcal": 13.5,
          "goalReached": false
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      final stats = await storageService.getUserStats();

      expect(stats['daysCompleted'], 1);
    });

    test('should return zeros when no records exist', () async {
      final stats = await storageService.getUserStats();

      expect(stats['totalPushupsAllTime'], 0);
      expect(stats['maxPushupsInOneDay'], 0);
      expect(stats['daysCompleted'], 0);
      expect(stats['currentStreak'], 0);
    });
  });

  group('StorageService - Clear Data', () {
    test('should clear all data correctly', () async {
      await fakePrefs.setString('active_session', 'some json');
      await fakePrefs.setString('daily_records', 'some json');
      await fakePrefs.setString('achievements', 'some json');

      await storageService.clearAllData();

      expect(fakePrefs.containsKey('active_session'), false);
      expect(fakePrefs.containsKey('daily_records'), false);
      expect(fakePrefs.containsKey('achievements'), false);
    });
  });
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
