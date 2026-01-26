import 'package:push_up_5050/models/notification_time_slot.dart';

/// Utility class for analyzing workout time patterns.
///
/// Calculates personalized notification times based on when users
/// most frequently complete their workouts.
class WorkoutTimeAnalyzer {
  /// Minimum number of workout days required before personalization.
  ///
  /// With fewer than 7 data points, we use the default 9:00 AM time.
  static const int minDataPointsForPersonalization = 7;

  /// Default notification hour when insufficient data (9:00 AM).
  static const int defaultHour = 9;

  /// Default notification minute when insufficient data.
  static const int defaultMinute = 0;

  /// Check if there is sufficient data for personalization.
  ///
  /// Returns true if [workoutTimes] has at least [minDataPointsForPersonalization] entries.
  static bool hasSufficientData(List<NotificationTimeSlot> workoutTimes) {
    return workoutTimes.length >= minDataPointsForPersonalization;
  }

  /// Calculate personalized notification time from workout history.
  ///
  /// Analyzes [workoutTimes] to find the 2-hour window where users most
  /// frequently complete workouts.
  ///
  /// Returns `(hour, minute)` tuple or `null` if insufficient data.
  /// - `hour`: The starting hour of the most popular 2-hour window (0, 2, 4, ... 22)
  /// - `minute`: Always 0 for consistency
  ///
  /// Returns `null` when fewer than 7 workout times are provided.
  static (int hour, int minute)? calculatePersonalizedTime(
    List<NotificationTimeSlot> workoutTimes,
  ) {
    if (!hasSufficientData(workoutTimes)) {
      return null;
    }

    // Count workouts in each 2-hour bin
    final Map<int, int> binCounts = {};

    for (final slot in workoutTimes) {
      final bin = slot.toHourBin();
      binCounts[bin] = (binCounts[bin] ?? 0) + 1;
    }

    // Find the bin with maximum count
    // In case of tie, return the earliest (lowest hour)
    int? maxBin;
    int? maxCount;

    for (final entry in binCounts.entries) {
      if (maxCount == null || entry.value > maxCount) {
        maxCount = entry.value;
        maxBin = entry.key;
      }
    }

    if (maxBin == null) {
      return null;
    }

    // Return the hour bin with 0 minutes for consistency
    return (maxBin, 0);
  }

  /// Get the default notification time.
  ///
  /// Returns (9, 0) for 9:00 AM fallback when insufficient workout data.
  static (int hour, int minute) get defaultTime => (defaultHour, defaultMinute);
}
