import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/screens/home/home_screen.dart';
import 'package:push_up_5050/widgets/design_system/start_button_circle.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';

/// Fake StorageService for testing HomeScreen.
class FakeStorageService implements StorageService {
  Map<String, dynamic> _dailyRecords = {};
  DailyRecord? _todayRecord;
  int _streak = 0;

  void setTodayRecord(DailyRecord? record) {
    _todayRecord = record;
  }

  void setDailyRecords(Map<String, dynamic> records) {
    _dailyRecords = records;
  }

  void setStreak(int streak) {
    _streak = streak;
  }

  @override
  Future<void> clearActiveSession() async => _dailyRecords.clear();

  @override
  Future<void> clearAllData() async {
    _dailyRecords.clear();
    _todayRecord = null;
    _streak = 0;
  }

  @override
  Future<void> clearWorkoutPreferences() async {}

  @override
  Future<int> calculateCurrentStreak() async => _streak;

  @override
  Future<DailyRecord?> getDailyRecord(DateTime date) async => _todayRecord;

  @override
  Future<Map<String, dynamic>> getUserStats() async => {};

  @override
  Future<Map<String, dynamic>> loadAchievements() async => {};

  @override
  Future<Map<String, dynamic>> loadDailyRecords() async => _dailyRecords;

  @override
  Future<WorkoutSession?> loadActiveSession() async => null;

  @override
  Future<Map<String, dynamic>?> loadWorkoutPreferences() async => null;

  @override
  Future<void> saveAchievement(dynamic achievement) async {}

  @override
  Future<void> saveActiveSession(dynamic session) async {}

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {}

  @override
  Future<void> saveWorkoutPreferences({
    required int startingSeries,
    required int restTime,
  }) async {}

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

  @override
  Future<void> resetAllUserData() async {
    _dailyRecords.clear();
    _todayRecord = null;
    _streak = 0;
    _programStartDate = null;
  }
}

/// Helper to create a MaterialApp with localization support for HomeScreen tests.
Widget createHomeTestApp({
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
  group('HomeScreen - New Design Tests', () {
    late FakeStorageService fakeStorage;
    late UserStatsProvider defaultProvider;

    setUp(() async {
      fakeStorage = FakeStorageService();
      defaultProvider = UserStatsProvider(storage: fakeStorage);
      // Pre-load data so tests don't see loading state
      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords({});
      fakeStorage.setStreak(0);
      await defaultProvider.loadStats();
    });

    testWidgets('widget builds without errors', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createHomeTestApp(
            child: const HomeScreen(),
          ),
        ),
      );

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('title displays PUSHUP 5050', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createHomeTestApp(
            child: const HomeScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('PUSHUP 5050'), findsOneWidget);
    });

    testWidgets('START button is present', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createHomeTestApp(
            child: const HomeScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(StartButtonCircle), findsOneWidget);
      expect(find.text('START'), findsOneWidget);
    });

    testWidgets('START button calls onStartWorkout callback', (tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createHomeTestApp(
            child: HomeScreen(
              onStartWorkout: () => buttonPressed = true,
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(StartButtonCircle));
      await tester.pump();

      expect(buttonPressed, true);
    });

    testWidgets('displays FrostCard widgets', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createHomeTestApp(
            child: const HomeScreen(),
          ),
        ),
      );
      await tester.pump();

      // Should have 3 FrostCards (Today + 2 mini stats)
      expect(find.byType(FrostCard), findsWidgets);
    });

    testWidgets('displays today pushups in FrostCard', (tester) async {
      final today = DateTime.now();
      final recordToday = DailyRecord(
        date: today,
        totalPushups: 25,
        seriesCompleted: 3,
      );

      fakeStorage.setTodayRecord(recordToday);
      fakeStorage.setDailyRecords({'2025-01-14': recordToday.toJson()});
      fakeStorage.setStreak(5);

      await defaultProvider.loadStats();

      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createHomeTestApp(
            child: const HomeScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Today · 25 Pushups'), findsOneWidget);
    });

    testWidgets('displays THIS WEEK and GOAL mini stats', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createHomeTestApp(
            child: const HomeScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('THIS WEEK'), findsOneWidget);
      expect(find.text('GOAL'), findsOneWidget);
      expect(find.text('50'), findsOneWidget); // Goal value
    });

    testWidgets('displays loading state when isLoading is true', (tester) async {
      final loadingProvider = UserStatsProvider(storage: fakeStorage);

      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: loadingProvider,
          child: createHomeTestApp(
            child: const HomeScreen(),
          ),
        ),
      );

      // Should find CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Caricamento...'), findsOneWidget);
    });

    testWidgets('has correct background with AppBackground', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createHomeTestApp(
            child: const HomeScreen(),
          ),
        ),
      );
      await tester.pump();

      // Should have Stack with AppBackground
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('calls loadStats on initState', (tester) async {
      bool loadStatsCalled = false;

      // Create a spy provider
      final spyProvider = _SpyUserStatsProvider(storage: fakeStorage);
      spyProvider.loadStatsOverride = () async {
        loadStatsCalled = true;
      };

      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: spyProvider,
          child: createHomeTestApp(
            child: const HomeScreen(),
          ),
        ),
      );

      // Trigger post frame callbacks (one frame is enough for initState)
      await tester.pump();

      expect(loadStatsCalled, isTrue);
    });
  });

  group('HomeScreen - Data Display', () {
    late FakeStorageService fakeStorage;
    late UserStatsProvider statsProvider;

    setUp(() {
      fakeStorage = FakeStorageService();
      statsProvider = UserStatsProvider(storage: fakeStorage);
    });

    testWidgets('displays correct today pushups count', (tester) async {
      final today = DateTime.now();
      final recordToday = DailyRecord(
        date: today,
        totalPushups: 30,
        seriesCompleted: 4,
      );

      fakeStorage.setTodayRecord(recordToday);
      fakeStorage.setDailyRecords({'2025-01-14': recordToday.toJson()});
      fakeStorage.setStreak(5);

      await statsProvider.loadStats();

      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: statsProvider,
          child: createHomeTestApp(
            child: const HomeScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Today · 30 Pushups'), findsOneWidget);
    });

    testWidgets('displays zero pushups correctly', (tester) async {
      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords({});
      fakeStorage.setStreak(0);

      await statsProvider.loadStats();

      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: statsProvider,
          child: createHomeTestApp(
            child: const HomeScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Today · 0 Pushups'), findsOneWidget);
    });
  });
}

/// Spy UserStatsProvider for testing loadStats calls.
class _SpyUserStatsProvider extends UserStatsProvider {
  _SpyUserStatsProvider({required StorageService storage}) : super(storage: storage);

  Future<void> Function()? loadStatsOverride;

  @override
  Future<void> loadStats() async {
    if (loadStatsOverride != null) {
      await loadStatsOverride!();
    } else {
      await super.loadStats();
    }
  }
}
