/// Achievement unlock condition function
/// Takes a map of stats and returns true if achievement should be unlocked
typedef AchievementCondition = bool Function(Map<String, dynamic> stats);

/// Achievement model
/// Represents a unlockable achievement in the game
class Achievement {
  /// Unique identifier for achievement
  final String id;

  /// Display name
  final String name;

  /// Achievement description
  final String description;

  /// Points awarded when unlocked
  final int points;

  /// Emoji/icon for display
  final String icon;

  /// Whether achievement is unlocked
  bool isUnlocked;

  /// When achievement was unlocked
  DateTime? unlockedAt;

  /// Function to check unlock condition
  final AchievementCondition? condition;

  /// Create a new achievement
  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
    this.condition,
  });

  /// Mark achievement as unlocked
  /// Sets isUnlocked to true and unlockedAt to current time
  /// Does nothing if already unlocked
  void unlock() {
    if (isUnlocked) return;
    isUnlocked = true;
    unlockedAt = DateTime.now();
  }

  /// Check if unlock condition is met
  /// Returns true if condition exists and evaluates to true
  /// Unlocks achievement if condition is met
  /// Returns false if no condition defined or already unlocked
  bool checkUnlock(Map<String, dynamic> stats) {
    if (isUnlocked || condition == null) return false;
    if (condition!(stats)) {
      unlock();
      return true;
    }
    return false;
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'points': points,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  /// Deserialize from JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      points: json['points'] as int,
      icon: json['icon'] as String,
      isUnlocked: json['isUnlocked'] as bool,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }

  /// Get all predefined achievements
  /// Returns 16 achievements with unlock conditions
  static List<Achievement> getAllAchievements() {
    return [
      Achievement(
        id: 'first_pushup',
        name: 'Primo Passo',
        description: 'Completa il tuo primo push-up',
        points: 50,
        icon: '🎯',
        condition: (stats) => (stats['totalPushups'] as int) >= 1,
      ),
      Achievement(
        id: 'ten_in_a_row',
        name: 'Dieci in un Row',
        description: 'Completa 10 push-up in una singola serie',
        points: 150,
        icon: '💪',
        condition: (stats) => (stats['maxRepsInOneSeries'] as int) >= 10,
      ),
      Achievement(
        id: 'centenary',
        name: 'Centenario',
        description: 'Raggiungi 100 push-up totali',
        points: 200,
        icon: '💯',
        condition: (stats) => (stats['totalPushupsAllTime'] as int) >= 100,
      ),
      Achievement(
        id: 'perfect_week',
        name: 'Settimana Perfetta',
        description: 'Mantieni una striscia di 7 giorni consecutivi',
        points: 500,
        icon: '🔥',
        condition: (stats) => (stats['currentStreak'] as int) >= 7,
      ),
      Achievement(
        id: 'marathon',
        name: 'Maratona',
        description: 'Completa 500 push-up in un singolo giorno',
        points: 1000,
        icon: '🏃',
        condition: (stats) => (stats['maxPushupsInOneDay'] as int) >= 500,
      ),
      Achievement(
        id: 'lion_month',
        name: 'Mese da Leoni',
        description: 'Completa 30 giorni di allenamento',
        points: 5000,
        icon: '🦁',
        condition: (stats) => (stats['daysCompleted'] as int) >= 30,
      ),
      // Nuovi achievement
      Achievement(
        id: 'hundred_in_one_day',
        name: 'Cento in un Giorno',
        description: 'Completa 100 push-up in un singolo giorno',
        points: 300,
        icon: '💯',
        condition: (stats) => (stats['maxPushupsInOneDay'] as int) >= 100,
      ),
      Achievement(
        id: 'two_hundred_in_one_day',
        name: 'Duedento in un Giorno',
        description: 'Completa 200 push-up in un singolo giorno',
        points: 800,
        icon: '🔥',
        condition: (stats) => (stats['maxPushupsInOneDay'] as int) >= 200,
      ),
      Achievement(
        id: 'three_hundred_in_one_day',
        name: 'Trecento in un Giorno',
        description: 'Completa 300 push-up in un singolo giorno',
        points: 1500,
        icon: '⚡',
        condition: (stats) => (stats['maxPushupsInOneDay'] as int) >= 300,
      ),
      Achievement(
        id: 'thousand_month',
        name: 'Mille al Mese',
        description: 'Raggiungi 1000 push-up in un mese',
        points: 700,
        icon: '📅',
        condition: (stats) => (stats['monthlyPushups'] as int) >= 1000,
      ),
      Achievement(
        id: 'five_series_streak',
        name: 'Cinque Serie di Fila',
        description: 'Completa 5 serie consecutive senza fermarti',
        points: 250,
        icon: '🏃',
        condition: (stats) => (stats['maxConsecutiveSeries'] as int) >= 5,
      ),
      Achievement(
        id: 'ten_series_streak',
        name: 'Dieci Serie di Fila',
        description: 'Completa 10 serie consecutive senza fermarti',
        points: 600,
        icon: '🚀',
        condition: (stats) => (stats['maxConsecutiveSeries'] as int) >= 10,
      ),
      Achievement(
        id: 'fifteen_day_streak',
        name: 'Quindici Giorni di Tenacia',
        description: 'Mantieni 15 giorni consecutivi di allenamento',
        points: 1500,
        icon: '💪',
        condition: (stats) => (stats['currentStreak'] as int) >= 15,
      ),
      Achievement(
        id: 'thousand_points',
        name: 'Mille Punti',
        description: 'Raggiungi 1000 punti totali',
        points: 300,
        icon: '⭐',
        condition: (stats) => (stats['totalPoints'] as int) >= 1000,
      ),
      Achievement(
        id: 'five_thousand_points',
        name: 'Cinque Mila Punti',
        description: 'Raggiungi 5000 punti totali',
        points: 1000,
        icon: '🌟',
        condition: (stats) => (stats['totalPoints'] as int) >= 5000,
      ),
      Achievement(
        id: 'ten_thousand_points',
        name: 'Dieci Mila Punti',
        description: 'Raggiungi 10000 punti totali',
        points: 2500,
        icon: '👑',
        condition: (stats) => (stats['totalPoints'] as int) >= 10000,
      ),
    ];
  }
}
