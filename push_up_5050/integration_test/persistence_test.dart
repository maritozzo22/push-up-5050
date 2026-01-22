import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:push_up_5050/main.dart' as app;
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/models/daily_record.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Persistence Integration Tests', () {
    late StorageService storage;

    setUp(() async {
      // Initialize the app
      app.main();
      // Get real SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();
      // Clear any existing data
      await prefs.clear();
      storage = await StorageService.create();
    });

    testWidgets('Persistence: Save and load workout session', (tester) async {
      // Create and save session
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        currentSeries: 3,
        repsInCurrentSeries: 2,
        totalReps: 6, // 1 + 2 + 3 = 6
      );

      await storage.saveActiveSession(session);

      // Create new storage instance to simulate app restart
      final newStorage = await StorageService.create();
      final loaded = await newStorage.loadActiveSession();

      expect(loaded, isNotNull);
      expect(loaded!.startingSeries, 1);
      expect(loaded.currentSeries, 3);
      expect(loaded.totalReps, 6);
      expect(loaded.restTime, 30);
    });

    testWidgets('Persistence: Save and load daily record', (tester) async {
      final date = DateTime(2025, 1, 14);
      final record = DailyRecord(
        date: date,
        totalPushups: 100,
        seriesCompleted: 10,
      );

      await storage.saveDailyRecord(record);

      // Create new storage instance to simulate app restart
      final newStorage = await StorageService.create();
      final loaded = await newStorage.getDailyRecord(date);

      expect(loaded, isNotNull);
      expect(loaded!.totalPushups, 100);
      expect(loaded.seriesCompleted, 10);
      expect(loaded.goalReached, true);
      expect(loaded.totalKcal, 45.0);
    });

    testWidgets('Persistence: Multiple daily records persist correctly',
        (tester) async {
      final record1 = DailyRecord(
        date: DateTime(2025, 1, 14),
        totalPushups: 100,
        seriesCompleted: 10,
      );
      final record2 = DailyRecord(
        date: DateTime(2025, 1, 15),
        totalPushups: 75,
        seriesCompleted: 8,
      );

      await storage.saveDailyRecord(record1);
      await storage.saveDailyRecord(record2);

      // Create new storage instance
      final newStorage = await StorageService.create();
      final records = await newStorage.loadDailyRecords();

      expect(records.length, 2);
      expect(records['2025-01-14']?['totalPushups'], 100);
      expect(records['2025-01-15']?['totalPushups'], 75);
    });

    testWidgets('Persistence: Session survives storage reset', (tester) async {
      final session = WorkoutSession(
        startingSeries: 5,
        restTime: 60,
        currentSeries: 7,
        repsInCurrentSeries: 3,
        totalReps: 25,
      );

      await storage.saveActiveSession(session);

      // Clear and reload
      await storage.clearActiveSession();

      final loaded = await storage.loadActiveSession();

      expect(loaded, isNull);
    });

    testWidgets('Persistence: Stats calculation from persisted data',
        (tester) async {
      // Create multiple days of data
      await storage.saveDailyRecord(DailyRecord(
        date: DateTime(2025, 1, 14),
        totalPushups: 100,
        seriesCompleted: 10,
      ));
      await storage.saveDailyRecord(DailyRecord(
        date: DateTime(2025, 1, 15),
        totalPushups: 50,
        seriesCompleted: 5,
      ));

      // Create new storage instance
      final newStorage = await StorageService.create();
      final stats = await newStorage.getUserStats();

      expect(stats['totalPushupsAllTime'], 150);
      expect(stats['maxPushupsInOneDay'], 100);
      expect(stats['daysCompleted'], 2);
    });

    testWidgets('Persistence: Clear all data removes everything',
        (tester) async {
      // Add some data
      await storage.saveActiveSession(WorkoutSession(
        startingSeries: 1,
        restTime: 30,
      ));
      await storage.saveDailyRecord(DailyRecord(
        date: DateTime(2025, 1, 14),
        totalPushups: 100,
        seriesCompleted: 10,
      ));

      // Clear all
      await storage.clearAllData();

      // Verify everything is cleared
      final session = await storage.loadActiveSession();
      final records = await storage.loadDailyRecords();

      expect(session, isNull);
      expect(records, isEmpty);
    });
  });
}
