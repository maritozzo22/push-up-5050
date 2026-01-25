/// WidgetData model
/// Encapsulates data for Android home screen widgets
/// Supports 3 widget types: Quick Stats, Calendar, Quick Start
library;

import 'dart:convert';
import 'package:push_up_5050/services/widget_calendar_service.dart';

/// Calendar day data for widget calendar display
class CalendarDayData {
  /// Day number (1-31)
  final int day;

  /// Whether workout was completed on this day
  final bool completed;

  const CalendarDayData(
    this.day,
    this.completed,
  );

  /// Create from JSON
  factory CalendarDayData.fromJson(Map<String, dynamic> json) {
    return CalendarDayData(
      json['day'] as int,
      json['completed'] as bool,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'completed': completed,
    };
  }

  @override
  String toString() => 'CalendarDayData(day: $day, completed: $completed)';
}

/// Widget data model for Android home screen widgets
/// Contains all information needed by the 3 widget types:
/// - Widget 1 (Quick Stats): today/total progress
/// - Widget 2 (Calendar): calendar day statuses
/// - Widget 3 (Quick Start): quick start button + progress
class WidgetData {
  /// Push-ups completed today
  final int todayPushups;

  /// Total push-ups completed overall
  final int totalPushups;

  /// Goal push-ups (default 5050)
  final int goalPushups;

  /// Whether today's goal of 50 push-ups was reached
  final bool todayGoalReached;

  /// Current streak of consecutive days with >=50 push-ups
  final int streakDays;

  /// Total points earned across all workout sessions
  final int totalPoints;

  /// Date of last workout session
  final DateTime? lastWorkoutDate;

  /// Calendar day data for last 30 days (legacy, for backward compatibility)
  final List<CalendarDayData> calendarDays;

  /// Week calendar data for new widget design (7 days, Monday-Sunday)
  /// Serialized as List<Map<String, dynamic>> for JSON compatibility
  final List<Map<String, dynamic>> weekDayData;

  /// Three-day data for small widget (Yesterday, Today, Tomorrow)
  /// Serialized as List<Map<String, dynamic>> for JSON compatibility
  final List<Map<String, dynamic>> threeDayData;

  /// Whether the week has 2+ consecutive completed days (for streak line display)
  final bool hasStreakLine;

  const WidgetData({
    required this.todayPushups,
    required this.totalPushups,
    this.goalPushups = 5050,
    bool? todayGoalReached,
    this.streakDays = 0,
    this.totalPoints = 0,
    this.lastWorkoutDate,
    this.calendarDays = const [],
    this.weekDayData = const [],
    this.threeDayData = const [],
    this.hasStreakLine = false,
  }) : todayGoalReached = todayGoalReached ??
            (todayPushups >= 50); // Auto-calculate if not provided

  /// Create empty widget data (default state)
  factory WidgetData.empty() {
    return const WidgetData(
      todayPushups: 0,
      totalPushups: 0,
      goalPushups: 5050,
      todayGoalReached: false,
      streakDays: 0,
      totalPoints: 0,
      lastWorkoutDate: null,
      calendarDays: [],
      weekDayData: [],
      threeDayData: [],
      hasStreakLine: false,
    );
  }

  /// Create widget data with defaults for easy widget population
  factory WidgetData.forWidgets({
    required int todayPushups,
    required int totalPushups,
    int goalPushups = 5050,
    int streakDays = 0,
    int totalPoints = 0,
    DateTime? lastWorkoutDate,
    List<CalendarDayData> calendarDays = const [],
    List<Map<String, dynamic>> weekDayData = const [],
    List<Map<String, dynamic>> threeDayData = const [],
    bool hasStreakLine = false,
  }) {
    return WidgetData(
      todayPushups: todayPushups,
      totalPushups: totalPushups,
      goalPushups: goalPushups,
      streakDays: streakDays,
      totalPoints: totalPoints,
      lastWorkoutDate: lastWorkoutDate,
      calendarDays: calendarDays,
      weekDayData: weekDayData,
      threeDayData: threeDayData,
      hasStreakLine: hasStreakLine,
    );
  }

  /// Create widget data with calendar data from WidgetCalendarService
  factory WidgetData.withCalendarData({
    required int todayPushups,
    required int totalPushups,
    int goalPushups = 5050,
    int streakDays = 0,
    int totalPoints = 0,
    DateTime? lastWorkoutDate,
    List<CalendarDayData> calendarDays = const [],
    required WeekData weekData,
    required List<WeekDayData> threeDayData,
  }) {
    return WidgetData(
      todayPushups: todayPushups,
      totalPushups: totalPushups,
      goalPushups: goalPushups,
      streakDays: streakDays,
      totalPoints: totalPoints,
      lastWorkoutDate: lastWorkoutDate,
      calendarDays: calendarDays,
      weekDayData: weekData.days.map((d) => d.toJson()).toList(),
      threeDayData: threeDayData.map((d) => d.toJson()).toList(),
      hasStreakLine: weekData.hasStreakLine,
    );
  }

