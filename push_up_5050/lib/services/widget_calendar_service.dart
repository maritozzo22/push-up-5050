/// Widget Calendar Service
///
/// Provides calendar data for Android widgets, including week data
/// and 3-day view data for small widgets.
library;

import 'package:push_up_5050/repositories/storage_service.dart';

/// Status of a calendar day for widget display
enum CalendarDayStatus {
  /// Day has >= 1 pushup (orange fill)
  completed,

  /// Day has no record AND is in the past after first workout (red outline with X)
  missed,

  /// Future day or before first workout (gray)
  pending,

  /// Current day (special handling)
  today,
}

/// Data for a single day in the widget calendar
class WeekDayData {
  /// Day number (1-31, day of month)
  final int day;

  /// Single letter Italian label: L, M, M, G, V, S, D
  /// For 3-day view: I (ieri), O (oggi), D (domani)
  final String dayLabel;

  /// Status of the day
  final CalendarDayStatus status;

  /// Number of pushups completed on this day (0 if no record)
  final int pushups;

  /// True if this day is consecutive with previous completed day
  /// Used for drawing streak connection lines
  final bool isPartOfStreak;

  const WeekDayData({
    required this.day,
    required this.dayLabel,
    required this.status,
    required this.pushups,
    required this.isPartOfStreak,
  });

  /// Create from JSON
  factory WeekDayData.fromJson(Map<String, dynamic> json) {
    return WeekDayData(
      day: json['day'] as int,
      dayLabel: json['dayLabel'] as String,
      status: _parseStatus(json['status'] as String),
      pushups: json['pushups'] as int? ?? 0,
      isPartOfStreak: json['isPartOfStreak'] as bool? ?? false,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'dayLabel': dayLabel,
      'status': status.name,
      'pushups': pushups,
      'isPartOfStreak': isPartOfStreak,
    };
  }

  /// Create copy with optional field updates
  WeekDayData copyWith({
    int? day,
    String? dayLabel,
    CalendarDayStatus? status,
    int? pushups,
    bool? isPartOfStreak,
  }) {
    return WeekDayData(
      day: day ?? this.day,
      dayLabel: dayLabel ?? this.dayLabel,
      status: status ?? this.status,
      pushups: pushups ?? this.pushups,
      isPartOfStreak: isPartOfStreak ?? this.isPartOfStreak,
    );
  }

  /// Parse status from string
  static CalendarDayStatus _parseStatus(String status) {
    return CalendarDayStatus.values.firstWhere(
      (s) => s.name == status,
      orElse: () => CalendarDayStatus.pending,
    );
  }

  @override
  String toString() =>
      'WeekDayData(day: $day, dayLabel: $dayLabel, status: $status, pushups: $pushups, isPartOfStreak: $isPartOfStreak)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeekDayData &&
        other.day == day &&
        other.dayLabel == dayLabel &&
        other.status == status &&
        other.pushups == pushups &&
        other.isPartOfStreak == isPartOfStreak;
  }

  @override
  int get hashCode =>
      day.hashCode ^
      dayLabel.hashCode ^
      status.hashCode ^
      pushups.hashCode ^
      isPartOfStreak.hashCode;
}

/// Week calendar data for 4x4 widget (7 days: Monday-Sunday)
class WeekData {
  /// List of 7 days from Monday to Sunday
  final List<WeekDayData> days;

  /// True if 2+ consecutive completed days exist in the week
  final bool hasStreakLine;

  const WeekData({
    required this.days,
    required this.hasStreakLine,
  });

  /// Create from JSON
  factory WeekData.fromJson(Map<String, dynamic> json) {
    final daysList = json['days'] as List?;
    return WeekData(
      days: daysList?.map((item) => WeekDayData.fromJson(item as Map<String, dynamic>)).toList() ?? [],
      hasStreakLine: json['hasStreakLine'] as bool? ?? false,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'days': days.map((d) => d.toJson()).toList(),
      'hasStreakLine': hasStreakLine,
    };
  }

