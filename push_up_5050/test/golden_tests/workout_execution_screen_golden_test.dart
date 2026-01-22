import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:push_up_5050/screens/workout_execution/workout_execution_screen.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await setupGoldenTests();
  });

  testGoldens('WorkoutExecutionScreen placeholder golden test', (tester) async {
    final storageService = await StorageService.create();
    final workoutProvider = ActiveWorkoutProvider(storage: storageService);
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    final app = await createGoldenTestApp(
      child: const WorkoutExecutionScreen(),
      workoutProvider: workoutProvider,
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(WorkoutExecutionScreen),
      matchesGoldenFile('goldens/workout_placeholder.png'),
    );
  });

  testGoldens('WorkoutExecutionScreen active workout golden test', (tester) async {
    final storageService = await StorageService.create();
    final workoutProvider = ActiveWorkoutProvider(storage: storageService);
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    // Start a workout
    await workoutProvider.startWorkout(startingSeries: 5, restTime: 10);

    final app = await createGoldenTestApp(
      child: const WorkoutExecutionScreen(),
      workoutProvider: workoutProvider,
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(WorkoutExecutionScreen),
      matchesGoldenFile('goldens/workout_active.png'),
    );
  });

  testGoldens('WorkoutExecutionScreen with progress golden test', (tester) async {
    final storageService = await StorageService.create();
    final workoutProvider = ActiveWorkoutProvider(storage: storageService);
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    // Start workout and count some reps
    await workoutProvider.startWorkout(startingSeries: 3, restTime: 10);
    workoutProvider.countRep();
    workoutProvider.countRep();

    final app = await createGoldenTestApp(
      child: const WorkoutExecutionScreen(),
      workoutProvider: workoutProvider,
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(WorkoutExecutionScreen),
      matchesGoldenFile('goldens/workout_progress.png'),
    );
  });
}
