import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/core/theme/app_theme.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/main_navigation_wrapper.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/providers/goals_provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/services/app_settings_service.dart';
import 'package:push_up_5050/services/audio_service.dart';
import 'package:push_up_5050/services/haptic_feedback_service.dart';
import 'package:push_up_5050/services/notification_service.dart';
import 'package:push_up_5050/services/proximity_sensor_service.dart';
import 'package:push_up_5050/services/widget_update_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Entry point for Push-Up 5050 app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize StorageService
  final storageService = await StorageService.create();

  // Initialize SharedPreferences for settings
  final sharedPreferences = await SharedPreferences.getInstance();

  // Create and initialize services
  final appSettingsService = AppSettingsService(prefs: sharedPreferences);
  await appSettingsService.loadSettings();

  final hapticService = HapticFeedbackService();

  final audioService = AudioService();
  await audioService.initialize();

  final proximityService = ProximitySensorService();
  await proximityService.initialize();

  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialize widget update service
  final widgetUpdateService = WidgetUpdateService();
  await widgetUpdateService.initialize();

  runApp(
    MultiProvider(
      providers: [
        // StorageService as a provider for dependency injection
        Provider<StorageService>.value(value: storageService),

        // Services
        ChangeNotifierProvider<AppSettingsService>.value(
          value: appSettingsService,
        ),
        Provider<HapticFeedbackService>.value(value: hapticService),
        Provider<AudioService>.value(value: audioService),
        Provider<ProximitySensorService>.value(value: proximityService),
        Provider<NotificationService>.value(value: notificationService),
        Provider<WidgetUpdateService>.value(value: widgetUpdateService),

        // State management providers
        ChangeNotifierProvider(
          create: (_) => UserStatsProvider(
            storage: storageService,
            widgetUpdateService: widgetUpdateService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ActiveWorkoutProvider(
            storage: storageService,
            widgetUpdateService: widgetUpdateService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AchievementsProvider(storage: storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => GoalsProvider(storage: storageService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// Root widget for Push-Up 5050 app.
///
/// Configures:
/// - Dark theme from AppTheme
/// - Localizations support (IT/EN)
/// - Locale based on AppSettingsService
/// - MainNavigationWrapper as home screen
///
/// Wrapped by MultiProvider in main() for state management.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsService>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Push-Up 5050',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          locale: Locale(settings.appLanguage),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MainNavigationWrapper(),
        );
      },
    );
  }
}
