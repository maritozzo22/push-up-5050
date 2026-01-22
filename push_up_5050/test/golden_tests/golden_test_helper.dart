import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/main.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/services/app_settings_service.dart';
import 'package:push_up_5050/services/audio_service.dart';
import 'package:push_up_5050/services/haptic_feedback_service.dart';
import 'package:push_up_5050/services/proximity_sensor_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper function to set up golden tests.
///
/// This initializes:
/// - Flutter test binding
/// - SharedPreferences with mock values
Future<void> setupGoldenTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  // Note: Google Fonts cannot be loaded in tests due to HTTP restrictions.
  // Golden tests will use the default font which is acceptable for testing.
}

/// Load Google Fonts for golden tests.
///
/// This ensures that text is rendered consistently across different platforms
/// and matches the actual app appearance.
Future<void> loadAppFonts() async {
  // Pre-load Montserrat font used throughout the app
  await GoogleFonts.pendingFonts([
    GoogleFonts.montserrat(),
  ]);
}

/// Create a test app widget wrapped with all necessary providers.
///
/// This simulates the real app structure for golden tests.
Future<Widget> createGoldenTestApp({
  required Widget child,
  ActiveWorkoutProvider? workoutProvider,
  UserStatsProvider? statsProvider,
  AchievementsProvider? achievementsProvider,
}) async {
  // Initialize services
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final storageService = await StorageService.create();

  final settingsService = AppSettingsService(prefs: prefs);
  await settingsService.loadSettings();

  final hapticService = HapticFeedbackService();
  // AudioService not initialized in golden tests to avoid blocking on missing assets
  final audioService = AudioService();
  final proximityService = ProximitySensorService();

  // Create providers
  final activeWorkout = workoutProvider ?? ActiveWorkoutProvider(
    storage: storageService,
  );
  final userStats = statsProvider ?? UserStatsProvider(
    storage: storageService,
  );
  final achievements = achievementsProvider ?? AchievementsProvider(
    storage: storageService,
  );

  return MultiProvider(
    providers: [
      Provider<StorageService>.value(value: storageService),
      ChangeNotifierProvider<AppSettingsService>.value(value: settingsService),
      Provider<HapticFeedbackService>.value(value: hapticService),
      Provider<AudioService>.value(value: audioService),
      Provider<ProximitySensorService>.value(value: proximityService),
      ChangeNotifierProvider<ActiveWorkoutProvider>.value(value: activeWorkout),
      ChangeNotifierProvider<UserStatsProvider>.value(value: userStats),
      ChangeNotifierProvider<AchievementsProvider>.value(value: achievements),
    ],
    child: Consumer<AppSettingsService>(
      builder: (context, settings, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale(settings.appLanguage),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF1A1A1A),
          ),
          home: child,
        );
      },
    ),
  );
}

/// Device sizes for golden tests.
///
/// Tests should be run on multiple device sizes to ensure
/// the UI looks good on different screens.
class GoldenDeviceSizes {
  static const iPhoneSE = Size(375, 667);
  static const iPhone12 = Size(390, 844);
  static const AndroidSmall = Size(360, 640);
  static const DesktopSmall = Size(800, 600);
  static const DesktopLarge = Size(1200, 800);
}

/// Common golden test scenarios.
///
/// These scenarios can be reused across different screen tests.
enum GoldenTestScenario {
  empty,
  withData,
  loading,
  error,
}

/// Extension to make golden tests easier to read.
extension GoldenTestExtensions on WidgetTester {
  /// Pump a widget and wait for golden test to settle.
  Future<void> pumpGoldenWidget(
    Widget widget, {
    Duration duration = const Duration(milliseconds: 500),
  }) async {
    await pumpWidget(widget);
    await pumpAndSettle(duration);
  }
}
