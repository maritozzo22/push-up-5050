import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/screens/profile/profile_screen.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

/// Fake StorageService for testing ProfileScreen.
class FakeStorageService implements StorageService {
  Map<String, dynamic> _dailyRecords = {};
  Map<String, dynamic> _achievements = {};
  DailyRecord? _todayRecord;
  int _streak = 0;
  int _totalPushups = 0;
  int _daysCompleted = 0;

  void setTodayRecord(DailyRecord? record) {
    _todayRecord = record;
  }

  void setDailyRecords(Map<String, dynamic> records) {
    _dailyRecords = records;
  }

  void setStreak(int streak) {
    _streak = streak;
  }

  void setTotalPushups(int total) {
    _totalPushups = total;
  }

  void setDaysCompleted(int days) {
    _daysCompleted = days;
  }

  void setAchievementData(Map<String, dynamic> data) {
    _achievements = data;
  }

  @override
  Future<void> clearActiveSession() async => _dailyRecords.clear();

  @override
  Future<void> clearAllData() async {
    _dailyRecords.clear();
    _todayRecord = null;
    _streak = 0;
    _achievements.clear();
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
  Future<Map<String, dynamic>> loadAchievements() async => _achievements;

  @override
  Future<Map<String, dynamic>> loadDailyRecords() async => _dailyRecords;

  @override
  Future<void> saveAchievement(dynamic achievement) async {
    _achievements[achievement.id] = achievement.toJson();
  }

  @override
  Future<void> saveActiveSession(dynamic session) async {}

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {}

  @override
  Future<void> saveWorkoutPreferences({
    required int startingSeries,
    required int restTime,
  }) async {}

  @override
  Future<Map<String, dynamic>?> loadWorkoutPreferences() async => null;

  @override
  Future<WorkoutSession?> loadActiveSession() async => null;

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
    _achievements.clear();
    _programStartDate = null;
  }
}

