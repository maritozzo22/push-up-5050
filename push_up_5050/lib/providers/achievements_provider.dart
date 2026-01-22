import 'package:flutter/foundation.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

/// Provider for achievements management.
///
/// Manages achievement unlock status and checks unlock conditions.
/// Uses predefined achievements from [Achievement.getAllAchievements].
class AchievementsProvider extends ChangeNotifier {
  final StorageService _storage;

  List<Achievement> _achievements = [];
  bool _isLoading = true;

  /// Create a new AchievementsProvider.
  ///
  /// Requires a [StorageService] instance for persistence.
  AchievementsProvider({required StorageService storage})
      : _storage = storage {
    _achievements = getAllAchievements();
  }

  /// Whether achievements are currently being loaded.
  bool get isLoading => _isLoading;

  /// All achievements (locked and unlocked).
  List<Achievement> get achievements => _achievements;

  /// Only unlocked achievements.
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();

  /// Load achievement unlock status from storage.
  ///
  /// Updates each achievement's unlock status based on saved data.
  Future<void> loadAchievements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedData = await _storage.loadAchievements();

      for (final achievement in _achievements) {
        final json = savedData[achievement.id];
        if (json != null) {
          final savedAchievement =
              Achievement.fromJson(json as Map<String, dynamic>);
          if (savedAchievement.isUnlocked) {
            achievement.unlock();
          }
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check unlock conditions against current stats.
  ///
  /// Returns list of newly unlocked achievements.
  /// Saves newly unlocked achievements to storage.
  List<Achievement> checkUnlocks(Map<String, dynamic> stats) {
    final newlyUnlocked = <Achievement>[];

    for (final achievement in _achievements) {
      if (!achievement.isUnlocked && achievement.condition != null) {
        if (achievement.condition!(stats)) {
          achievement.unlock();
          newlyUnlocked.add(achievement);

          // Save to storage
          _storage.saveAchievement(achievement);
        }
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      notifyListeners();
    }

    return newlyUnlocked;
  }

  /// Unlock a specific achievement by ID.
  ///
  /// Returns true if achievement was unlocked, false if not found or already unlocked.
  Future<bool> unlockAchievement(String id) async {
    try {
      final achievement = _achievements.firstWhere((a) => a.id == id);

      if (achievement.isUnlocked) {
        return false;
      }

      achievement.unlock();
      await _storage.saveAchievement(achievement);
      notifyListeners();

      return true;
    } catch (e) {
      // Achievement not found
      return false;
    }
  }

  /// Get all predefined achievements.
  ///
  /// Static factory method that returns the 6 predefined achievements.
  static List<Achievement> getAllAchievements() {
    return Achievement.getAllAchievements();
  }
}