  /// Serialize to JSON
  /// Date format: YYYY-MM-DD
  Map<String, dynamic> toJson() {
    return {
      'todayPushups': todayPushups,
      'totalPushups': totalPushups,
      'goalPushups': goalPushups,
      'todayGoalReached': todayGoalReached,
      'streakDays': streakDays,
      'totalPoints': totalPoints,
      'lastWorkoutDate': lastWorkoutDate != null
          ? '${lastWorkoutDate!.year}-${lastWorkoutDate!.month.toString().padLeft(2, '0')}-${lastWorkoutDate!.day.toString().padLeft(2, '0')}'
          : null,
      'calendarDays':
          calendarDays.map((day) => day.toJson()).toList(),
      'weekDayData': weekDayData,
      'threeDayData': threeDayData,
      'hasStreakLine': hasStreakLine,
    };
  }

  /// Deserialize from JSON
  /// Date format: YYYY-MM-DD
  factory WidgetData.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) return null;
      final parts = dateString.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }

    final calendarDaysList = json['calendarDays'] as List?;
    final calendarDays = calendarDaysList?.map((item) {
      return CalendarDayData.fromJson(item as Map<String, dynamic>);
    }).toList() ?? [];

    // Parse new calendar fields with proper defaults for backward compatibility
    final weekDayDataList = json['weekDayData'] as List?;
    final weekDayData = weekDayDataList?.cast<Map<String, dynamic>>() ?? [];

    final threeDayDataList = json['threeDayData'] as List?;
    final threeDayData = threeDayDataList?.cast<Map<String, dynamic>>() ?? [];

    final hasStreakLine = json['hasStreakLine'] as bool? ?? false;

    return WidgetData(
      todayPushups: json['todayPushups'] as int? ?? 0,
      totalPushups: json['totalPushups'] as int? ?? 0,
      goalPushups: json['goalPushups'] as int? ?? 5050,
      todayGoalReached: json['todayGoalReached'] as bool? ?? false,
      streakDays: json['streakDays'] as int? ?? 0,
      totalPoints: json['totalPoints'] as int? ?? 0, // Backward compatible
      lastWorkoutDate: parseDate(json['lastWorkoutDate'] as String?),
      calendarDays: calendarDays,
      weekDayData: weekDayData,
      threeDayData: threeDayData,
      hasStreakLine: hasStreakLine,
    );
  }

  /// Serialize to JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Deserialize from JSON string
  static WidgetData fromJsonString(String jsonString) {
    return WidgetData.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }

  /// Create copy with optional field updates
  WidgetData copyWith({
    int? todayPushups,
    int? totalPushups,
    int? goalPushups,
    bool? todayGoalReached,
    int? streakDays,
    int? totalPoints,
    DateTime? lastWorkoutDate,
    List<CalendarDayData>? calendarDays,
    List<Map<String, dynamic>>? weekDayData,
    List<Map<String, dynamic>>? threeDayData,
    bool? hasStreakLine,
  }) {
    return WidgetData(
      todayPushups: todayPushups ?? this.todayPushups,
      totalPushups: totalPushups ?? this.totalPushups,
      goalPushups: goalPushups ?? this.goalPushups,
      todayGoalReached: todayGoalReached ?? this.todayGoalReached,
      streakDays: streakDays ?? this.streakDays,
      totalPoints: totalPoints ?? this.totalPoints,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      calendarDays: calendarDays ?? this.calendarDays,
      weekDayData: weekDayData ?? this.weekDayData,
      threeDayData: threeDayData ?? this.threeDayData,
      hasStreakLine: hasStreakLine ?? this.hasStreakLine,
    );
  }

  @override
  String toString() {
    return 'WidgetData('
        'todayPushups: $todayPushups, '
        'totalPushups: $totalPushups, '
        'goalPushups: $goalPushups, '
        'todayGoalReached: $todayGoalReached, '
        'streakDays: $streakDays, '
        'totalPoints: $totalPoints, '
        'lastWorkoutDate: $lastWorkoutDate, '
        'calendarDays: ${calendarDays.length} days, '
        'weekDayData: ${weekDayData.length} days, '
        'threeDayData: ${threeDayData.length} days, '
        'hasStreakLine: $hasStreakLine)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WidgetData &&
        other.todayPushups == todayPushups &&
        other.totalPushups == totalPushups &&
        other.goalPushups == goalPushups &&
        other.todayGoalReached == todayGoalReached &&
        other.streakDays == streakDays &&
        other.lastWorkoutDate?.toIso8601String() ==
            lastWorkoutDate?.toIso8601String() &&
        other.calendarDays.length == calendarDays.length;
  }

  @override
  int get hashCode {
    return todayPushups.hashCode ^
        totalPushups.hashCode ^
        goalPushups.hashCode ^
        todayGoalReached.hashCode ^
        streakDays.hashCode ^
        lastWorkoutDate.hashCode ^
        calendarDays.length.hashCode;
  }
}
