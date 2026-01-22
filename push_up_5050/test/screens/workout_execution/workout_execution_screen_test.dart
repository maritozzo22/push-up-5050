import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/screens/workout_execution/workout_execution_screen.dart';
import 'package:push_up_5050/services/app_settings_service.dart';
import 'package:push_up_5050/services/audio_service.dart';
import 'package:push_up_5050/services/haptic_feedback_service.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/widgets/workout/countdown_circle.dart';
import 'package:push_up_5050/widgets/workout/recovery_timer_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper to create a MaterialApp with localization support for WorkoutExecutionScreen tests.
Widget createWorkoutTestApp({
  required Widget child,
  Locale locale = const Locale('it'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  group('WorkoutExecutionScreen', () {
    testWidgets('widget builds without errors', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>(
          create: (_) => ActiveWorkoutProvider(
            storage: FakeStorageService(),
          ),
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );

      expect(find.byType(WorkoutExecutionScreen), findsOneWidget);
    });

    testWidgets('title displays Allenamento in Corso', (tester) async {
      final provider = ActiveWorkoutProvider(
        storage: FakeStorageService(),
      );
      await provider.startWorkout(startingSeries: 1, restTime: 10);

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: provider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );

      expect(find.text('Allenamento in Corso'), findsOneWidget);
    });

    testWidgets('PAUSA button should NOT exist', (tester) async {
      final provider = ActiveWorkoutProvider(
        storage: FakeStorageService(),
      );
      await provider.startWorkout(startingSeries: 1, restTime: 10);

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: provider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PAUSA'), findsNothing);
      expect(find.text('IN PAUSA'), findsNothing);
      expect(find.text('PAUSED'), findsNothing);
    });

    testWidgets('TERMINA button is present and centered', (tester) async {
      final provider = ActiveWorkoutProvider(
        storage: FakeStorageService(),
      );
      await provider.startWorkout(startingSeries: 1, restTime: 10);

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: provider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('TERMINA'), findsOneWidget);
    });

    testWidgets('NO bottom navigation on workout screen', (tester) async {
      final provider = ActiveWorkoutProvider(
        storage: FakeStorageService(),
      );
      await provider.startWorkout(startingSeries: 1, restTime: 10);

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: provider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );

      expect(find.byType(BottomNavigationBar), findsNothing);
    });

    testWidgets('TERMINA button is tappable', (tester) async {
      final fakeStorage = FakeStorageService();
      final provider = ActiveWorkoutProvider(
        storage: fakeStorage,
      );
      await provider.startWorkout(startingSeries: 1, restTime: 10);

      // Create required providers for _handleEndWorkout
      final userStatsProvider = UserStatsProvider(storage: fakeStorage);
      await userStatsProvider.refreshStats();
      final achievementsProvider = AchievementsProvider(storage: fakeStorage);
      await achievementsProvider.loadAchievements();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ActiveWorkoutProvider>.value(
              value: provider,
            ),
            ChangeNotifierProvider<UserStatsProvider>.value(
              value: userStatsProvider,
            ),
            ChangeNotifierProvider<AchievementsProvider>.value(
              value: achievementsProvider,
            ),
          ],
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to make buttons visible
      await tester.dragUntilVisible(
        find.text('TERMINA'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('TERMINA'));
      await tester.pumpAndSettle();

      // Should end session
      expect(provider.session, isNull);
    });

    testWidgets('statistics badges are present as placeholders', (tester) async {
      final provider = ActiveWorkoutProvider(
        storage: FakeStorageService(),
      );
      await provider.startWorkout(startingSeries: 1, restTime: 10);

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: provider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rep Totali: 0'), findsOneWidget);
      expect(find.text('Kcal: 0.0'), findsOneWidget);
    });

    testWidgets('level badge is displayed', (tester) async {
      final provider = ActiveWorkoutProvider(
        storage: FakeStorageService(),
      );
      await provider.startWorkout(startingSeries: 1, restTime: 10);

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: provider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bolt), findsOneWidget);
    });
  });

  group('WorkoutExecutionScreen with ActiveWorkoutProvider Integration', () {
    late FakeStorageService fakeStorage;
    late ActiveWorkoutProvider workoutProvider;

    setUp(() {
      fakeStorage = FakeStorageService();
      workoutProvider = ActiveWorkoutProvider(storage: fakeStorage);
    });

    testWidgets('displays placeholder when no active session', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show "Nessun Allenamento Attivo" placeholder when no session
      expect(find.text('Nessun Allenamento Attivo'), findsOneWidget);
    });

    testWidgets('displays session data when workout is active', (tester) async {
      // Start a workout session
      await workoutProvider.startWorkout(startingSeries: 1, restTime: 10);
      // Count some reps
      workoutProvider.countRep();
      workoutProvider.countRep();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should display real session data
      expect(find.text('Rep Totali: 2'), findsOneWidget);
      expect(find.text('Kcal: 0.9'), findsOneWidget);
    });

    testWidgets('tapping counting circle increments reps', (tester) async {
      await workoutProvider.startWorkout(startingSeries: 5, restTime: 10);

      // Create mock settings and services for this test
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final settingsService = AppSettingsService(prefs: prefs);
      await settingsService.loadSettings();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ActiveWorkoutProvider>.value(
              value: workoutProvider,
            ),
            ChangeNotifierProvider<AppSettingsService>.value(
              value: settingsService,
            ),
            Provider<HapticFeedbackService>.value(
              value: MockHapticFeedbackService(),
            ),
            Provider<AudioService>.value(value: MockAudioService()),
          ],
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initial state
      expect(workoutProvider.session?.repsInCurrentSeries, 0);
      expect(workoutProvider.session?.totalReps, 0);

      // Tap the counting circle
      await tester.tap(find.byType(CountdownCircle));
      await tester.pump();

      // Should have incremented
      expect(workoutProvider.session?.repsInCurrentSeries, 1);
      expect(workoutProvider.session?.totalReps, 1);
    });

    testWidgets('shows recovery timer between series', (tester) async {
      await workoutProvider.startWorkout(startingSeries: 1, restTime: 10);
      // Complete the series
      workoutProvider.countRep();
      // Start recovery
      workoutProvider.startRecovery();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show recovery timer
      expect(find.byType(RecoveryTimerBar), findsOneWidget);
      expect(workoutProvider.isRecovery, true);
    });

    testWidgets('end button saves session and clears provider', (tester) async {
      await workoutProvider.startWorkout(startingSeries: 1, restTime: 10);
      workoutProvider.countRep();
      workoutProvider.countRep();
      workoutProvider.countRep();

      // Create required providers for _handleEndWorkout
      final userStatsProvider = UserStatsProvider(storage: fakeStorage);
      await userStatsProvider.refreshStats();
      final achievementsProvider = AchievementsProvider(storage: fakeStorage);
      await achievementsProvider.loadAchievements();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ActiveWorkoutProvider>.value(
              value: workoutProvider,
            ),
            ChangeNotifierProvider<UserStatsProvider>.value(
              value: userStatsProvider,
            ),
            ChangeNotifierProvider<AchievementsProvider>.value(
              value: achievementsProvider,
            ),
          ],
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify session is active
      expect(workoutProvider.session, isNotNull);
      expect(workoutProvider.session?.totalReps, 3);

      // Scroll to make buttons visible
      await tester.dragUntilVisible(
        find.text('TERMINA'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      await tester.pumpAndSettle();

      // Tap TERMINA button
      await tester.tap(find.text('TERMINA'));
      await tester.pump();

      // Session should be ended
      expect(workoutProvider.session, isNull);
    });
  });

  group('WorkoutExecutionScreen - Service Integration', () {
    late FakeStorageService fakeStorage;
    late ActiveWorkoutProvider workoutProvider;
    late SharedPreferences prefs;
    late AppSettingsService settingsService;
    late MockHapticFeedbackService hapticService;
    late MockAudioService audioService;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    setUp(() async {
      fakeStorage = FakeStorageService();
      workoutProvider = ActiveWorkoutProvider(storage: fakeStorage);
      settingsService = AppSettingsService(prefs: prefs);
      await settingsService.loadSettings();
      hapticService = MockHapticFeedbackService();
      audioService = MockAudioService();
    });

    testWidgets('triggers haptic feedback on count tap when enabled',
        (tester) async {
      // Ensure haptic is enabled
      await settingsService.setHapticFeedbackEnabled(true);

      await workoutProvider.startWorkout(startingSeries: 5, restTime: 10);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ActiveWorkoutProvider>.value(
              value: workoutProvider,
            ),
            ChangeNotifierProvider<AppSettingsService>.value(
              value: settingsService,
            ),
            Provider<HapticFeedbackService>.value(value: hapticService),
            Provider<AudioService>.value(value: audioService),
          ],
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the counting circle to count a rep
      await tester.tap(find.byType(CountdownCircle));
      await tester.pump();

      // Haptic feedback should have been triggered
      expect(hapticService.lightImpactCalled, true);
      expect(hapticService.lightImpactCallCount, 1);
    });

    testWidgets('does NOT trigger haptic when disabled', (tester) async {
      // Disable haptic
      await settingsService.setHapticFeedbackEnabled(false);

      await workoutProvider.startWorkout(startingSeries: 5, restTime: 10);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ActiveWorkoutProvider>.value(
              value: workoutProvider,
            ),
            ChangeNotifierProvider<AppSettingsService>.value(
              value: settingsService,
            ),
            Provider<HapticFeedbackService>.value(value: hapticService),
            Provider<AudioService>.value(value: audioService),
          ],
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the counting circle to count a rep
      await tester.tap(find.byType(CountdownCircle));
      await tester.pump();

      // Haptic feedback should NOT have been triggered
      expect(hapticService.lightImpactCalled, false);
      expect(hapticService.lightImpactCallCount, 0);
    });

    testWidgets('plays beep when recovery timer reaches 0', (tester) async {
      // Enable sounds
      await settingsService.setSoundsEnabled(true);
      await settingsService.setBeepEnabled(true);

      await workoutProvider.startWorkout(startingSeries: 1, restTime: 1);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ActiveWorkoutProvider>.value(
              value: workoutProvider,
            ),
            ChangeNotifierProvider<AppSettingsService>.value(
              value: settingsService,
            ),
            Provider<HapticFeedbackService>.value(value: hapticService),
            Provider<AudioService>.value(value: audioService),
          ],
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Complete the series by tapping the countdown circle
      // This triggers the recovery timer
      await tester.tap(find.byType(CountdownCircle));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Recovery timer starts at 1 second
      // Wait for it to reach 0
      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pump();

      // Beep should have been played when recovery completed
      expect(audioService.beepPlayed, true);
    });

    testWidgets('does NOT play beep when sound disabled', (tester) async {
      // Disable sounds
      await settingsService.setSoundsEnabled(false);

      await workoutProvider.startWorkout(startingSeries: 1, restTime: 1);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ActiveWorkoutProvider>.value(
              value: workoutProvider,
            ),
            ChangeNotifierProvider<AppSettingsService>.value(
              value: settingsService,
            ),
            Provider<HapticFeedbackService>.value(value: hapticService),
            Provider<AudioService>.value(value: audioService),
          ],
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Complete the series by tapping the countdown circle
      await tester.tap(find.byType(CountdownCircle));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pump();

      // Beep should NOT have been played
      expect(audioService.beepPlayed, false);
    });

    testWidgets('does NOT play beep when beep specifically disabled',
        (tester) async {
      // Enable master sound but disable beep
      await settingsService.setSoundsEnabled(true);
      await settingsService.setBeepEnabled(false);

      await workoutProvider.startWorkout(startingSeries: 1, restTime: 1);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ActiveWorkoutProvider>.value(
              value: workoutProvider,
            ),
            ChangeNotifierProvider<AppSettingsService>.value(
              value: settingsService,
            ),
            Provider<HapticFeedbackService>.value(value: hapticService),
            Provider<AudioService>.value(value: audioService),
          ],
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Complete the series by tapping the countdown circle
      await tester.tap(find.byType(CountdownCircle));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pump();

      // Beep should NOT have been played
      expect(audioService.beepPlayed, false);
    });
  });

  group('WorkoutExecutionScreen - I18n', () {
    late FakeStorageService fakeStorage;
    late ActiveWorkoutProvider workoutProvider;

    // Placeholder tests (no session)
    group('Placeholder - No Active Session', () {
      setUp(() {
        fakeStorage = FakeStorageService();
        workoutProvider = ActiveWorkoutProvider(storage: fakeStorage);
      });

      testWidgets('displays noActiveWorkout in Italian', (tester) async {
        await tester.pumpWidget(
          ChangeNotifierProvider<ActiveWorkoutProvider>.value(
            value: workoutProvider,
            child: createWorkoutTestApp(child: const WorkoutExecutionScreen()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Nessun Allenamento Attivo'), findsOneWidget);
      });

      testWidgets('displays noActiveWorkout in English', (tester) async {
        await tester.pumpWidget(
          ChangeNotifierProvider<ActiveWorkoutProvider>.value(
            value: workoutProvider,
            child: createWorkoutTestApp(
              child: const WorkoutExecutionScreen(),
              locale: const Locale('en'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('No Active Workout'), findsOneWidget);
      });

      testWidgets('displays backToHome in Italian', (tester) async {
        await tester.pumpWidget(
          ChangeNotifierProvider<ActiveWorkoutProvider>.value(
            value: workoutProvider,
            child: createWorkoutTestApp(child: const WorkoutExecutionScreen()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Torna alla Home'), findsOneWidget);
      });

      testWidgets('displays backToHome in English', (tester) async {
        await tester.pumpWidget(
          ChangeNotifierProvider<ActiveWorkoutProvider>.value(
            value: workoutProvider,
            child: createWorkoutTestApp(
              child: const WorkoutExecutionScreen(),
              locale: const Locale('en'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Back to Home'), findsOneWidget);
      });
    });

    // Active session tests
    group('Active Session Tests', () {
      setUp(() async {
        fakeStorage = FakeStorageService();
        workoutProvider = ActiveWorkoutProvider(storage: fakeStorage);
        await workoutProvider.startWorkout(startingSeries: 5, restTime: 10);
      });

    testWidgets('displays workoutInProgress in Italian', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(child: const WorkoutExecutionScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Allenamento in Corso'), findsOneWidget);
    });

    testWidgets('displays workoutInProgress in English', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Workout in Progress'), findsOneWidget);
    });

    testWidgets('displays workoutSeriesBadge in Italian', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(child: const WorkoutExecutionScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Serie 5'), findsOneWidget);
    });

    testWidgets('displays workoutSeriesBadge in English', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Series 5'), findsOneWidget);
    });

    testWidgets('displays touchToCount in Italian', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(child: const WorkoutExecutionScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Tocca per Contare'), findsOneWidget);
    });

    testWidgets('displays touchToCount in English', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Tap to Count'), findsOneWidget);
    });

    testWidgets('displays recovery text in Italian', (tester) async {
      // Complete series to trigger recovery
      for (int i = 0; i < 5; i++) {
        workoutProvider.countRep();
      }
      workoutProvider.startRecovery();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(child: const WorkoutExecutionScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Recupero...'), findsOneWidget);
    });

    testWidgets('displays recovery text in English', (tester) async {
      // Complete series to trigger recovery
      for (int i = 0; i < 5; i++) {
        workoutProvider.countRep();
      }
      workoutProvider.startRecovery();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Recovery...'), findsOneWidget);
    });

    testWidgets('displays end button in Italian', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(child: const WorkoutExecutionScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('TERMINA'), findsOneWidget);
    });

    testWidgets('displays end button in English', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('END'), findsOneWidget);
    });

    testWidgets('displays totalRepsLabel in Italian', (tester) async {
      workoutProvider.countRep();
      workoutProvider.countRep();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(child: const WorkoutExecutionScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Rep Totali:'), findsOneWidget);
    });

    testWidgets('displays totalRepsLabel in English', (tester) async {
      workoutProvider.countRep();
      workoutProvider.countRep();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Total Reps:'), findsOneWidget);
    });

    testWidgets('displays kcalLabel in Italian', (tester) async {
      workoutProvider.countRep();
      workoutProvider.countRep();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(child: const WorkoutExecutionScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Kcal:'), findsOneWidget);
    });

    testWidgets('displays kcalLabel in English', (tester) async {
      workoutProvider.countRep();
      workoutProvider.countRep();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createWorkoutTestApp(
            child: const WorkoutExecutionScreen(),
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Kcal:'), findsOneWidget);
    });
    });
  });
}

/// Fake StorageService for testing WorkoutExecutionScreen.
class FakeStorageService implements StorageService {
  Map<String, dynamic> _dailyRecords = {};
  WorkoutSession? _activeSession;
  Map<String, dynamic>? _workoutPreferences;

  void setWorkoutPreferences(Map<String, dynamic>? prefs) {
    _workoutPreferences = prefs;
  }

  @override
  Future<void> clearActiveSession() async {
    _activeSession = null;
  }

  @override
  Future<void> clearAllData() async {
    _dailyRecords.clear();
    _activeSession = null;
    _workoutPreferences = null;
  }

  @override
  Future<void> clearWorkoutPreferences() async {
    _workoutPreferences = null;
  }

  @override
  Future<int> calculateCurrentStreak() async => 0;

  @override
  Future<DailyRecord?> getDailyRecord(DateTime date) async => null;

  @override
  Future<Map<String, dynamic>> getUserStats() async => {};

  @override
  Future<Map<String, dynamic>> loadAchievements() async => {};

  @override
  Future<Map<String, dynamic>> loadDailyRecords() async => _dailyRecords;

  @override
  Future<WorkoutSession?> loadActiveSession() async => _activeSession;

  @override
  Future<Map<String, dynamic>?> loadWorkoutPreferences() async =>
      _workoutPreferences;

  @override
  Future<void> saveAchievement(dynamic achievement) async {}

  @override
  Future<void> saveActiveSession(dynamic session) async {
    _activeSession = session as WorkoutSession?;
  }

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {}

  @override
  Future<void> saveWorkoutPreferences({
    required int startingSeries,
    required int restTime,
  }) async {
    _workoutPreferences = {
      'startingSeries': startingSeries,
      'restTime': restTime,
    };
  }

  DateTime? _programStartDate;

  @override
  Future<DateTime?> getProgramStartDate() async => _programStartDate;

  @override
  Future<void> saveProgramStartDate(DateTime date) async {
    _programStartDate = date;
  }

  @override
  Future<void> clearProgramStartDate() async {
    _programStartDate = null;
  }
}

/// Mock HapticFeedbackService for testing.
class MockHapticFeedbackService implements HapticFeedbackService {
  int lightImpactCallCount = 0;
  bool lightImpactCalled = false;

  @override
  Future<bool> lightImpact() async {
    lightImpactCalled = true;
    lightImpactCallCount++;
    return true;
  }

  @override
  Future<bool> mediumImpact() async => true;

  @override
  Future<bool> heavyImpact() async => true;

  @override
  void dispose() {}

  @override
  bool get isAvailable => true;
}

/// Mock AudioService for testing.
class MockAudioService implements AudioService {
  bool beepPlayed = false;
  int beepCallCount = 0;
  bool achievementPlayed = false;
  bool pushupPlayed = false;
  int pushupCallCount = 0;
  bool goalPlayed = false;

  @override
  Future<bool> initialize() async => true;

  @override
  Future<void> playBeep() async {
    beepPlayed = true;
    beepCallCount++;
  }

  @override
  Future<void> playAchievementSound() async {
    achievementPlayed = true;
  }

  @override
  Future<void> playPushupDone() async {
    pushupPlayed = true;
    pushupCallCount++;
  }

  @override
  Future<void> playGoalAchieved() async {
    goalPlayed = true;
  }

  @override
  Future<void> dispose() async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  bool get soundsEnabled => true;

  @override
  double get volume => 0.5;

  @override
  bool get isAvailable => true;

  @override
  bool get beepEnabled => true;

  @override
  bool get achievementSoundEnabled => true;

  @override
  bool get pushupSoundEnabled => true;

  @override
  bool get goalSoundEnabled => true;

  @override
  Future<void> setBeepEnabled(bool enabled) async {}

  @override
  Future<void> setAchievementSoundEnabled(bool enabled) async {}

  @override
  Future<void> setPushupSoundEnabled(bool enabled) async {}

  @override
  Future<void> setGoalSoundEnabled(bool enabled) async {}

  @override
  Future<void> setSoundsEnabled(bool enabled) async {}
}
