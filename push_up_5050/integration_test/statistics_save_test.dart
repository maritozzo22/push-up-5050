import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:push_up_5050/main.dart' as app;
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

/// Integration test to verify statistics are saved correctly after workout.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Statistics Save Test - After Workout Bug Fix', () {
    testWidgets('endWorkout creates and saves DailyRecord correctly', (tester) async {
      // Create storage service
      final storage = await StorageService.create();

      // Clear any existing data
      await storage.clearAllData();

      // Create provider
      final provider = ActiveWorkoutProvider(storage: storage);

      // Start a workout
      await provider.startWorkout(startingSeries: 1, restTime: 10);

      // Simulate completing 3 series: 1 + 2 + 3 = 6 pushups
      provider.countRep(); // Series 1 complete (1/1)
      provider.advanceToNextSeries(); // Move to series 2

      provider.countRep(); // Series 2: 1/2
      provider.countRep(); // Series 2 complete (2/2)
      provider.advanceToNextSeries(); // Move to series 3

      provider.countRep(); // Series 3: 1/3
      provider.countRep(); // Series 3: 2/3
      provider.countRep(); // Series 3 complete (3/3)
      // Don't advance - test that algorithm handles this

      // Verify session state before ending
      expect(provider.session?.totalReps, 6, reason: 'Should have 6 total reps');
      expect(provider.session?.currentSeries, 3, reason: 'Should be on series 3');

      // End workout - this should create DailyRecord
      await provider.endWorkout();

      // Verify session was cleared
      expect(provider.session, isNull, reason: 'Session should be null after endWorkout');

      // Verify DailyRecord was saved
      final today = DateTime.now();
      final normalizedToday = DateTime(today.year, today.month, today.day);
      final savedRecord = await storage.getDailyRecord(normalizedToday);

      expect(savedRecord, isNotNull, reason: 'DailyRecord should be saved after workout');
      expect(savedRecord!.totalPushups, 6, reason: 'Should have 6 total pushups');
      expect(savedRecord.seriesCompleted, 3, reason: 'Should have 3 completed series (1+2+3=6)');

      print('✅ Test 1 PASSED: Statistics saved correctly after workout!');
      print('   Total Pushups: ${savedRecord.totalPushups}');
      print('   Series Completed: ${savedRecord.seriesCompleted}');

      // Clean up
      await storage.clearAllData();
    });

    testWidgets('multiple workouts accumulate stats correctly', (tester) async {
      final storage = await StorageService.create();
      await storage.clearAllData();

      final today = DateTime.now();
      final normalizedToday = DateTime(today.year, today.month, today.day);

      // First workout: manually save existing record
      await storage.saveDailyRecord(
        DailyRecord(date: normalizedToday, totalPushups: 20, seriesCompleted: 2),
      );

      // Second workout: 3 pushups (completes series 1: 1/1, series 2: 2/2 = 3 total)
      final provider = ActiveWorkoutProvider(storage: storage);
      await provider.startWorkout(startingSeries: 1, restTime: 10);

      provider.countRep(); // Series 1 complete
      provider.advanceToNextSeries();

      provider.countRep(); // Series 2: 1/2
      provider.countRep(); // Series 2 complete
      // Don't advance - just end workout

      await provider.endWorkout();

      // Verify accumulation: existing (20, 2) + new (3, 2) = (23, 4)
      final finalRecord = await storage.getDailyRecord(normalizedToday);

      expect(finalRecord, isNotNull);
      expect(finalRecord!.totalPushups, 23, reason: '20 + 3 = 23 total pushups');
      expect(finalRecord.seriesCompleted, 4, reason: '2 + 2 = 4 series completed');

      print('✅ Test 2 PASSED: Multiple workouts accumulate correctly!');
      print('   Total Pushups: ${finalRecord.totalPushups} (20 + 3)');
      print('   Series Completed: ${finalRecord.seriesCompleted} (2 + 2)');

      // Clean up
      await storage.clearAllData();
    });

    testWidgets('startingSeries affects seriesCompleted calculation', (tester) async {
      final storage = await StorageService.create();
      await storage.clearAllData();

      // Workout starting from series 5, completing 5 pushups (only series 5)
      final provider = ActiveWorkoutProvider(storage: storage);
      await provider.startWorkout(startingSeries: 5, restTime: 10);

      for (int i = 0; i < 5; i++) {
        provider.countRep();
      }

      await provider.endWorkout();

      final today = DateTime.now();
      final normalizedToday = DateTime(today.year, today.month, today.day);
      final savedRecord = await storage.getDailyRecord(normalizedToday);

      expect(savedRecord, isNotNull);
      expect(savedRecord!.totalPushups, 5, reason: 'Should have 5 total pushups');
      expect(savedRecord.seriesCompleted, 1, reason: 'Starting from series 5, 5 reps = 1 series (series 5 only)');

      print('✅ Test 3 PASSED: startingSeries correctly affects calculation!');
      print('   Starting Series: 5');
      print('   Total Pushups: ${savedRecord.totalPushups}');
      print('   Series Completed: ${savedRecord.seriesCompleted}');

      // Clean up
      await storage.clearAllData();
    });

    testWidgets('partial series does not count as completed', (tester) async {
      final storage = await StorageService.create();
      await storage.clearAllData();

      // Workout starting from series 2, doing only 3 pushups
      // Series 2 requires 2, series 3 requires 3
      // 3 reps = series 2 complete (2) + 1 into series 3
      // Result: only 1 series completed
      final provider = ActiveWorkoutProvider(storage: storage);
      await provider.startWorkout(startingSeries: 2, restTime: 10);

      for (int i = 0; i < 3; i++) {
        provider.countRep();
      }

      await provider.endWorkout();

      final today = DateTime.now();
      final normalizedToday = DateTime(today.year, today.month, today.day);
      final savedRecord = await storage.getDailyRecord(normalizedToday);

      expect(savedRecord, isNotNull);
      expect(savedRecord!.totalPushups, 3, reason: 'Should have 3 total pushups');
      expect(savedRecord.seriesCompleted, 1, reason: 'Starting from series 2, 3 reps = 1 series (series 2 only, series 3 partial)');

      print('✅ Test 4 PASSED: Partial series does not count as completed!');
      print('   Starting Series: 2');
      print('   Total Pushups: ${savedRecord.totalPushups}');
      print('   Series Completed: ${savedRecord.seriesCompleted} (series 2 only)');

      // Clean up
      await storage.clearAllData();
    });
  });
}
