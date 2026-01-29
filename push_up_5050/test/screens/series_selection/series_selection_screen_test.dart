import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/screens/series_selection/series_selection_screen.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

/// Helper to create a MaterialApp with localization support for SeriesSelectionScreen tests.
Widget createSeriesSelectionTestApp({
  required Widget child,
}) {
  return MaterialApp(
    locale: const Locale('it'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  late FakeStorageService fakeStorage;
  late ActiveWorkoutProvider workoutProvider;

  setUp(() {
    fakeStorage = FakeStorageService();
    workoutProvider = ActiveWorkoutProvider(storage: fakeStorage);
  });

  group('SeriesSelectionScreen', () {
    testWidgets('widget builds without errors', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );

      expect(find.byType(SeriesSelectionScreen), findsOneWidget);
    });

    testWidgets('back button is present', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );

      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('title displays PUSHUP 5050', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );

      expect(find.text('PUSHUP 5050'), findsOneWidget);
    });

    testWidgets('two config cards are present', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find card titles
      expect(find.text('Serie di Partenza'), findsOneWidget);
      expect(find.text('Tempo di Recupero (secondi)'), findsOneWidget);
    });

    testWidgets('INIZIA ALLENAMENTO button is present', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('INIZIA ALLENAMENTO'), findsOneWidget);
    });

    testWidgets('starting series default value is 1', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1'), findsWidgets);
    });

    testWidgets('rest time default value is 10', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('10'), findsWidgets);
    });

    testWidgets('INIZIA ALLENAMENTO button is tappable', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('INIZIA ALLENAMENTO'));
      await tester.pump();

      // Button is tappable (no error thrown)
      expect(find.text('INIZIA ALLENAMENTO'), findsOneWidget);
    });

    testWidgets('hint texts are displayed', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Progressive Series (e.g., Series 3 = 3 pushups)'),
        findsOneWidget,
      );
      expect(
        find.text('Base 10s, increases with series'),
        findsOneWidget,
      );
    });

    testWidgets('four circular icon buttons are present (+ and - for each card)',
        (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should have 4 InkWell widgets with custom border (circular buttons)
      final inkWellButtons = find.byType(InkWell);
      expect(inkWellButtons, findsAtLeastNWidgets(4));

      // Verify add and remove icons are present
      expect(find.byIcon(Icons.add), findsWidgets);
      expect(find.byIcon(Icons.remove), findsWidgets);
    });
  });

  group('SeriesSelectionScreen with ActiveWorkoutProvider Integration', () {
    testWidgets('loads saved preferences on init', (tester) async {
      // Set saved preferences
      fakeStorage.setWorkoutPreferences({'startingSeries': 5, 'restTime': 30});
      await workoutProvider.loadWorkoutPreferences();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should display saved preferences
      expect(find.text('5'), findsWidgets);
      expect(find.text('30'), findsWidgets);
    });

    testWidgets('displays default values when no saved preferences', (tester) async {
      // No saved preferences
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should display default values
      expect(find.text('1'), findsWidgets);
      expect(find.text('10'), findsWidgets);
    });

    testWidgets('startingSeries value updates on increment', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the plus button for starting series
      final plusButtons = find.byIcon(Icons.add);
      await tester.tap(plusButtons.first);
      await tester.pumpAndSettle();

      // Value should change from 1 to 2
      expect(find.text('2'), findsWidgets);
    });

    testWidgets('restTime value updates on button press', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the plus button for rest time (second card)
      final plusButtons = find.byIcon(Icons.add);
      await tester.tap(plusButtons.at(1));
      await tester.pumpAndSettle();

      // Value should change from 10 to 11
      expect(find.text('11'), findsOneWidget);
    });

    testWidgets('saves preferences when startingSeries changes', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the plus button for starting series
      final plusButtons = find.byIcon(Icons.add);
      await tester.tap(plusButtons.first);
      await tester.pumpAndSettle();

      // Preferences should be saved
      expect(workoutProvider.savedStartingSeries, 2);
      expect(workoutProvider.savedRestTime, 10);
    });

    testWidgets('saves preferences when restTime changes', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the plus button for rest time
      final plusButtons = find.byIcon(Icons.add);
      await tester.tap(plusButtons.at(1));
      await tester.pumpAndSettle();

      // Preferences should be saved
      expect(workoutProvider.savedStartingSeries, 1);
      expect(workoutProvider.savedRestTime, 31);
    });

    testWidgets('calls provider.startWorkout() on INIZIA ALLENAMENTO',
        (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to make sure button is visible
      await tester.dragUntilVisible(
        find.text('INIZIA ALLENAMENTO'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      await tester.pumpAndSettle();

      // Tap the INIZIA ALLENAMENTO button
      await tester.tap(find.text('INIZIA ALLENAMENTO'));
      await tester.pump();

      // Provider should have a session started
      expect(workoutProvider.session, isNotNull);
      expect(workoutProvider.session!.startingSeries, 1);
      expect(workoutProvider.session!.restTime, 10);
      expect(workoutProvider.session!.goalPushups, null); // Default goal is null (no goal)
    });

    testWidgets('button limits are enforced for starting series',
        (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap minus button at minimum value (should be disabled)
      final minusButtons = find.byIcon(Icons.remove);
      await tester.tap(minusButtons.first);
      await tester.pumpAndSettle();

      // Value should still be 1 (can't go below)
      expect(find.text('1'), findsWidgets);

      // Navigate to value 10 (increment by 1 from 1 to 10 range)
      for (int i = 0; i < 9; i++) {
        await tester.tap(find.byIcon(Icons.add).first);
        await tester.pumpAndSettle();
      }

      // At value 10
      expect(find.text('10'), findsWidgets);
    });

    testWidgets('button limits are enforced for rest time', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap minus button to decrease rest time to minimum
      final minusButtons = find.byIcon(Icons.remove);
      for (int i = 0; i < 25; i++) {
        await tester.tap(minusButtons.at(1));
        await tester.pumpAndSettle();
      }

      // Should be at minimum (5)
      expect(find.text('5'), findsOneWidget);
    });
  });

  group('SeriesSelectionScreen - I18n', () {
    late FakeStorageService fakeStorage;
    late ActiveWorkoutProvider workoutProvider;

    setUp(() {
      fakeStorage = FakeStorageService();
      workoutProvider = ActiveWorkoutProvider(storage: fakeStorage);
    });

    testWidgets('displays startingSeries title in Italian', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Serie di Partenza'), findsOneWidget);
    });

    testWidgets('displays startingSeries title in English', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Starting Series'), findsOneWidget);
    });

    testWidgets('displays restTime title in Italian', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tempo di Recupero (secondi)'), findsOneWidget);
    });

    testWidgets('displays restTime title in English', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Recovery Time (seconds)'), findsOneWidget);
    });

    testWidgets('displays progressiveSeriesHint in Italian', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Progressive Series (e.g., Series 3 = 3 pushups)'),
        findsOneWidget,
      );
    });

    testWidgets('displays baseRecoveryHint in Italian', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Base 10s, increases with series'),
        findsOneWidget,
      );
    });
  });

  group('SeriesSelectionScreen - Rest Time Persistence Fix', () {
    testWidgets('restTime persists across sessions', (tester) async {
      // Prima sessione: nessuna preferenza salvata
      fakeStorage.setWorkoutPreferences(null);

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verifica default iniziale
      expect(find.text('10'), findsWidgets);

      // Incrementa il tempo di recupero a 15
      final plusButtons = find.byIcon(Icons.add);
      for (int i = 0; i < 5; i++) {
        await tester.tap(plusButtons.at(1));
        await tester.pumpAndSettle();
      }

      expect(find.text('15'), findsOneWidget);
      expect(workoutProvider.savedRestTime, 15);

      // Verifica che sia stato salvato nello storage
      final savedPrefs = await fakeStorage.loadWorkoutPreferences();
      expect(savedPrefs?['restTime'], 15);

      // Simula riavvio app - crea nuovo provider e carica preferenze
      final newProvider = ActiveWorkoutProvider(storage: fakeStorage);
      await newProvider.loadWorkoutPreferences();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: newProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Dovrebbe mostrare 15, non 10 (default)
      expect(find.text('15'), findsWidgets);
      expect(find.text('10'), findsNothing);
      expect(newProvider.savedRestTime, 15);
    });

    testWidgets('restTime defaults to 10 when no saved preferences',
        (tester) async {
      // Nessuna preferenza salvata
      fakeStorage.setWorkoutPreferences(null);

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Dovrebbe mostrare il default di 10
      expect(find.text('10'), findsWidgets);
    });
  });

  group('SeriesSelectionScreen - Variable Increment 1-99', () {
    testWidgets('increment is +1 from 1 to 10', (tester) async {
      // Set rest time to 58 to avoid conflict with any starting series value (58 is not in sequence)
      fakeStorage.setWorkoutPreferences({'startingSeries': 1, 'restTime': 58});
      await workoutProvider.loadWorkoutPreferences();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final plusButton = find.byIcon(Icons.add).first;

      // 1 → 2 (+1)
      await tester.tap(plusButton);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      // Continua fino a 10
      for (int i = 0; i < 8; i++) {
        await tester.tap(plusButton);
        await tester.pumpAndSettle();
      }
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('increment is +5 from 10 onwards', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final plusButton = find.byIcon(Icons.add).first;

      // Porta a 10
      for (int i = 0; i < 9; i++) {
        await tester.tap(plusButton);
        await tester.pumpAndSettle();
      }

      // 10 → 15 (+5)
      await tester.tap(plusButton);
      await tester.pumpAndSettle();
      expect(find.text('15'), findsOneWidget);

      // 15 → 20 (+5)
      await tester.tap(plusButton);
      await tester.pumpAndSettle();
      expect(find.text('20'), findsOneWidget);
    });

    testWidgets('maximum value is 99', (tester) async {
      fakeStorage.setWorkoutPreferences({'startingSeries': 95, 'restTime': 10});
      await workoutProvider.loadWorkoutPreferences();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final plusButton = find.byIcon(Icons.add).first;
      await tester.tap(plusButton);
      await tester.pumpAndSettle();

      expect(find.text('99'), findsOneWidget);
      // Prossimo tap non fa nulla
      await tester.tap(plusButton);
      await tester.pumpAndSettle();
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('decrement works correctly', (tester) async {
      // Set rest time to 60 to avoid conflict with any starting series value
      fakeStorage.setWorkoutPreferences({'startingSeries': 20, 'restTime': 58});
      await workoutProvider.loadWorkoutPreferences();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final minusButton = find.byIcon(Icons.remove).first;

      // 20 → 15 (-5)
      await tester.tap(minusButton);
      await tester.pumpAndSettle();
      expect(find.text('15'), findsOneWidget);

      // 15 → 10 (-5)
      await tester.tap(minusButton);
      await tester.pumpAndSettle();
      expect(find.text('10'), findsOneWidget);

      // 10 → 9 (-1)
      await tester.tap(minusButton);
      await tester.pumpAndSettle();
      expect(find.text('9'), findsOneWidget);
    });

    testWidgets('minimum value is 1', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final minusButton = find.byIcon(Icons.remove).first;

      // Tenta di decrementare sotto 1
      await tester.tap(minusButton);
      await tester.pumpAndSettle();

      // Dovrebbe rimanere a 1
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('all values in sequence are correct', (tester) async {
      // Set rest time to 58 to avoid conflict with any starting series value (58 is not in sequence)
      fakeStorage.setWorkoutPreferences({'startingSeries': 1, 'restTime': 58});
      await workoutProvider.loadWorkoutPreferences();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final plusButton = find.byIcon(Icons.add).first;

      // Sequenza attesa: 1,2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,99
      final expectedSequence = [
        1, // Starting value (no increment yet)
        2, 3, 4, 5, 6, 7, 8, 9, 10, // +1 increments
        15, 20, 25, 30, 35, 40, 45, 50, 55, 60, // +5 increments
        65, 70, 75, 80, 85, 90, 95, 99 // +5 increments, then +4 to reach 99
      ];

      // First value is already 1
      for (final expected in expectedSequence.skip(1)) {
        await tester.tap(plusButton);
        await tester.pumpAndSettle();
        expect(find.text('$expected'), findsOneWidget,
            reason: 'Expected to find $expected after increment');
      }
    });

    testWidgets('loads and displays saved value 99', (tester) async {
      fakeStorage.setWorkoutPreferences({'startingSeries': 99, 'restTime': 10});
      await workoutProvider.loadWorkoutPreferences();

      await tester.pumpWidget(
        ChangeNotifierProvider<ActiveWorkoutProvider>.value(
          value: workoutProvider,
          child: createSeriesSelectionTestApp(
            child: const SeriesSelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('99'), findsOneWidget);
    });
  });
}

/// Fake StorageService for testing SeriesSelectionScreen.
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
