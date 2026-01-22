import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/widget_data.dart';

void main() {
  group('WidgetData', () {
    group('Serialization', () {
      test('should serialize to JSON correctly', () {
        // Arrange
        final data = WidgetData(
          todayPushups: 41,
          totalPushups: 44,
          goalPushups: 5050,
          todayGoalReached: false,
          streakDays: 2,
          lastWorkoutDate: DateTime(2026, 1, 20),
          calendarDays: [
            CalendarDayData(1, true),
            CalendarDayData(2, true),
            CalendarDayData(3, false),
            CalendarDayData(4, false),
            CalendarDayData(5, false),
            CalendarDayData(6, false),
            CalendarDayData(7, false),
          ],
        );

        // Act
        final json = data.toJson();

        // Assert
        expect(json['todayPushups'], 41);
        expect(json['totalPushups'], 44);
        expect(json['goalPushups'], 5050);
        expect(json['todayGoalReached'], false);
        expect(json['streakDays'], 2);
        expect(json['lastWorkoutDate'], '2026-01-20');
        expect(json['calendarDays'], isList);
        expect(json['calendarDays'].length, 7);
      });

      test('should deserialize from JSON correctly', () {
        // Arrange
        final jsonString = '''
        {
          "todayPushups": 41,
          "totalPushups": 44,
          "goalPushups": 5050,
          "todayGoalReached": false,
          "streakDays": 2,
          "lastWorkoutDate": "2026-01-20",
          "calendarDays": [
            {"day": 1, "completed": true},
            {"day": 2, "completed": false}
          ]
        }
        ''';

        // Act
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final data = WidgetData.fromJson(json);

        // Assert
        expect(data.todayPushups, 41);
        expect(data.totalPushups, 44);
        expect(data.goalPushups, 5050);
        expect(data.todayGoalReached, false);
        expect(data.streakDays, 2);
        expect(data.lastWorkoutDate, DateTime(2026, 1, 20));
        expect(data.calendarDays.length, 2);
        expect(data.calendarDays[0].day, 1);
        expect(data.calendarDays[0].completed, true);
        expect(data.calendarDays[1].completed, false);
      });

      test('should handle empty calendar days', () {
        // Arrange
        final json = {
          'todayPushups': 0,
          'totalPushups': 0,
          'goalPushups': 5050,
          'todayGoalReached': false,
          'streakDays': 0,
          'lastWorkoutDate': null,
          'calendarDays': <Map<String, dynamic>>[],
        };

        // Act
        final data = WidgetData.fromJson(json);

        // Assert
        expect(data.todayPushups, 0);
        expect(data.totalPushups, 0);
        expect(data.calendarDays, isEmpty);
        expect(data.lastWorkoutDate, isNull);
      });

      test('should serialize and deserialize preserving all data', () {
        // Arrange
        final original = WidgetData(
          todayPushups: 50,
          totalPushups: 1500,
          goalPushups: 5050,
          todayGoalReached: true,
          streakDays: 5,
          lastWorkoutDate: DateTime(2026, 1, 15),
          calendarDays: List.generate(
            30,
            (i) => CalendarDayData(i + 1, i < 5),
          ),
        );

        // Act
        final json = original.toJson();
        final restored = WidgetData.fromJson(json);

        // Assert
        expect(restored.todayPushups, original.todayPushups);
        expect(restored.totalPushups, original.totalPushups);
        expect(restored.goalPushups, original.goalPushups);
        expect(restored.todayGoalReached, original.todayGoalReached);
        expect(restored.streakDays, original.streakDays);
        expect(
          restored.lastWorkoutDate?.toIso8601String(),
          original.lastWorkoutDate?.toIso8601String(),
        );
        expect(restored.calendarDays.length, original.calendarDays.length);
        for (var i = 0; i < original.calendarDays.length; i++) {
          expect(
            restored.calendarDays[i].day,
            original.calendarDays[i].day,
          );
          expect(
            restored.calendarDays[i].completed,
            original.calendarDays[i].completed,
          );
        }
      });
    });

    group('CalendarDayData', () {
      test('should serialize to JSON correctly', () {
        // Arrange
        final dayData = CalendarDayData(15, true);

        // Act
        final json = dayData.toJson();

        // Assert
        expect(json['day'], 15);
        expect(json['completed'], true);
      });

      test('should deserialize from JSON correctly', () {
        // Arrange
        final json = {'day': 20, 'completed': false};

        // Act
        final dayData = CalendarDayData.fromJson(json);

        // Assert
        expect(dayData.day, 20);
        expect(dayData.completed, false);
      });
    });

    group('Factory Methods', () {
      test('should create empty WidgetData', () {
        // Act
        final empty = WidgetData.empty();

        // Assert
        expect(empty.todayPushups, 0);
        expect(empty.totalPushups, 0);
        expect(empty.goalPushups, 5050);
        expect(empty.todayGoalReached, false);
        expect(empty.streakDays, 0);
        expect(empty.lastWorkoutDate, isNull);
        expect(empty.calendarDays, isEmpty);
      });

      test('should create WidgetData for widgets', () {
        // Act
        final widgetData = WidgetData.forWidgets(
          todayPushups: 41,
          totalPushups: 44,
          streakDays: 2,
          lastWorkoutDate: DateTime(2026, 1, 20),
          calendarDays: [
            CalendarDayData(1, true),
            CalendarDayData(2, true),
          ],
        );

        // Assert
        expect(widgetData.todayPushups, 41);
        expect(widgetData.totalPushups, 44);
        expect(widgetData.goalPushups, 5050); // Default goal
        expect(widgetData.todayGoalReached, false); // 41 < 50
        expect(widgetData.streakDays, 2);
        expect(widgetData.calendarDays.length, 2);
      });
    });

    group('Computed Properties', () {
      test('should calculate todayGoalReached correctly', () {
        // Arrange & Act
        final notReached = WidgetData(
          todayPushups: 41,
          totalPushups: 44,
          goalPushups: 5050,
        );
        final reached = WidgetData(
          todayPushups: 50,
          totalPushups: 500,
          goalPushups: 5050,
        );
        final exceeded = WidgetData(
          todayPushups: 75,
          totalPushups: 600,
          goalPushups: 5050,
        );

        // Assert
        expect(notReached.todayGoalReached, false);
        expect(reached.todayGoalReached, true);
        expect(exceeded.todayGoalReached, true);
      });
    });
  });
}
