import 'package:audioplayers/audioplayers.dart';

/// Service for playing audio feedback.
///
/// Supports:
/// - Beep sound at recovery timer completion
/// - Achievement unlock chime
/// - Volume control
/// - Enable/disable settings
///
/// Gracefully degrades when audio is unavailable.
class AudioService {
  AudioPlayer? _audioPlayer;
  bool _isAvailable = false;
  bool _soundsEnabled = true;
  bool _beepEnabled = true;
  bool _achievementSoundEnabled = true;
  bool _pushupSoundEnabled = true;
  bool _goalSoundEnabled = true;
  double _volume = 0.5;

  /// Create AudioService.
  ///
  /// Call [initialize] before using.
  AudioService();

  /// Whether audio service is available.
  bool get isAvailable => _isAvailable;

  /// Initialize audio service and load sounds.
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> initialize() async {
    try {
      _audioPlayer = AudioPlayer();
      await _audioPlayer!.setVolume(_volume);
      _isAvailable = true;
      return true;
    } catch (e) {
      // Audio unavailable - service will gracefully degrade
      _isAvailable = false;
      _audioPlayer = null;
      return false;
    }
  }

  /// Play beep sound (recovery timer completion).
  ///
  /// Only plays if [soundsEnabled] and [beepEnabled] are true.
  Future<void> playBeep() async {
    if (!_isAvailable || _audioPlayer == null) return;
    if (!_soundsEnabled || !_beepEnabled) return;

    try {
      await _audioPlayer!.setVolume(_volume);
      await _audioPlayer!.play(AssetSource('sounds/beep.wav'));
    } catch (e) {
      // Silently fail - audio is optional
    }
  }

  /// Play achievement unlock chime.
  ///
  /// Only plays if [soundsEnabled] and [achievementSoundEnabled] are true.
  Future<void> playAchievementSound() async {
    if (!_isAvailable || _audioPlayer == null) return;
    if (!_soundsEnabled || !_achievementSoundEnabled) return;

    try {
      await _audioPlayer!.setVolume(_volume);
      await _audioPlayer!.play(AssetSource('sounds/achievement.mp3'));
    } catch (e) {
      // Silently fail - audio is optional
    }
  }

  /// Set volume level (0.0 to 1.0).
  ///
  /// Volume is clamped to valid range.
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);

    if (_isAvailable && _audioPlayer != null) {
      try {
        await _audioPlayer!.setVolume(_volume);
      } catch (e) {
        // Ignore errors - will apply on next play
      }
    }
  }

  /// Whether sounds are enabled (master switch).
  bool get soundsEnabled => _soundsEnabled;

  /// Set sounds enabled (master switch).
  Future<void> setSoundsEnabled(bool enabled) async {
    _soundsEnabled = enabled;
  }

  /// Whether beep sound is enabled.
  bool get beepEnabled => _beepEnabled;

  /// Set beep enabled.
  Future<void> setBeepEnabled(bool enabled) async {
    _beepEnabled = enabled;
  }

  /// Whether achievement sound is enabled.
  bool get achievementSoundEnabled => _achievementSoundEnabled;

  /// Set achievement sound enabled.
  Future<void> setAchievementSoundEnabled(bool enabled) async {
    _achievementSoundEnabled = enabled;
  }

  /// Whether push-up sound is enabled.
  bool get pushupSoundEnabled => _pushupSoundEnabled;

  /// Set push-up sound enabled.
  Future<void> setPushupSoundEnabled(bool enabled) async {
    _pushupSoundEnabled = enabled;
  }

  /// Whether goal achieved sound is enabled.
  bool get goalSoundEnabled => _goalSoundEnabled;

  /// Set goal achieved sound enabled.
  Future<void> setGoalSoundEnabled(bool enabled) async {
    _goalSoundEnabled = enabled;
  }

  /// Play push-up completed sound.
  ///
  /// Only plays if [soundsEnabled] and [pushupSoundEnabled] are true.
  Future<void> playPushupDone() async {
    if (!_isAvailable || _audioPlayer == null) return;
    if (!_soundsEnabled || !_pushupSoundEnabled) return;

    try {
      await _audioPlayer!.setVolume(_volume);
      await _audioPlayer!.play(AssetSource('sounds/pushup_done.wav'));
    } catch (e) {
      // Silently fail - audio is optional
    }
  }

  /// Play goal achieved sound.
  ///
  /// Only plays if [soundsEnabled] and [goalSoundEnabled] are true.
  Future<void> playGoalAchieved() async {
    if (!_isAvailable || _audioPlayer == null) return;
    if (!_soundsEnabled || !_goalSoundEnabled) return;

    try {
      await _audioPlayer!.setVolume(_volume);
      await _audioPlayer!.play(AssetSource('sounds/achievement_unlock.wav'));
    } catch (e) {
      // Silently fail - audio is optional
    }
  }

  /// Current volume level (0.0 to 1.0).
  double get volume => _volume;

  /// Dispose audio resources.
  void dispose() {
    try {
      _audioPlayer?.dispose();
      _audioPlayer = null;
    } catch (e) {
      // Ignore dispose errors
    }
  }
}
