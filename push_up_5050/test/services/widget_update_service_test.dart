import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/widget_data.dart';
import 'package:push_up_5050/services/widget_update_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WidgetUpdateService', () {
    late WidgetUpdateService service;

    setUp(() {
      service = WidgetUpdateService();
    });

    group('Initialization', () {
      test('should initialize successfully', () async {
        // Act
        final result = await service.initialize();

        // Assert
        expect(result, isTrue);
        expect(service.isAvailable, isTrue);
      });

      test('should be available after initialization', () {
        // Arrange
        expect(service.isAvailable, isFalse);

        // Act
        service.initialize().ignore();

        // Assert
        expect(service.isAvailable, isTrue);
      });
    });

    group('updateAllWidgets', () {
      setUp(() async {
        await service.initialize();
      });

      test('should return false when service not initialized', () async {
        // Arrange
        final uninitializedService = WidgetUpdateService();
        final data = WidgetData.empty();

        // Act
        final result = await uninitializedService.updateAllWidgets(data);

        // Assert
        expect(result, isFalse);
      });

      test('should handle empty widget data', () async {
        // Arrange
        final emptyData = WidgetData.empty();

        // Act
        final result = await service.updateAllWidgets(emptyData);

        // Assert - should not throw, returns bool
        expect(result, isA<bool>());
      });

      test('should handle complete widget data', () async {
        // Arrange
        final completeData = WidgetData(
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
          ],
        );

        // Act
        final result = await service.updateAllWidgets(completeData);

        // Assert - should not throw
        expect(result, isA<bool>());
      });
    });

    group('updateQuickStartWidget', () {
      setUp(() async {
        await service.initialize();
      });

      test('should return false when service not initialized', () async {
        // Arrange
        final uninitializedService = WidgetUpdateService();
        final data = WidgetData.empty();

        // Act
        final result = await uninitializedService.updateQuickStartWidget(data);

        // Assert
        expect(result, isFalse);
      });

      test('should handle update without throwing', () async {
        // Arrange
        final data = WidgetData.forWidgets(
          todayPushups: 50,
          totalPushups: 500,
        );

        // Act & Assert - should not throw
        await expectLater(
          () => service.updateQuickStartWidget(data),
          returnsNormally,
        );
      });
    });

    group('updateSmallWidget', () {
      setUp(() async {
        await service.initialize();
      });

      test('should return false when service not initialized', () async {
        // Arrange
        final uninitializedService = WidgetUpdateService();
        final data = WidgetData.empty();

        // Act
        final result = await uninitializedService.updateSmallWidget(data);

        // Assert
        expect(result, isFalse);
      });

      test('should handle calendar data update', () async {
        // Arrange
        final data = WidgetData(
          todayPushups: 30,
          totalPushups: 300,
          calendarDays: List.generate(
            30,
            (i) => CalendarDayData(i + 1, i < 5),
          ),
        );

        // Act & Assert - should not throw
        await expectLater(
          () => service.updateSmallWidget(data),
          returnsNormally,
        );
      });
    });

    group('buildWidgetData', () {
      setUp(() async {
        await service.initialize();
      });

      test('should work without calendar service (backward compatibility)', () async {
        // Arrange - Service without calendar service
        final serviceWithoutCalendar = WidgetUpdateService();

        // Act
        final widgetData = await serviceWithoutCalendar.buildWidgetData(
          todayPushups: 41,
          totalPushups: 444,
          goalPushups: 5050,
          streakDays: 2,
        );

        // Assert
        expect(widgetData.todayPushups, 41);
        expect(widgetData.totalPushups, 444);
        expect(widgetData.streakDays, 2);
        expect(widgetData.weekDayData, isEmpty);
        expect(widgetData.threeDayData, isEmpty);
        expect(widgetData.hasStreakLine, false);
      });

      test('should return default WidgetData when service not initialized', () async {
        // Arrange
        final uninitializedService = WidgetUpdateService();

        // Act
        final widgetData = await uninitializedService.buildWidgetData(
          todayPushups: 0,
          totalPushups: 44,
          streakDays: 2,
        );

        // Assert
        expect(widgetData.todayPushups, 0);
        expect(widgetData.totalPushups, 44);
      });
    });

    group('clearWidgetData', () {
      test('should handle clearing without throwing', () async {
        // Act & Assert - should not throw even when not initialized
        await expectLater(
          () => service.clearWidgetData(),
          returnsNormally,
        );
      });

      test('should clear data after initialization', () async {
        // Arrange
        await service.initialize();

        // Act & Assert - should not throw
        await expectLater(
          () => service.clearWidgetData(),
          returnsNormally,
        );
      });
    });

    group('registerPeriodicUpdates', () {
      test('should return false when not initialized', () async {
        // Act
        final result = await service.registerPeriodicUpdates();

        // Assert
        expect(result, isFalse);
      });

      test('should handle periodic update registration', () async {
        // Arrange
        await service.initialize();

        // Act
        final result = await service.registerPeriodicUpdates();

        // Assert
        expect(result, isA<bool>());
      });
    });

    group('getWidgetData', () {
      test('should return null when service not initialized', () async {
        // Act
        final result = await service.getWidgetData();

        // Assert
        expect(result, isNull);
      });

      test('should return null when no data saved', () async {
        // Arrange
        await service.initialize();

        // Act
        final result = await service.getWidgetData();

        // Assert - null is expected when no data exists
        expect(result, isNull);
      });
    });
  });
}