  @override
  String toString() => 'WeekData(days: ${days.length}, hasStreakLine: $hasStreakLine)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeekData &&
        other.days.length == days.length &&
        other.hasStreakLine == hasStreakLine;
  }

  @override
  int get hashCode => days.length.hashCode ^ hasStreakLine.hashCode;
}

/// Service for generating calendar data for widgets
class WidgetCalendarService {
  final StorageService storage;

  /// Italian day labels (single letter)
  static const List<String> _italianDayLabels = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];

  /// 3-day view labels
  static const String _labelYesterday = 'I'; // Ieri
  static const String _labelToday = 'O'; // Oggi
  static const String _labelTomorrow = 'D'; // Domani

  const WidgetCalendarService({required this.storage});

  /// Get Monday of the current week for a given date
  ///
  /// For example, if [date] is Wednesday Jan 21, returns Monday Jan 19.
  DateTime getCurrentWeekMonday(DateTime date) {
    // DateTime.weekday: Monday=1, Sunday=7
    final dayOfWeek = date.weekday;
    return date.subtract(Duration(days: dayOfWeek - 1));
  }

  /// Get week data for current week (Monday-Sunday)
  ///
  /// Returns [WeekData] with 7 days of calendar information.
  /// [testDate] is for testing only - defaults to DateTime.now() in production.
  Future<WeekData> getWeekData({DateTime? testDate}) async {
    final now = testDate ?? DateTime.now();
    final monday = getCurrentWeekMonday(now);

    // Load all daily records
    final records = await storage.loadDailyRecords();

    // Find first workout date to determine when to start showing missed days
    final firstWorkoutDate = _findFirstWorkoutDate(records);

    // Generate 7 days of data
    final days = <WeekDayData>[];
    DateTime? previousCompletedDay;

    for (int i = 0; i < 7; i++) {
      final dayDate = monday.add(Duration(days: i));
      final dateKey = _formatDate(dayDate);
      final record = records[dateKey] as Map<String, dynamic>?;

      final isToday = _isSameDay(dayDate, now);
      final hasRecord = record != null;
      final pushups = hasRecord ? (record!['totalPushups'] as int? ?? 0) : 0;

      // Determine status
      CalendarDayStatus status;
      if (isToday) {
        status = CalendarDayStatus.today;
      } else if (hasRecord && pushups > 0) {
        status = CalendarDayStatus.completed;
      } else if (await isDayMissed(dayDate, now, records: records, firstWorkoutDate: firstWorkoutDate)) {
        status = CalendarDayStatus.missed;
      } else {
        status = CalendarDayStatus.pending;
      }

      // Check if part of streak (consecutive with previous completed day)
      final isPartOfStreak = status == CalendarDayStatus.completed &&
          previousCompletedDay != null &&
          _isConsecutiveDay(previousCompletedDay, dayDate);

      if (status == CalendarDayStatus.completed) {
        previousCompletedDay = dayDate;
      }

      days.add(WeekDayData(
        day: dayDate.day,
        dayLabel: _italianDayLabels[i],
        status: status,
        pushups: pushups,
        isPartOfStreak: isPartOfStreak,
      ));
    }

    // Calculate hasStreakLine (true if 2+ consecutive completed days)
    final hasStreakLine = days.any((d) => d.isPartOfStreak);

    return WeekData(days: days, hasStreakLine: hasStreakLine);
  }

  /// Get 3-day data for small widget (Yesterday, Today, Tomorrow)
  ///
  /// Returns list of 3 [WeekDayData] items.
  /// [testDate] is for testing only - defaults to DateTime.now() in production.
  Future<List<WeekDayData>> getThreeDayData({DateTime? testDate}) async {
    final now = testDate ?? DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    final records = await storage.loadDailyRecords();
    final firstWorkoutDate = _findFirstWorkoutDate(records);

    final result = <WeekDayData>[];

    // Yesterday
    result.add(await _createDayData(
      yesterday,
      now,
      _labelYesterday,
      records,
      firstWorkoutDate,
    ));

    // Today
    result.add(await _createDayData(
      now,
      now,
      _labelToday,
      records,
      firstWorkoutDate,
    ));

    // Tomorrow
    result.add(await _createDayData(
      tomorrow,
      now,
      _labelTomorrow,
      records,
      firstWorkoutDate,
    ));

    return result;
  }

  /// Check if a day should be marked as missed
  ///
  /// A day is missed if:
  /// - It's in the past
  /// - It has no record
  /// - It's after the first workout date
  ///
  /// [testNow] is for testing only.
  Future<bool> isDayMissed(
    DateTime day,
    DateTime now, {
    Map<String, dynamic>? records,
    DateTime? firstWorkoutDate,
  }) async {
    records ??= await storage.loadDailyRecords();

    if (firstWorkoutDate == null) {
      firstWorkoutDate = _findFirstWorkoutDate(records);
    }

    // Day must be in the past (not today or future)
    if (!_isInPast(day, now)) {
      return false;
    }

    // Day must have no record
    final dateKey = _formatDate(day);
    if (records.containsKey(dateKey)) {
      return false;
    }

    // Day must be after first workout date
    if (firstWorkoutDate == null) {
      return false; // No workouts yet, can't have missed days
    }

    return day.isAfter(firstWorkoutDate);
  }

  /// Create day data for a specific date
  Future<WeekDayData> _createDayData(
    DateTime dayDate,
    DateTime now,
    String label,
    Map<String, dynamic> records,
    DateTime? firstWorkoutDate,
  ) async {
    final dateKey = _formatDate(dayDate);
    final record = records[dateKey] as Map<String, dynamic>?;

    final isToday = _isSameDay(dayDate, now);
    final hasRecord = record != null;
    final pushups = hasRecord ? (record!['totalPushups'] as int? ?? 0) : 0;

    // Determine status
    CalendarDayStatus status;
    if (isToday) {
      status = CalendarDayStatus.today;
    } else if (hasRecord && pushups > 0) {
      status = CalendarDayStatus.completed;
    } else if (await isDayMissed(dayDate, now, records: records, firstWorkoutDate: firstWorkoutDate)) {
      status = CalendarDayStatus.missed;
    } else {
      status = CalendarDayStatus.pending;
    }

    return WeekDayData(
      day: dayDate.day,
      dayLabel: label,
      status: status,
      pushups: pushups,
      isPartOfStreak: false, // Streak not calculated for 3-day view
    );
  }

  /// Find the first workout date from records
  DateTime? _findFirstWorkoutDate(Map<String, dynamic> records) {
    if (records.isEmpty) return null;

    DateTime? firstDate;
    for (final entry in records.entries) {
      final record = entry.value as Map<String, dynamic>;
      final pushups = record['totalPushups'] as int? ?? 0;
      if (pushups > 0) {
        final dateParts = entry.key.split('-');
        try {
          final date = DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
          );
          if (firstDate == null || date.isBefore(firstDate)) {
            firstDate = date;
          }
        } catch (_) {
          // Skip invalid dates
        }
      }
    }

    return firstDate;
  }

  /// Check if two dates are the same day (ignoring time)
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Check if a date is in the past (before today, ignoring time)
  bool _isInPast(DateTime date, DateTime now) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final nowOnly = DateTime(now.year, now.month, now.day);
    return dateOnly.isBefore(nowOnly);
  }

  /// Check if two days are consecutive (day2 is exactly 1 day after day1)
  bool _isConsecutiveDay(DateTime day1, DateTime day2) {
    final diff = day2.difference(day1);
    return diff.inDays == 1;
  }

  /// Format date as YYYY-MM-DD for storage keys
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
