import 'package:flutter/foundation.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/utils/workout_time_analyzer.dart';

/// Provider for notification time preferences.
///
/// Manages personalized notification time settings based on user workout patterns.
/// Tracks when users complete workouts to calculate optimal notification times.
class NotificationPreferencesProvider extends ChangeNotifier {
  final StorageService _storage;

  /// Personalized notification hour (0-23).
  int _personalizedHour = 9;

  /// Personalized notification minute (0-59).
  int _personalizedMinute = 0;

  /// Whether provider is currently loading data.
  bool _isLoading = false;

  /// Cached workout completion times.
  List<void> _workoutTimes = [];

  /// Create a new NotificationPreferencesProvider.
  ///
  /// Requires a [StorageService] instance for data persistence.
  NotificationPreferencesProvider({
    required StorageService storage,
  }) : _storage = storage;

  /// Get the personalized notification hour.
  int get personalizedHour => _personalizedHour;

  /// Get the personalized notification minute.
  int get personalizedMinute => _personalizedMinute;

  /// Whether the provider is currently loading data.
  bool get isLoading => _isLoading;

  /// Get the formatted time string.
  ///
  /// Returns "H:MM" format (e.g., "9:00", "14:30").
  String get formattedTime => "$_personalizedHour:${_personalizedMinute.toString().padLeft(2, '0')}";

  /// Load notification preferences from storage.
  ///
  /// Loads the personalized notification time, either:
  /// - From manually set preferences (user override)
  /// - From calculated time based on workout history
  /// - Default (9:00) when no data available
  ///
  /// Notifies listeners after loading completes.
  Future<void> loadPreferences() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Try to load personalized time from storage
      // This returns (hour, minute) based on workout history or default
      final (hour, minute) = await _storage.getPersonalizedNotificationTime();

      _personalizedHour = hour;
      _personalizedMinute = minute;
    } catch (e) {
      // On error, use default values
      _personalizedHour = WorkoutTimeAnalyzer.defaultHour;
      _personalizedMinute = WorkoutTimeAnalyzer.defaultMinute;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update the personalized notification time.
  ///
  /// Allows users to manually override the calculated personalized time.
  /// This is useful for users who want notifications at a specific time
  /// regardless of their workout patterns.
  ///
  /// Use case: Settings screen time picker.
  ///
  /// Notifies listeners after the update.
  Future<void> updatePersonalizedTime(int hour, int minute) async {
    _personalizedHour = hour;
    _personalizedMinute = minute;

    // Save to storage for manual override
    await _storage.setPersonalizedNotificationTime(hour, minute);

    notifyListeners();
  }

  /// Recalculate the personalized notification time from workout history.
  ///
  /// Re-runs the [WorkoutTimeAnalyzer] calculation on the current workout times.
  /// Updates the personalized time if the calculation differs from the current value.
  ///
  /// Called weekly (e.g., from StatisticsScreen on Sunday) to update
  /// notification times as user patterns change.
  ///
  /// Notifies listeners after recalculation.
  Future<void> recalculatePersonalizedTime() async {
    try {
      // Get the current calculated time based on workout history
      final calculated = await _storage.getPersonalizedNotificationTime();

      // Only update if different (avoid unnecessary notifications)
      if (calculated.$1 != _personalizedHour || calculated.$2 != _personalizedMinute) {
        _personalizedHour = calculated.$1;
        _personalizedMinute = calculated.$2;

        // Save the new calculated time
        await _storage.setPersonalizedNotificationTime(
          calculated.$1,
          calculated.$2,
        );

        notifyListeners();
      }
    } catch (e) {
      // On error, keep current values
      debugPrint('Error recalculating personalized time: $e');
    }
  }
}