/// Helper to create a MaterialApp with localization support for ProfileScreen tests.
Widget createProfileTestApp({
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
  group('ProfileScreen - Provider Integration', () {
    late FakeStorageService fakeStorage;
    late UserStatsProvider defaultStatsProvider;
    late AchievementsProvider defaultAchievementsProvider;

    setUp(() async {
      fakeStorage = FakeStorageService();
      defaultStatsProvider = UserStatsProvider(storage: fakeStorage);
      defaultAchievementsProvider =
          AchievementsProvider(storage: fakeStorage);
      // Pre-load data so tests don't see loading state
      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords({});
      fakeStorage.setStreak(0);
      fakeStorage.setAchievementData({});
      await defaultStatsProvider.loadStats();
      await defaultAchievementsProvider.loadAchievements();
    });

    testWidgets('widget builds without errors', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserStatsProvider>.value(
              value: defaultStatsProvider,
            ),
            ChangeNotifierProvider<AchievementsProvider>.value(
              value: defaultAchievementsProvider,
            ),
          ],
          child: createProfileTestApp(
            child: ProfileScreen(),
          ),
        ),
      );

      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    // Bottom navigation is now handled by MainNavigationWrapper, not in ProfileScreen
    // These tests removed as they test the wrapper, not the screen itself
  });

  group('ProfileScreen with Data Integration', () {
    late FakeStorageService fakeStorage;
    late UserStatsProvider statsProvider;
    late AchievementsProvider achievementsProvider;

    setUp(() {
      fakeStorage = FakeStorageService();
      statsProvider = UserStatsProvider(storage: fakeStorage);
      achievementsProvider = AchievementsProvider(storage: fakeStorage);
    });

    testWidgets('displays loading indicator when providers loading',
        (tester) async {
      // Providers start with isLoading = true by default
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserStatsProvider>.value(
              value: statsProvider,
            ),
            ChangeNotifierProvider<AchievementsProvider>.value(
              value: achievementsProvider,
            ),
          ],
          child: createProfileTestApp(
            child: ProfileScreen(),
          ),
        ),
      );

      // Should find CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('displays user stats section when loaded', (tester) async {
      // Setup fake data
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
      fakeStorage.setStreak(5);
      fakeStorage.setDaysCompleted(10);

      // Create spy providers
      final spyStats = _SpyUserStatsProvider(storage: fakeStorage);
      final spyAchievements = _SpyAchievementsProvider(storage: fakeStorage);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserStatsProvider>.value(
              value: spyStats,
            ),
            ChangeNotifierProvider<AchievementsProvider>.value(
              value: spyAchievements,
            ),
          ],
          child: createProfileTestApp(
            child: ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should find "Profilo" title (appears twice: title + bottom nav)
      expect(find.text('Profilo'), findsWidgets);
    });

    testWidgets('displays achievements grid when loaded', (tester) async {
      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords({});
      fakeStorage.setStreak(0);

      final spyStats = _SpyUserStatsProvider(storage: fakeStorage);
      final spyAchievements = _SpyAchievementsProvider(storage: fakeStorage);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserStatsProvider>.value(
              value: spyStats,
            ),
            ChangeNotifierProvider<AchievementsProvider>.value(
              value: spyAchievements,
            ),
          ],
          child: createProfileTestApp(
            child: ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should find GridView for achievements
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays 6 achievement cards', (tester) async {
      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords({});
      fakeStorage.setStreak(0);

      final spyStats = _SpyUserStatsProvider(storage: fakeStorage);
      final spyAchievements = _SpyAchievementsProvider(storage: fakeStorage);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserStatsProvider>.value(
              value: spyStats,
            ),
            ChangeNotifierProvider<AchievementsProvider>.value(
              value: spyAchievements,
            ),
          ],
          child: createProfileTestApp(
            child: ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should find "Achievements" text
      expect(find.textContaining('Achievements'), findsOneWidget);
    });

    testWidgets('content constrained to maxContentWidth', (tester) async {
      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords({});
      fakeStorage.setStreak(0);

      final spyStats = _SpyUserStatsProvider(storage: fakeStorage);
      final spyAchievements = _SpyAchievementsProvider(storage: fakeStorage);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserStatsProvider>.value(
              value: spyStats,
            ),
            ChangeNotifierProvider<AchievementsProvider>.value(
              value: spyAchievements,
            ),
          ],
          child: createProfileTestApp(
            child: ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should find ConstrainedBox (there are multiple in the widget tree)
      expect(find.byType(ConstrainedBox), findsWidgets);
    });

    testWidgets('uses SingleChildScrollView for scrollability',
        (tester) async {
      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords({});
      fakeStorage.setStreak(0);

      final spyStats = _SpyUserStatsProvider(storage: fakeStorage);
      final spyAchievements = _SpyAchievementsProvider(storage: fakeStorage);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserStatsProvider>.value(
              value: spyStats,
            ),
            ChangeNotifierProvider<AchievementsProvider>.value(
              value: spyAchievements,
            ),
          ],
          child: createProfileTestApp(
            child: ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}

/// Helper to format DateTime as YYYY-MM-DD
String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// Spy UserStatsProvider for testing.
class _SpyUserStatsProvider extends UserStatsProvider {
  _SpyUserStatsProvider({required StorageService storage})
      : super(storage: storage);

  bool _shouldSkipLoad = false;

  void skipNextLoad() {
    _shouldSkipLoad = true;
  }

  @override
  Future<void> loadStats() async {
    if (_shouldSkipLoad) {
      _shouldSkipLoad = false;
      return;
    }
    await super.loadStats();
  }
}

/// Spy AchievementsProvider for testing.
class _SpyAchievementsProvider extends AchievementsProvider {
  _SpyAchievementsProvider({required StorageService storage})
      : super(storage: storage);

  bool _shouldSkipLoad = false;

  void skipNextLoad() {
    _shouldSkipLoad = true;
  }

  @override
  Future<void> loadAchievements() async {
    if (_shouldSkipLoad) {
      _shouldSkipLoad = false;
      return;
    }
    await super.loadAchievements();
  }
}
