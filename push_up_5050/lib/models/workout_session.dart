import 'package:push_up_5050/core/utils/calculator.dart';

/// Workout session model
/// Tracks progressive push-up series with state management
class WorkoutSession {
  /// Series number to start workout from (1-99)
  final int startingSeries;

  /// Current series being worked on
  int currentSeries;

  /// Number of reps completed in current series
  int repsInCurrentSeries;

  /// Total push-ups completed across all series
  int totalReps;

  /// Recovery time between series in seconds
  final int restTime;

  /// Whether workout session is active
  bool isActive;

  /// When the workout started
  DateTime startTime;

  /// Optional goal: target number of push-ups to complete
  final int? goalPushups;

  /// Whether the goal has been reached
  bool goalReached;

  /// Create a new workout session
  WorkoutSession({
    required this.startingSeries,
    required this.restTime,
    int? currentSeries,
    this.repsInCurrentSeries = 0,
    this.totalReps = 0,
    this.isActive = true,
    DateTime? startTime,
    this.goalPushups,
    this.goalReached = false,
  })  : currentSeries = currentSeries ?? startingSeries,
        startTime = startTime ?? DateTime.now();

  /// Calculate total kcal burned
  double get totalKcal => Calculator.calculateKcal(totalReps);

  /// Check if current series is complete
  bool isSeriesComplete() {
    return repsInCurrentSeries >= currentSeries;
  }

  /// Increment rep count
  void countRep() {
    repsInCurrentSeries++;
    totalReps++;
  }

  /// Get remaining reps needed for current series
  int get remainingReps {
    final remaining = currentSeries - repsInCurrentSeries;
    return remaining > 0 ? remaining : 0;
  }

  /// Move to next series (only if current is complete)
  void advanceToNextSeries() {
    if (!isSeriesComplete()) return;
    currentSeries++;
    repsInCurrentSeries = 0;
    // Update goal status after advancing
    updateGoalStatus();
  }

  /// Update goalReached status based on current progress
  void updateGoalStatus() {
    if (goalPushups == null) {
      goalReached = false;
      return;
    }
    // Goal is reached when total push-ups completed >= goal push-ups
    goalReached = totalReps >= goalPushups!;
  }

  /// End the workout session
  void endSession() {
    isActive = false;
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'startingSeries': startingSeries,
      'restTime': restTime,
      'currentSeries': currentSeries,
      'repsInCurrentSeries': repsInCurrentSeries,
      'totalReps': totalReps,
      'isActive': isActive,
      'startTime': startTime.toIso8601String(),
      'goalPushups': goalPushups,
      'goalReached': goalReached,
    };
  }

  /// Deserialize from JSON
  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      startingSeries: json['startingSeries'] as int,
      restTime: json['restTime'] as int,
      currentSeries: json['currentSeries'] as int,
      repsInCurrentSeries: json['repsInCurrentSeries'] as int,
      totalReps: json['totalReps'] as int,
      isActive: json['isActive'] as bool,
      startTime: DateTime.parse(json['startTime'] as String),
      goalPushups: json['goalPushups'] as int?,
      goalReached: json['goalReached'] as bool? ?? false,
    );
  }

  /// Create immutable copy with optional field updates
  WorkoutSession copyWith({
    int? startingSeries,
    int? restTime,
    int? currentSeries,
    int? repsInCurrentSeries,
    int? totalReps,
    bool? isActive,
    DateTime? startTime,
    int? goalPushups,
    bool? goalReached,
  }) {
    return WorkoutSession(
      startingSeries: startingSeries ?? this.startingSeries,
      restTime: restTime ?? this.restTime,
      currentSeries: currentSeries ?? this.currentSeries,
      repsInCurrentSeries: repsInCurrentSeries ?? this.repsInCurrentSeries,
      totalReps: totalReps ?? this.totalReps,
      isActive: isActive ?? this.isActive,
      startTime: startTime ?? this.startTime,
      goalPushups: goalPushups ?? this.goalPushups,
      goalReached: goalReached ?? this.goalReached,
    );
  }
}
