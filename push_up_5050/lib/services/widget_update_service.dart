import 'dart:developer' as developer;
import 'package:home_widget/home_widget.dart';
import '../models/widget_data.dart';
import 'widget_calendar_service.dart';

/// Service for updating Android home screen widgets.
///
/// Supports 2 widget types (enabled in AndroidManifest.xml):
/// - Quick Start Widget: Large widget with START button and day indicators
/// - Small Stats Widget: Compact widget with only today/total stats
///
/// Gracefully degrades on non-Android platforms or when widgets
/// are not configured.
///
/// Uses home_widget plugin v0.9.0 API:
/// - saveWidgetData<T>(id, data) - saves data with given id
/// - updateWidget(androidName: 'ClassName') - updates widget by class name
/// - getWidgetData<T>(id, defaultValue: value) - retrieves data
///
/// Calendar integration: When [WidgetCalendarService] is provided,
/// widget data includes week calendar data and 3-day view data.
class WidgetUpdateService {
  // Widget IDs must match AndroidManifest.xml receiver class names
  // WITHOUT the package prefix (e.g., ".widget.PushupWidgetQuickStartProvider")

  // Quick Start Widget (large, with START button and day indicators)
  static const String _quickStartWidgetId = 'PushupWidgetQuickStartProvider';

  // Small Stats Widget (compact, stats only)
  static const String _smallWidgetId = 'PushupWidgetSmallProvider';

  // Data storage IDs - shared across all widgets
  static const String _dataIdTodayPushups = 'pushup_today_pushups';
  static const String _dataIdTotalPushups = 'pushup_total_pushups';
  static const String _dataIdGoalPushups = 'pushup_goal_pushups';
  static const String _dataIdTodayGoalReached = 'pushup_today_goal_reached';
  static const String _dataIdStreakDays = 'pushup_streak_days';
  static const String _dataIdLastWorkoutDate = 'pushup_last_workout_date';
  static const String _dataIdJsonData = 'pushup_json_data';

  /// Optional calendar service for providing week and 3-day calendar data
  final WidgetCalendarService? _calendarService;

  bool _isAvailable = false;

  /// Create a new WidgetUpdateService.
  ///
  /// The [calendarService] is optional - when provided, widgets will
  /// receive enriched calendar data (week view, 3-day view, streak lines).
  /// When null, widgets will use basic fallback data.
  WidgetUpdateService({WidgetCalendarService? calendarService})
      : _calendarService = calendarService;

  /// Whether widget service is available.
  bool get isAvailable => _isAvailable;

  /// Build widget data with calendar information.
  ///
  /// Creates [WidgetData] populated with stats and calendar information.
  /// When [_calendarService] is available, includes:
  /// - Week data (7 days Monday-Sunday)
  /// - Three-day data (Yesterday, Today, Tomorrow)
  /// - Streak line flag for visual display
  ///
  /// When calendar service is null, uses fallback empty calendar data.
  ///
  /// Parameters:
  /// - [todayPushups]: Push-ups completed today
  /// - [totalPushups]: Total push-ups all time
  /// - [goalPushups]: Daily goal (default 5050)
  /// - [streakDays]: Current consecutive days with goal reached
  /// - [allDailyRecords]: All daily records for calendar processing (optional, for backward compatibility)
  Future<WidgetData> buildWidgetData({
    required int todayPushups,
    required int totalPushups,
    int goalPushups = 5050,
    int streakDays = 0,
    DateTime? lastWorkoutDate,
    Map<String, dynamic>? allDailyRecords,
  }) async {
    // If calendar service is available, get calendar data
    if (_calendarService != null) {
      try {
        final weekData = await _calendarService!.getWeekData();
        final threeDayData = await _calendarService!.getThreeDayData();

        return WidgetData.withCalendarData(
          todayPushups: todayPushups,
          totalPushups: totalPushups,
          goalPushups: goalPushups,
          streakDays: streakDays,
          lastWorkoutDate: lastWorkoutDate,
          weekData: weekData,
          threeDayData: threeDayData,
        );
      } catch (e) {
        developer.log('Error getting calendar data, using fallback: $e',
            name: 'WidgetUpdateService');
        // Fall through to return basic widget data
      }
    }

    // Fallback: return widget data without calendar enrichment
    return WidgetData(
      todayPushups: todayPushups,
      totalPushups: totalPushups,
      goalPushups: goalPushups,
      streakDays: streakDays,
      lastWorkoutDate: lastWorkoutDate,
      calendarDays: const [], // Empty for backward compatibility
      weekDayData: const [],
      threeDayData: const [],
      hasStreakLine: false,
    );
  }

  /// Initialize widget service.
  ///
  /// Returns true if widgets are supported (Android), false otherwise.
  Future<bool> initialize() async {
    try {
      // Check if we're on Android
      _isAvailable = true; // home_widget handles platform checks
      return _isAvailable;
    } catch (e) {
      // Widget service unavailable - gracefully degrade
      _isAvailable = false;
      return false;
    }
  }

