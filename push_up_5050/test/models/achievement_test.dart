import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/achievement.dart';

void main() {
  group('Achievement', () {
    test('should create achievement with default values', () {
      final achievement = Achievement(
        id: 'test_1',
        name: 'Test Achievement',
        description: 'Test description',
        points: 100,
        icon: '🎯',
      );

      expect(achievement.id, 'test_1');
      expect(achievement.name, 'Test Achievement');
      expect(achievement.description, 'Test description');
      expect(achievement.points, 100);
      expect(achievement.icon, '🎯');
      expect(achievement.isUnlocked, false);
      expect(achievement.unlockedAt, isNull);
      expect(achievement.condition, isNull);
    });

    test('should unlock achievement', () {
      final achievement = Achievement(
        id: 'test_1',
        name: 'Test Achievement',
        description: 'Test description',
        points: 100,
        icon: '🎯',
      );

      expect(achievement.isUnlocked, false);

      achievement.unlock();

      expect(achievement.isUnlocked, true);
      expect(achievement.unlockedAt, isNotNull);
    });

    test('should not unlock achievement twice', () {
      final achievement = Achievement(
        id: 'test_1',
        name: 'Test Achievement',
        description: 'Test description',
        points: 100,
        icon: '🎯',
      );

      final firstUnlockTime = DateTime(2025, 1, 14, 10, 0);
      achievement.unlock();
      achievement.unlockedAt = firstUnlockTime;

      // Try to unlock again
      achievement.unlock();

      expect(achievement.isUnlocked, true);
      expect(achievement.unlockedAt, firstUnlockTime); // Unchanged
    });

    test('should check unlock condition with stats', () {
      final achievement = Achievement(
        id: 'first_pushup',
        name: 'First Push-up',
        description: 'Complete your first push-up',
        points: 50,
        icon: '🎯',
        condition: (stats) {
          return (stats['totalPushups'] as int) >= 1;
        },
      );

      expect(achievement.isUnlocked, false);

      // Check with insufficient stats
      final result1 = achievement.checkUnlock({'totalPushups': 0});
      expect(result1, false);
      expect(achievement.isUnlocked, false);

      // Check with sufficient stats
      final result2 = achievement.checkUnlock({'totalPushups': 1});
      expect(result2, true);
      expect(achievement.isUnlocked, true);
      expect(achievement.unlockedAt, isNotNull);
    });

    test('should not unlock when already unlocked', () {
      final achievement = Achievement(
        id: 'test_1',
        name: 'Test Achievement',
        description: 'Test description',
        points: 100,
        icon: '🎯',
        condition: (stats) => true,
      );

      achievement.unlock();
      final firstUnlockTime = achievement.unlockedAt;

      // Try to unlock via condition check
      achievement.checkUnlock({});

      expect(achievement.unlockedAt, firstUnlockTime);
    });

    test('should return false when checking unlock without condition', () {
      final achievement = Achievement(
        id: 'test_1',
        name: 'Test Achievement',
        description: 'Test description',
        points: 100,
        icon: '🎯',
      );

      final result = achievement.checkUnlock({});
      expect(result, false);
      expect(achievement.isUnlocked, false);
    });

    test('should get all predefined achievements', () {
      final achievements = Achievement.getAllAchievements();

      expect(achievements.length, 6);

      // Check first achievement
      final first = achievements[0];
      expect(first.id, 'first_pushup');
      expect(first.name, 'Primo Passo');
      expect(first.points, 50);
      expect(first.icon, '🎯');
      expect(first.isUnlocked, false);

      // Check all IDs are unique
      final ids = achievements.map((a) => a.id).toSet();
      expect(ids.length, 6);
    });

    test('should serialize to JSON correctly', () {
      final achievement = Achievement(
        id: 'test_1',
        name: 'Test Achievement',
        description: 'Test description',
        points: 100,
        icon: '🎯',
        isUnlocked: true,
        unlockedAt: DateTime(2025, 1, 14, 10, 0),
      );

      final json = achievement.toJson();

      expect(json['id'], 'test_1');
      expect(json['name'], 'Test Achievement');
      expect(json['description'], 'Test description');
      expect(json['points'], 100);
      expect(json['icon'], '🎯');
      expect(json['isUnlocked'], true);
      expect(json['unlockedAt'], '2025-01-14T10:00:00.000');
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'test_1',
        'name': 'Test Achievement',
        'description': 'Test description',
        'points': 100,
        'icon': '🎯',
        'isUnlocked': true,
        'unlockedAt': '2025-01-14T10:00:00.000',
      };

      final achievement = Achievement.fromJson(json);

      expect(achievement.id, 'test_1');
      expect(achievement.name, 'Test Achievement');
      expect(achievement.description, 'Test description');
      expect(achievement.points, 100);
      expect(achievement.icon, '🎯');
      expect(achievement.isUnlocked, true);
      expect(achievement.unlockedAt, DateTime(2025, 1, 14, 10, 0));
    });

    test('should handle null unlockedAt in deserialization', () {
      final json = {
        'id': 'test_1',
        'name': 'Test Achievement',
        'description': 'Test description',
        'points': 100,
        'icon': '🎯',
        'isUnlocked': false,
        'unlockedAt': null,
      };

      final achievement = Achievement.fromJson(json);

      expect(achievement.isUnlocked, false);
      expect(achievement.unlockedAt, isNull);
    });

    test('should predefined achievements have correct conditions', () {
      final achievements = Achievement.getAllAchievements();

      // first_pushup: totalPushups >= 1
      final first = achievements.firstWhere((a) => a.id == 'first_pushup');
      expect(
        first.condition!({'totalPushups': 0}),
        false,
      );
      expect(
        first.condition!({'totalPushups': 1}),
        true,
      );

      // ten_in_a_row: maxRepsInOneSeries >= 10
      final ten = achievements.firstWhere((a) => a.id == 'ten_in_a_row');
      expect(
        ten.condition!({'maxRepsInOneSeries': 9}),
        false,
      );
      expect(
        ten.condition!({'maxRepsInOneSeries': 10}),
        true,
      );

      // centenary: totalPushupsAllTime >= 100
      final centenary = achievements.firstWhere((a) => a.id == 'centenary');
      expect(
        centenary.condition!({'totalPushupsAllTime': 99}),
        false,
      );
      expect(
        centenary.condition!({'totalPushupsAllTime': 100}),
        true,
      );

      // perfect_week: currentStreak >= 7
      final week = achievements.firstWhere((a) => a.id == 'perfect_week');
      expect(
        week.condition!({'currentStreak': 6}),
        false,
      );
      expect(
        week.condition!({'currentStreak': 7}),
        true,
      );

      // marathon: maxPushupsInOneDay >= 500
      final marathon = achievements.firstWhere((a) => a.id == 'marathon');
      expect(
        marathon.condition!({'maxPushupsInOneDay': 499}),
        false,
      );
      expect(
        marathon.condition!({'maxPushupsInOneDay': 500}),
        true,
      );

      // lion_month: daysCompleted >= 30
      final lion = achievements.firstWhere((a) => a.id == 'lion_month');
      expect(
        lion.condition!({'daysCompleted': 29}),
        false,
      );
      expect(
        lion.condition!({'daysCompleted': 30}),
        true,
      );
    });
  });
}
