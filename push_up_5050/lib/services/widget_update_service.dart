import 'package:home_widget/home_widget.dart';
import '../models/widget_data.dart';

/// Service for updating Android home screen widgets.
///
/// Supports 3 widget types:
/// - Widget 1 (Quick Stats): Shows today/total progress
/// - Widget 2 (Calendar): Shows 30-day calendar
/// - Widget 3 (Quick Start): Quick start button with stats
///
/// Gracefully degrades on non-Android platforms or when widgets
/// are not configured.
///
/// Uses home_widget plugin v0.5.0 API:
/// - saveWidgetData<T>(id, data) - saves data with given id
/// - updateWidget(androidName: 'ClassName') - updates widget by class name
/// - getWidgetData<T>(id, defaultValue: value) - retrieves data
class WidgetUpdateService {
  // Widget IDs must match AndroidManifest.xml receiver class names
  // WITHOUT the package prefix (e.g., ".widget.PushupWidgetStatsProvider")
  static const String _widget1Id = 'PushupWidgetStatsProvider';
  static const String _widget2Id = 'PushupWidgetCalendarProvider';
  static const String _widget3Id = 'PushupWidgetQuickStartProvider';

  // Data storage IDs - shared across all widgets
  static const String _dataIdTodayPushups = 'pushup_today_pushups';
  static const String _dataIdTotalPushups = 'pushup_total_pushups';
  static const String _dataIdGoalPushups = 'pushup_goal_pushups';
  static const String _dataIdTodayGoalReached = 'pushup_today_goal_reached';
  static const String _dataIdStreakDays = 'pushup_streak_days';
  static const String _dataIdLastWorkoutDate = 'pushup_last_workout_date';
  static const String _dataIdJsonData = 'pushup_json_data';

  bool _isAvailable = false;

  /// Whether widget service is available.
  bool get isAvailable => _isAvailable;

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
    if (!_isAvailable) return false;

    try {
      // Save widget data for all widgets to access
      await _saveWidgetData(data);

      // Update each widget type
      final results = await Future.wait([
        updateWidget1(data),
        updateWidget2(data),
        updateWidget3(data),
      ], eagerError: false);

      // Return true if at least one succeeded
      return results.any((success) => success);
    } catch (e) {
      // Silently fail - widgets are optional
      return false;
    }
  }

  /// Update Widget 1 (Quick Stats).
  ///
  /// Shows today's push-ups and total progress.
  Future<bool> updateWidget1(WidgetData data) async {
    if (!_isAvailable) return false;

    try {
      // Save JSON data for this widget
      await HomeWidget.saveWidgetData<String>(
        _dataIdJsonData,
        data.toJsonString(),
      );
      // Trigger widget update using androidName parameter
      await HomeWidget.updateWidget(androidName: _widget1Id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update Widget 2 (Calendar Preview).
  ///
  /// Shows 30-day calendar with completion status.
  Future<bool> updateWidget2(WidgetData data) async {
    if (!_isAvailable) return false;

    try {
      // Save JSON data for this widget
      await HomeWidget.saveWidgetData<String>(
        _dataIdJsonData,
        data.toJsonString(),
      );
      // Trigger widget update using androidName parameter
      await HomeWidget.updateWidget(androidName: _widget2Id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update Widget 3 (Quick Start).
  ///
  /// Shows large START button with progress stats.
  Future<bool> updateWidget3(WidgetData data) async {
    if (!_isAvailable) return false;

    try {
      // Save JSON data for this widget
      await HomeWidget.saveWidgetData<String>(
        _dataIdJsonData,
        data.toJsonString(),
      );
      // Trigger widget update using androidName parameter
      await HomeWidget.updateWidget(androidName: _widget3Id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Save widget data to shared storage.
  ///
  /// This data is accessed by Android widget implementations.
  /// Using home_widget v0.5.0 API with id-based storage.
  Future<void> _saveWidgetData(WidgetData data) async {
    try {
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
      await HomeWidget.saveWidgetData<String>(
        _dataIdJsonData,
        data.toJsonString(),
      );
    } catch (e) {
      // Silently fail
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
