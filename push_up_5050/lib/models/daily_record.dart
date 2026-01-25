import 'package:push_up_5050/core/utils/calculator.dart';

/// Daily record model
/// Tracks push-up progress for a single day
class DailyRecord {
  /// Date of the record
  final DateTime date;

  /// Total push-ups completed that day
  final int totalPushups;

  /// Number of series completed that day
  final int seriesCompleted;

  /// Total kcal burned that day (auto-calculated)
  final double totalKcal;

  /// Whether goal of 50 push-ups was reached
  final bool goalReached;

  /// Points earned for this day
  final int pointsEarned;

  /// Effective multiplier applied to points calculation
  final double multiplier;

  /// Push-ups completed beyond daily cap (tracked but not rewarded)
  final int excessPushups;

  /// Create a new daily record
  /// totalKcal is auto-calculated if not provided
  /// goalReached is true if totalPushups >= 50
  DailyRecord({
    required this.date,
    this.totalPushups = 0,
    this.seriesCompleted = 0,
    double? totalKcal,
    this.pointsEarned = 0,
    this.multiplier = 1.0,
    this.excessPushups = 0,
  })  : totalKcal = totalKcal ?? Calculator.calculateKcal(totalPushups),
        goalReached = totalPushups >= 50;

  /// Create record from workout session data
  factory DailyRecord.fromSession(
    DateTime date,
    int pushups,
    int series,
  ) {
    return DailyRecord(
      date: date,
      totalPushups: pushups,
      seriesCompleted: series,
    );
  }

  /// Serialize to JSON
  /// Date format: YYYY-MM-DD
  Map<String, dynamic> toJson() {
    return {
      'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'totalPushups': totalPushups,
      'seriesCompleted': seriesCompleted,
      'totalKcal': totalKcal,
      'goalReached': goalReached,
      'pointsEarned': pointsEarned,
      'multiplier': multiplier,
      'excessPushups': excessPushups,
    };
  }

  /// Deserialize from JSON
  /// Date format: YYYY-MM-DD
  factory DailyRecord.fromJson(Map<String, dynamic> json) {
    final dateString = json['date'] as String;
    final parts = dateString.split('-');
    return DailyRecord(
      date: DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      ),
      totalPushups: json['totalPushups'] as int,
      seriesCompleted: json['seriesCompleted'] as int,
      totalKcal: json['totalKcal'] as double,
      pointsEarned: json['pointsEarned'] as int? ?? 0, // Backward compatible
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0, // Backward compatible
      excessPushups: json['excessPushups'] as int? ?? 0, // Backward compatible
    );
  }

  /// Create immutable copy with optional field updates
  /// Note: totalKcal and goalReached will be recalculated based on totalPushups
  DailyRecord copyWith({
    DateTime? date,
    int? totalPushups,
    int? seriesCompleted,
    double? totalKcal,
    int? pointsEarned,
    double? multiplier,
    int? excessPushups,
  }) {
    return DailyRecord(
      date: date ?? this.date,
      totalPushups: totalPushups ?? this.totalPushups,
      seriesCompleted: seriesCompleted ?? this.seriesCompleted,
      totalKcal: totalKcal,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      multiplier: multiplier ?? this.multiplier,
      excessPushups: excessPushups ?? this.excessPushups,
    );
  }
}
