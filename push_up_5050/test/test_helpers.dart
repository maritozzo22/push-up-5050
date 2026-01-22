import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/services/app_settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fake StorageService for testing.
///
/// Implements all StorageService methods with in-memory storage
/// that is isolated per test instance.
class FakeStorageService implements StorageService {
  Map<String, dynamic> _dailyRecords = {};
  DailyRecord? _todayRecord;
  int _streak = 0;
  Map<String, dynamic>? _workoutPreferences;
  DateTime? _programStartDate;

  // Setters for test configuration
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
  Future<void> clearWorkoutPreferences() async {
    _workoutPreferences = null;
  }

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
  Future<Map<String, dynamic>?> loadWorkoutPreferences() async =>
      _workoutPreferences;

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
  }) async {
    _workoutPreferences = {
      'startingSeries': startingSeries,
      'restTime': restTime,
    };
  }

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
    _workoutPreferences = null;
    _programStartDate = null;
  }
}

/// Creates a test widget with all required providers wrapped in MaterialApp.
///
/// Wraps the child widget with:
/// - FakeStorageService for isolated storage
/// - UserStatsProvider
/// - ActiveWorkoutProvider
/// - AchievementsProvider
/// - AppSettingsService (for locale support)
/// - MaterialApp with localization support
///
/// Usage for widgets that need a full MaterialApp:
/// ```dart
/// await tester.pumpWidget(
///   createTestApp(child: const MyWidget()),
/// );
/// ```
Widget createTestApp({
  required Widget child,
  UserStatsProvider? userStatsProvider,
  ActiveWorkoutProvider? activeWorkoutProvider,
  AchievementsProvider? achievementsProvider,
}) {
  final storage = FakeStorageService();

  return MultiProvider(
    providers: [
      Provider<StorageService>.value(value: storage),
      ChangeNotifierProvider<UserStatsProvider>(
        create: (_) => userStatsProvider ?? UserStatsProvider(storage: storage),
      ),
      ChangeNotifierProvider<ActiveWorkoutProvider>(
        create: (_) =>
            activeWorkoutProvider ?? ActiveWorkoutProvider(storage: storage),
      ),
      ChangeNotifierProvider<AchievementsProvider>(
        create: (_) =>
            achievementsProvider ?? AchievementsProvider(storage: storage),
      ),
    ],
    child: Builder(
      builder: (context) {
        return MaterialApp(
          locale: const Locale('it'), // Default to Italian
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        );
      },
    ),
  );
}

/// Creates a test widget with all required providers (NO MaterialApp wrapper).
///
/// Use this when the child widget already contains MaterialApp (like MyApp).
///
/// Usage:
/// ```dart
/// await tester.pumpWidget(
///   createTestAppWithProviders(child: const MyApp()),
/// );
/// ```
Future<Widget> createTestAppWithProviders({
  required Widget child,
  UserStatsProvider? userStatsProvider,
  ActiveWorkoutProvider? activeWorkoutProvider,
  AchievementsProvider? achievementsProvider,
  String appLanguage = 'it', // Default to Italian
}) async {
  // Initialize SharedPreferences for testing
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  final storage = FakeStorageService();

  // Create and initialize AppSettingsService
  final settingsService = AppSettingsService(prefs: prefs);
  await settingsService.loadSettings();
  // Set the language for testing
  await settingsService.setAppLanguage(appLanguage);

  return MultiProvider(
    providers: [
      Provider<StorageService>.value(value: storage),
      ChangeNotifierProvider<AppSettingsService>.value(
        value: settingsService,
      ),
      ChangeNotifierProvider<UserStatsProvider>(
        create: (_) => userStatsProvider ?? UserStatsProvider(storage: storage),
      ),
      ChangeNotifierProvider<ActiveWorkoutProvider>(
        create: (_) =>
            activeWorkoutProvider ?? ActiveWorkoutProvider(storage: storage),
      ),
      ChangeNotifierProvider<AchievementsProvider>(
        create: (_) =>
            achievementsProvider ?? AchievementsProvider(storage: storage),
      ),
    ],
    child: Builder(
      builder: (context) {
        return Consumer<AppSettingsService>(
          builder: (context, settings, _) {
            return MaterialApp(
              locale: Locale(settings.appLanguage),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: child,
            );
          },
        );
      },
    ),
  );
}
