/// Goal model for tracking user objectives.
///
/// Supports different goal types: weekly, monthly, challenge, and total.
class Goal {
  /// Unique identifier for the goal
  final String id;

  /// Display title
  final String title;

  /// Description of what the goal entails
  final String description;

  /// Type of goal
  final GoalType type;

  /// Target value to achieve
  final int target;

  /// Current progress value
  final int current;

  /// Icon to display
  final String iconName;

  const Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.target,
    this.current = 0,
    this.iconName = 'flag',
  });

  /// Calculate progress as a fraction (0.0 to 1.0)
  double get progress {
    if (target == 0) return 0.0;
    return (current / target).clamp(0.0, 1.0);
  }

  /// Whether the goal has been achieved
  bool get isCompleted => current >= target;

  /// Percentage complete (0-100)
  int get percentage => (progress * 100).round();

  /// Create a copy with updated values
  Goal copyWith({int? current}) {
    return Goal(
      id: id,
      title: title,
      description: description,
      type: type,
      target: target,
      current: current ?? this.current,
      iconName: iconName,
    );
  }

  /// Create Goal from JSON
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: GoalType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => GoalType.challenge,
      ),
      target: json['target'] as int,
      current: json['current'] as int? ?? 0,
      iconName: json['iconName'] as String? ?? 'flag',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'target': target,
      'current': current,
      'iconName': iconName,
    };
  }
}

/// Types of goals available in the app
enum GoalType {
  /// Weekly goal (e.g., 350 pushups per week)
  weekly,

  /// Monthly goal (e.g., 1500 pushups per month)
  monthly,

  /// Challenge/special goal (e.g., 100 in one session)
  challenge,

  /// Total goal (e.g., 5050 total pushups)
  total,
}

/// Predefined goals for the Push-Up 5050 program
class PredefinedGoals {
  /// Weekly goal: 350 pushups (50/day × 7 days)
  static const Goal weekly = Goal(
    id: 'weekly_350',
    title: 'SETTIMANALE',
    description: '350 Push-up a settimana',
    type: GoalType.weekly,
    target: 350,
    iconName: 'calendar_week',
  );

  /// Monthly goal: 1500 pushups (50/day × 30 days)
  static const Goal monthly = Goal(
    id: 'monthly_1500',
    title: 'MENSILE',
    description: '1500 Push-up al mese',
    type: GoalType.monthly,
    target: 1500,
    iconName: 'calendar_month',
  );

  /// Total program goal: 5050 pushups
  static const Goal total = Goal(
    id: 'total_5050',
    title: 'TOTALE',
    description: '5050 Push-up totali',
    type: GoalType.total,
    target: 5050,
    iconName: 'military_tech',
  );

  /// Challenge: 100 pushups in one session
  static const Goal centurion = Goal(
    id: 'challenge_100',
    title: 'CENTURIONE',
    description: '100 Push-up in una sessione',
    type: GoalType.challenge,
    target: 100,
    iconName: 'emoji_events',
  );

  /// Challenge: 7 consecutive days
  static const Goal perfectWeek = Goal(
    id: 'challenge_7days',
    title: 'SETTIMANA PERFETTA',
    description: '7 giorni consecutivi',
    type: GoalType.challenge,
    target: 7,
    iconName: 'local_fire_department',
  );

  /// Challenge: Complete the 30-day program
  static const Goal programComplete = Goal(
    id: 'challenge_30days',
    title: 'PROGRAMMA COMPLETO',
    description: '30 giorni completati',
    type: GoalType.challenge,
    target: 30,
    iconName: 'workspace_premium',
  );

  /// All predefined goals
  static const List<Goal> all = [
    weekly,
    monthly,
    total,
    centurion,
    perfectWeek,
    programComplete,
  ];

  /// Get goal by ID
  static Goal? getById(String id) {
    for (final goal in all) {
      if (goal.id == id) return goal;
    }
    return null;
  }
}
