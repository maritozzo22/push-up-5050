import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/screens/statistics/statistics_screen.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import '../../test_helpers.dart';

/// Fake StorageService for testing StatisticsScreen.
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
  Future<dynamic> loadActiveSession() async => null;

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
}

void main() {
  group('StatisticsScreen - New Design Tests', () {
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
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StatisticsScreen), findsOneWidget);
    });

    testWidgets('displays STATISTICHE GLOBALI title', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('STATISTICHE GLOBALI'), findsOneWidget);
    });

    testWidgets('displays back button', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('displays TOTALE PUSHUPS card', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('TOTALE PUSHUPS:'), findsOneWidget);
      expect(find.text('0 / 5050'), findsOneWidget);
    });

    testWidgets('displays CALORIE BRUCIATE card', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('CALORIE BRUCIATE:'), findsOneWidget);
    });

    testWidgets('displays weekly progress card', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PROGRESSI SETTIMANALI'), findsOneWidget);
    });

    testWidgets('displays mini stat cards', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('GIORNI CONSECUTIVI'), findsOneWidget);
      expect(find.text('MEDIA GIORNALIERA'), findsOneWidget);
      expect(find.text('MIGLIOR GIORNO'), findsOneWidget);
    });

    testWidgets('displays monthly calendar', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: defaultProvider,
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show weekday labels
      expect(find.text('L'), findsOneWidget);
      expect(find.text('M'), findsWidgets);
    });
  });

  group('StatisticsScreen with UserStatsProvider Integration', () {
    late FakeStorageService fakeStorage;

    setUp(() {
      fakeStorage = FakeStorageService();
    });

    testWidgets('displays loading indicator when isLoading is true',
        (tester) async {
      final statsProvider = UserStatsProvider(storage: fakeStorage);

      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: statsProvider,
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );

      // Should find CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays correct total pushups from provider', (tester) async {
      final today = DateTime.now();
      final recordToday = DailyRecord(
        date: today,
        totalPushups: 100,
        seriesCompleted: 10,
      );

      fakeStorage.setTodayRecord(recordToday);
      fakeStorage.setDailyRecords({
        _formatDate(today): recordToday.toJson(),
      });
      fakeStorage.setStreak(3);

      final statsProvider = UserStatsProvider(storage: fakeStorage);
      await statsProvider.loadStats();

      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: statsProvider,
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show total from provider
      expect(find.text('100 / 5050'), findsOneWidget);
      expect(find.text('2%'), findsOneWidget); // 100/5050 = 1.98% -> 2%
    });

    testWidgets('displays correct calories from pushups', (tester) async {
      final today = DateTime.now();
      final recordToday = DailyRecord(
        date: today,
        totalPushups: 200,
        seriesCompleted: 15,
      );

      fakeStorage.setTodayRecord(recordToday);
      fakeStorage.setDailyRecords({
        _formatDate(today): recordToday.toJson(),
      });
      fakeStorage.setStreak(5);

      final statsProvider = UserStatsProvider(storage: fakeStorage);
      await statsProvider.loadStats();

      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: statsProvider,
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 200 * 0.45 = 90 kcal
      expect(find.text('90 kcal'), findsOneWidget);
    });

    testWidgets('displays correct streak', (tester) async {
      final today = DateTime.now();
      final recordToday = DailyRecord(
        date: today,
        totalPushups: 50,
        seriesCompleted: 5,
      );

      fakeStorage.setTodayRecord(recordToday);
      fakeStorage.setDailyRecords({
        _formatDate(today): recordToday.toJson(),
      });
      fakeStorage.setStreak(7);

      final statsProvider = UserStatsProvider(storage: fakeStorage);
      await statsProvider.loadStats();

      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>.value(
          value: statsProvider,
          child: createTestApp(
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show streak value
      expect(find.text('7'), findsWidgets); // Multiple occurrences
    });

    testWidgets('back button navigates back', (tester) async {
      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords({});
      fakeStorage.setStreak(0);

      final statsProvider = UserStatsProvider(storage: fakeStorage);
      await statsProvider.loadStats();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('it'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChangeNotifierProvider<UserStatsProvider>.value(
            value: statsProvider,
            child: const StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Should navigate back (widget is no longer there)
      expect(find.byType(StatisticsScreen), findsNothing);
    });
  });
}

/// Helper to format DateTime as YYYY-MM-DD
String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
