import 'package:flutter/foundation.dart';

/// Activity level enum representing user's exercise frequency.
///
/// Used to personalize the workout plan, particularly recovery time
/// recommendations between exercise series.
enum ActivityLevel {
  /// User does little to no exercise
  sedentary,

  /// User exercises 1-3 days per week
  lightlyActive,

  /// User exercises 3-5 days per week
  active,

  /// User exercises 6-7 days per week
  veryActive,
}

/// Data model for collecting user responses during personalized onboarding.
///
/// This model captures user fitness information to personalize the workout
/// experience, including starting series recommendations and recovery time.
///
/// The model is immutable and uses the [copyWith] pattern for updates.
@immutable
class OnboardingData {
  /// User's current activity level
  final ActivityLevel activityLevel;

  /// Maximum number of push-ups user can do in one set
  final int maxCapacity;

  /// Number of workout days per week user plans to exercise
  final int frequencyDays;

  /// Daily push-up goal
  final int dailyGoal;

  const OnboardingData({
    this.activityLevel = ActivityLevel.lightlyActive,
    this.maxCapacity = 20,
    this.frequencyDays = 5,
    this.dailyGoal = 50,
  });

  /// Calculates the recommended starting series based on max capacity.
  ///
  /// The progression is:
  /// - maxCapacity <= 10: start at series 1
  /// - maxCapacity <= 20: start at series 2
  /// - maxCapacity <= 30: start at series 5
  /// - maxCapacity > 30: start at series 10
  int get startingSeries {
    if (maxCapacity <= 10) return 1;
    if (maxCapacity <= 20) return 2;
    if (maxCapacity <= 30) return 5;
    return 10;
  }

  /// Calculates recommended recovery time in seconds based on activity level.
  ///
  /// More active users need less recovery time:
  /// - sedentary: 60 seconds
  /// - lightlyActive: 45 seconds
  /// - active/veryActive: 30 seconds
  int get recoveryTime {
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        return 60;
      case ActivityLevel.lightlyActive:
        return 45;
      case ActivityLevel.active:
      case ActivityLevel.veryActive:
        return 30;
    }
  }

  /// Creates a copy of this data with the given fields replaced.
  OnboardingData copyWith({
    ActivityLevel? activityLevel,
    int? maxCapacity,
    int? frequencyDays,
    int? dailyGoal,
  }) {
    return OnboardingData(
      activityLevel: activityLevel ?? this.activityLevel,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      dailyGoal: dailyGoal ?? this.dailyGoal,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OnboardingData &&
        other.activityLevel == activityLevel &&
        other.maxCapacity == maxCapacity &&
        other.frequencyDays == frequencyDays &&
        other.dailyGoal == dailyGoal;
  }

  @override
  int get hashCode {
    return activityLevel.hashCode ^
        maxCapacity.hashCode ^
        frequencyDays.hashCode ^
        dailyGoal.hashCode;
  }

  @override
  String toString() {
    return 'OnboardingData('
        'activityLevel: $activityLevel, '
        'maxCapacity: $maxCapacity, '
        'frequencyDays: $frequencyDays, '
        'dailyGoal: $dailyGoal, '
        'startingSeries: $startingSeries, '
        'recoveryTime: ${recoveryTime}s)';
  }
}
