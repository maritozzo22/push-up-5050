import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:push_up_5050/models/daily_record.dart';
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

  group('StorageService - Goal Completion Popup Tracking', () {
    test('should return null when popup never shown', () async {
      final lastShown = await storageService.getGoalPopupLastShown();

      expect(lastShown, isNull);
    });

    test('should store today date when popup is marked as shown', () async {
      final today = DateTime.now();
      final expectedDate = _formatDate(today);

      await storageService.setGoalPopupShownToday();
      final lastShown = await storageService.getGoalPopupLastShown();

      expect(lastShown, equals(expectedDate));
    });

    test('should return false when goal is not complete', () async {
      // No daily record exists - goal not complete
      final shouldShow = await storageService.shouldShowGoalCompletionPopup();

      expect(shouldShow, false);
    });

    test('should return false when goal not reached (insufficient pushups)', () async {
      final today = DateTime.now();
      final json = '''
      {
        "${_formatDate(today)}": {
          "date": "${_formatDate(today)}",
          "totalPushups": 25,
          "seriesCompleted": 3,
          "totalKcal": 11.25,
          "goalReached": false
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      final shouldShow = await storageService.shouldShowGoalCompletionPopup();

      expect(shouldShow, false);
    });

    test('should return true when goal complete and not shown today', () async {
      final today = DateTime.now();
      final json = '''
      {
        "${_formatDate(today)}": {
          "date": "${_formatDate(today)}",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      final shouldShow = await storageService.shouldShowGoalCompletionPopup();

      expect(shouldShow, true);
    });

    test('should return false when already shown today', () async {
      final today = DateTime.now();
      final json = '''
      {
        "${_formatDate(today)}": {
          "date": "${_formatDate(today)}",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);
      await storageService.setGoalPopupShownToday();

      final shouldShow = await storageService.shouldShowGoalCompletionPopup();

      expect(shouldShow, false);
    });

    test('showAndMark should return true and mark as shown', () async {
      final today = DateTime.now();
      final json = '''
      {
        "${_formatDate(today)}": {
          "date": "${_formatDate(today)}",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);

      // First call should return true
      final shouldShow1 = await storageService.showAndMarkGoalCompletionPopup();
      expect(shouldShow1, true);

      // Second call should return false (already marked)
      final shouldShow2 = await storageService.showAndMarkGoalCompletionPopup();
      expect(shouldShow2, false);
    });

    test('showAndMark should return false when goal not complete', () async {
      // No daily record
      final shouldShow = await storageService.showAndMarkGoalCompletionPopup();

      expect(shouldShow, false);
    });

    test('should reset tracking at midnight (new day)', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final today = DateTime.now();

      // Set up yesterday's record with goal completed
      final yesterdayJson = '''
      {
        "${_formatDate(yesterday)}": {
          "date": "${_formatDate(yesterday)}",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', yesterdayJson);

      // Mark as shown for yesterday
      await fakePrefs.setString(
        'goal_popup_last_shown',
        _formatDate(yesterday),
      );

      // Set up today's record with goal completed
      final todayJson = '''
      {
        "${_formatDate(yesterday)}": {
          "date": "${_formatDate(yesterday)}",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        },
        "${_formatDate(today)}": {
          "date": "${_formatDate(today)}",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', todayJson);

      // Should show again because last shown was yesterday
      final shouldShow = await storageService.shouldShowGoalCompletionPopup();

      expect(shouldShow, true);
    });

    test('should not show popup for yesterday goal completion (no today record)', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      // Only yesterday's record exists
      final yesterdayJson = '''
      {
        "${_formatDate(yesterday)}": {
          "date": "${_formatDate(yesterday)}",
          "totalPushups": 50,
          "seriesCompleted": 5,
          "totalKcal": 22.5,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', yesterdayJson);

      // Should not show because today's goal is not complete (no today record)
      final shouldShow = await storageService.shouldShowGoalCompletionPopup();

      expect(shouldShow, false);
    });

    test('should work with custom daily goal', () async {
      final today = DateTime.now();
      final json = '''
      {
        "${_formatDate(today)}": {
          "date": "${_formatDate(today)}",
          "totalPushups": 75,
          "seriesCompleted": 7,
          "totalKcal": 33.75,
          "goalReached": true
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);
      await fakePrefs.setInt('daily_goal', 75); // Custom goal

      final shouldShow = await storageService.shouldShowGoalCompletionPopup();

      expect(shouldShow, true);
    });

    test('should check custom daily goal correctly', () async {
      final today = DateTime.now();
      final json = '''
      {
        "${_formatDate(today)}": {
          "date": "${_formatDate(today)}",
          "totalPushups": 60,
          "seriesCompleted": 6,
          "totalKcal": 27.0,
          "goalReached": false
        }
      }
      ''';

      await fakePrefs.setString('daily_records', json);
      await fakePrefs.setInt('daily_goal', 75); // Higher goal than completed

      final shouldShow = await storageService.shouldShowGoalCompletionPopup();

      expect(shouldShow, false); // 60 < 75
    });
  });
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