  /// Update all widgets with latest data.
  ///
  /// Returns true if at least one widget was updated successfully.
  Future<bool> updateAllWidgets(WidgetData data) async {
    if (!_isAvailable) {
      developer.log('Widget service not available', name: 'WidgetUpdateService');
      return false;
    }

    try {
      developer.log('Updating widgets: today=${data.todayPushups}, total=${data.totalPushups}, streak=${data.streakDays}', name: 'WidgetUpdateService');

      // Save widget data for all widgets to access
      await _saveWidgetData(data);
      developer.log('Widget data saved to SharedPreferences', name: 'WidgetUpdateService');

      // Update each enabled widget type
      final results = await Future.wait([
        updateQuickStartWidget(data),
        updateSmallWidget(data),
      ], eagerError: false);

      developer.log('Widget update results: $results', name: 'WidgetUpdateService');

      // Return true if at least one succeeded
      return results.any((success) => success);
    } catch (e) {
      developer.log('Error updating widgets: $e', name: 'WidgetUpdateService', error: e);
      // Silently fail - widgets are optional
      return false;
    }
  }

  /// Update Quick Start Widget (large with START button and day indicators).
  ///
  /// Shows today's push-ups, total progress, streak days, and START button.
  Future<bool> updateQuickStartWidget(WidgetData data) async {
    if (!_isAvailable) return false;

    try {
      developer.log('Updating QuickStart widget ($_quickStartWidgetId)', name: 'WidgetUpdateService');
      // Trigger widget update using androidName parameter
      await HomeWidget.updateWidget(androidName: _quickStartWidgetId);
      developer.log('QuickStart widget updated successfully', name: 'WidgetUpdateService');
      return true;
    } catch (e) {
      developer.log('Failed to update QuickStart widget: $e', name: 'WidgetUpdateService', error: e);
      return false;
    }
  }

  /// Update Small Stats Widget (compact, stats only).
  ///
  /// Shows only today's and total push-ups - no START button, no day buttons.
  Future<bool> updateSmallWidget(WidgetData data) async {
    if (!_isAvailable) return false;

    try {
      developer.log('Updating Small widget ($_smallWidgetId)', name: 'WidgetUpdateService');
      // Trigger widget update using androidName parameter
      await HomeWidget.updateWidget(androidName: _smallWidgetId);
      developer.log('Small widget updated successfully', name: 'WidgetUpdateService');
      return true;
    } catch (e) {
      developer.log('Failed to update Small widget: $e', name: 'WidgetUpdateService', error: e);
      return false;
    }
  }

  /// Save widget data to shared storage.
  ///
  /// This data is accessed by Android widget implementations.
  /// Using home_widget v0.9.0 API with id-based storage.
  Future<void> _saveWidgetData(WidgetData data) async {
    try {
      developer.log('Saving widget data...', name: 'WidgetUpdateService');
      final jsonString = data.toJsonString();
      developer.log('JSON data: $jsonString', name: 'WidgetUpdateService');

      await HomeWidget.saveWidgetData<String>(
        _dataIdJsonData,
        jsonString,
      );
      developer.log('Saved JSON data with key: $_dataIdJsonData', name: 'WidgetUpdateService');

      await HomeWidget.saveWidgetData<String>(
        _dataIdTodayPushups,
        data.todayPushups.toString(),
      );
      await HomeWidget.saveWidgetData<String>(
        _dataIdTotalPushups,
        data.totalPushups.toString(),
      );
      await HomeWidget.saveWidgetData<String>(
        _dataIdGoalPushups,
        data.goalPushups.toString(),
      );
      await HomeWidget.saveWidgetData<String>(
        _dataIdTodayGoalReached,
        data.todayGoalReached.toString(),
      );
      await HomeWidget.saveWidgetData<String>(
        _dataIdStreakDays,
        data.streakDays.toString(),
      );
      await HomeWidget.saveWidgetData<String>(
        _dataIdLastWorkoutDate,
        data.lastWorkoutDate != null
            ? '${data.lastWorkoutDate!.year}-${data.lastWorkoutDate!.month.toString().padLeft(2, '0')}-${data.lastWorkoutDate!.day.toString().padLeft(2, '0')}'
            : '',
      );
      developer.log('All widget data saved successfully', name: 'WidgetUpdateService');
    } catch (e) {
      developer.log('Error saving widget data: $e', name: 'WidgetUpdateService', error: e);
    }
  }

  /// Get current widget data from storage.
  Future<WidgetData?> getWidgetData() async {
    if (!_isAvailable) return null;

    try {
      final jsonData = await HomeWidget.getWidgetData<String>(
        _dataIdJsonData,
        defaultValue: null,
      );
      if (jsonData != null && jsonData.isNotEmpty) {
        return WidgetData.fromJsonString(jsonData);
      }
    } catch (e) {
      // Return null on error
    }
    return null;
  }

  /// Clear all widget data.
  Future<void> clearWidgetData() async {
    if (!_isAvailable) return;

    try {
      await HomeWidget.saveWidgetData<String>(_dataIdTodayPushups, '0');
      await HomeWidget.saveWidgetData<String>(_dataIdTotalPushups, '0');
      await HomeWidget.saveWidgetData<String>(_dataIdGoalPushups, '5050');
      await HomeWidget.saveWidgetData<String>(_dataIdTodayGoalReached, 'false');
      await HomeWidget.saveWidgetData<String>(_dataIdStreakDays, '0');
      await HomeWidget.saveWidgetData<String>(_dataIdLastWorkoutDate, '');
      await HomeWidget.saveWidgetData<String>(_dataIdJsonData, '');
    } catch (e) {
      // Silently fail
    }
  }

  /// Register periodic widget updates (Android only).
  ///
  /// Requests updates every 30 minutes to keep widgets fresh.
  Future<bool> registerPeriodicUpdates() async {
    if (!_isAvailable) return false;

    try {
      // home_widget handles periodic updates via background tasks
      // This is a placeholder for future periodic update implementation
      return true;
    } catch (e) {
      return false;
    }
  }
}
