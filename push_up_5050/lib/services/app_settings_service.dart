import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:push_up_5050/models/haptic_intensity.dart';

/// Service for managing app settings with persistence.
///
/// Handles user preferences for:
/// - Proximity sensor toggle
/// - Haptic feedback toggle
/// - Sound settings (master, beep, achievement)
/// - Volume control
///
/// Notifies listeners when any setting changes.
class AppSettingsService extends ChangeNotifier {
  final SharedPreferences _prefs;

  // Storage keys
  static const String _keyProximityEnabled = 'settings_proximity_enabled';
  static const String _keyHapticEnabled = 'settings_haptic_enabled';
  static const String _keyHapticIntensity = 'settings_haptic_intensity';
  static const String _keyDefaultRecoveryTime = 'settings_default_recovery_time';
  static const String _keyDailyReminderEnabled = 'settings_daily_reminder_enabled';
  static const String _keyDailyReminderHour = 'settings_daily_reminder_hour';
  static const String _keyDailyReminderMinute = 'settings_daily_reminder_minute';
  static const String _keySoundsEnabled = 'settings_sounds_enabled';
  static const String _keyBeepEnabled = 'settings_beep_enabled';
  static const String _keyAchievementSoundEnabled =
      'settings_achievement_sound_enabled';
  static const String _keyPushupSoundEnabled = 'settings_pushup_sound_enabled';
  static const String _keyGoalSoundEnabled = 'settings_goal_sound_enabled';
  static const String _keyVolume = 'settings_volume';
  static const String _keyAppLanguage = 'settings_app_language';

  // Default values
  static const bool _defaultProximityEnabled = true;
  static const bool _defaultHapticEnabled = true;
  static const HapticIntensity _defaultHapticIntensity = HapticIntensity.light;
  static const int _defaultRecoveryTime = 10;
  static const bool _defaultDailyReminderEnabled = false;
  static const int _defaultDailyReminderHour = 21; // 9 PM
  static const int _defaultDailyReminderMinute = 0;
  static const bool _defaultSoundsEnabled = true;
  static const bool _defaultBeepEnabled = true;
  static const bool _defaultAchievementSoundEnabled = true;
  static const bool _defaultPushupSoundEnabled = true;
  static const bool _defaultGoalSoundEnabled = true;
  static const double _defaultVolume = 0.5;
  static const String _defaultAppLanguage = 'it';

  // Cached values
  bool _proximitySensorEnabled = _defaultProximityEnabled;
  HapticIntensity _hapticIntensity = _defaultHapticIntensity;
  int _recoveryTime = _defaultRecoveryTime;
  bool _dailyReminderEnabled = _defaultDailyReminderEnabled;
  int _dailyReminderHour = _defaultDailyReminderHour;
  int _dailyReminderMinute = _defaultDailyReminderMinute;
  bool _soundsEnabled = _defaultSoundsEnabled;
  bool _beepEnabled = _defaultBeepEnabled;
  bool _achievementSoundEnabled = _defaultAchievementSoundEnabled;
  bool _pushupSoundEnabled = _defaultPushupSoundEnabled;
  bool _goalSoundEnabled = _defaultGoalSoundEnabled;
  double _volume = _defaultVolume;
  String _appLanguage = _defaultAppLanguage;

  /// Create AppSettingsService with SharedPreferences instance.
  ///
  /// For testing, inject a mock SharedPreferences.
  AppSettingsService({required SharedPreferences prefs}) : _prefs = prefs;

  // ==================== Getters ====================

  /// Whether proximity sensor counting is enabled.
  bool get proximitySensorEnabled => _proximitySensorEnabled;

  /// Current haptic feedback intensity.
  HapticIntensity get hapticIntensity => _hapticIntensity;

  /// Whether haptic feedback is enabled (for backward compatibility).
  ///
  /// Returns false when haptic intensity is off, true otherwise.
  /// @Deprecated: Use hapticIntensity instead.
  bool get hapticFeedbackEnabled => _hapticIntensity != HapticIntensity.off;

  /// Whether sounds are enabled (master switch).
  bool get soundsEnabled => _soundsEnabled;

  /// Whether beep sound at recovery end is enabled.
  bool get beepEnabled => _beepEnabled;

  /// Whether achievement unlock sound is enabled.
  bool get achievementSoundEnabled => _achievementSoundEnabled;

  /// Whether push-up sound is enabled.
  bool get pushupSoundEnabled => _pushupSoundEnabled;

  /// Whether goal achieved sound is enabled.
  bool get goalSoundEnabled => _goalSoundEnabled;

  /// Volume level (0.0 to 1.0).
  double get volume => _volume;

  /// Default recovery time in seconds (5-60 range).
  int get defaultRecoveryTime => _recoveryTime;

  /// Whether daily reminder is enabled.
  bool get dailyReminderEnabled => _dailyReminderEnabled;

  /// The time for daily reminder.
  TimeOfDay get dailyReminderTime => TimeOfDay(
    hour: _dailyReminderHour,
    minute: _dailyReminderMinute,
  );

  // ==================== Setters ====================

  /// Set proximity sensor enabled and persist to storage.
  Future<void> setProximitySensorEnabled(bool value) async {
    if (_proximitySensorEnabled != value) {
      _proximitySensorEnabled = value;
      await _prefs.setBool(_keyProximityEnabled, value);
      notifyListeners();
    }
  }

  /// Set haptic intensity and persist to storage.
  Future<void> setHapticIntensity(HapticIntensity value) async {
    if (_hapticIntensity != value) {
      _hapticIntensity = value;
      await _prefs.setInt(_keyHapticIntensity, value.index);
      notifyListeners();
    }
  }

  /// Set haptic feedback enabled and persist to storage.
  ///
  /// For backward compatibility. Maps boolean to intensity:
  /// - false -> HapticIntensity.off
  /// - true -> HapticIntensity.light
  /// @Deprecated: Use setHapticIntensity instead.
  Future<void> setHapticFeedbackEnabled(bool value) async {
    final newIntensity = value ? HapticIntensity.light : HapticIntensity.off;
    await setHapticIntensity(newIntensity);
  }

  /// Set default recovery time and persist to storage.
  ///
  /// Value is clamped to 5-60 range.
  Future<void> setDefaultRecoveryTime(int value) async {
    final clamped = value.clamp(5, 60);
    if (_recoveryTime != clamped) {
      _recoveryTime = clamped;
      await _prefs.setInt(_keyDefaultRecoveryTime, clamped);
      notifyListeners();
    }
  }

  /// Set daily reminder enabled and persist to storage.
  Future<void> setDailyReminderEnabled(bool value) async {
    if (_dailyReminderEnabled != value) {
      _dailyReminderEnabled = value;
      await _prefs.setBool(_keyDailyReminderEnabled, value);
      notifyListeners();
    }
  }

  /// Set daily reminder time and persist to storage.
  Future<void> setDailyReminderTime(TimeOfDay value) async {
    if (_dailyReminderHour != value.hour || _dailyReminderMinute != value.minute) {
      _dailyReminderHour = value.hour;
      _dailyReminderMinute = value.minute;
      await _prefs.setInt(_keyDailyReminderHour, value.hour);
      await _prefs.setInt(_keyDailyReminderMinute, value.minute);
      notifyListeners();
    }
  }

  /// Set sounds enabled (master switch) and persist to storage.
  Future<void> setSoundsEnabled(bool value) async {
    if (_soundsEnabled != value) {
      _soundsEnabled = value;
      await _prefs.setBool(_keySoundsEnabled, value);
      notifyListeners();
    }
  }

  /// Set beep enabled and persist to storage.
  Future<void> setBeepEnabled(bool value) async {
    if (_beepEnabled != value) {
      _beepEnabled = value;
      await _prefs.setBool(_keyBeepEnabled, value);
      notifyListeners();
    }
  }

  /// Set achievement sound enabled and persist to storage.
  Future<void> setAchievementSoundEnabled(bool value) async {
    if (_achievementSoundEnabled != value) {
      _achievementSoundEnabled = value;
      await _prefs.setBool(_keyAchievementSoundEnabled, value);
      notifyListeners();
    }
  }

  /// Set push-up sound enabled and persist to storage.
  Future<void> setPushupSoundEnabled(bool value) async {
    if (_pushupSoundEnabled != value) {
      _pushupSoundEnabled = value;
      await _prefs.setBool(_keyPushupSoundEnabled, value);
      notifyListeners();
    }
  }

  /// Set goal achieved sound enabled and persist to storage.
  Future<void> setGoalSoundEnabled(bool value) async {
    if (_goalSoundEnabled != value) {
      _goalSoundEnabled = value;
      await _prefs.setBool(_keyGoalSoundEnabled, value);
      notifyListeners();
    }
  }

  /// Set volume and persist to storage.
  ///
  /// Volume is clamped to 0.0 - 1.0 range.
  Future<void> setVolume(double value) async {
    final clamped = value.clamp(0.0, 1.0);
    if (_volume != clamped) {
      _volume = clamped;
      await _prefs.setDouble(_keyVolume, clamped);
      notifyListeners();
    }
  }

  /// Get current app language code.
  ///
  /// Returns 'it' for Italian or 'en' for English.
  String get appLanguage => _appLanguage;

  /// Set app language and persist to storage.
  ///
  /// Only accepts 'it' or 'en'. Invalid values are ignored.
  Future<void> setAppLanguage(String value) async {
    // Only allow supported languages
    if (value != 'it' && value != 'en') {
      return; // Ignore invalid language codes
    }

    if (_appLanguage != value) {
      _appLanguage = value;
      await _prefs.setString(_keyAppLanguage, value);
      notifyListeners();
    }
  }

  // ==================== Load/Save ====================

  /// Load all settings from storage.
  ///
  /// Uses cached values if available, otherwise loads from SharedPreferences.
  /// Falls back to defaults if storage data is missing or corrupted.
  Future<void> loadSettings() async {
    _proximitySensorEnabled =
        _prefs.getBool(_keyProximityEnabled) ?? _defaultProximityEnabled;

    // Load haptic intensity with migration from old boolean setting
    final hapticIndex = _prefs.getInt(_keyHapticIntensity);
    if (hapticIndex != null &&
        hapticIndex >= 0 &&
        hapticIndex < HapticIntensity.values.length) {
      _hapticIntensity = HapticIntensity.values[hapticIndex];
    } else {
      // Migrate old boolean setting
      final oldHapticEnabled =
          _prefs.getBool(_keyHapticEnabled) ?? _defaultHapticEnabled;
      _hapticIntensity =
          oldHapticEnabled ? HapticIntensity.light : HapticIntensity.off;
    }

    // Load default recovery time with validation
    final recoveryTime = _prefs.getInt(_keyDefaultRecoveryTime);
    if (recoveryTime != null && recoveryTime >= 5 && recoveryTime <= 60) {
      _recoveryTime = recoveryTime;
    } else {
      _recoveryTime = _defaultRecoveryTime;
    }

    // Load daily reminder settings
    _dailyReminderEnabled =
        _prefs.getBool(_keyDailyReminderEnabled) ?? _defaultDailyReminderEnabled;
    _dailyReminderHour =
        _prefs.getInt(_keyDailyReminderHour) ?? _defaultDailyReminderHour;
    _dailyReminderMinute =
        _prefs.getInt(_keyDailyReminderMinute) ?? _defaultDailyReminderMinute;

    _soundsEnabled =
        _prefs.getBool(_keySoundsEnabled) ?? _defaultSoundsEnabled;
    _beepEnabled = _prefs.getBool(_keyBeepEnabled) ?? _defaultBeepEnabled;
    _achievementSoundEnabled = _prefs.getBool(_keyAchievementSoundEnabled) ??
        _defaultAchievementSoundEnabled;
    _pushupSoundEnabled =
        _prefs.getBool(_keyPushupSoundEnabled) ?? _defaultPushupSoundEnabled;
    _goalSoundEnabled =
        _prefs.getBool(_keyGoalSoundEnabled) ?? _defaultGoalSoundEnabled;

    // Handle corrupted volume data
    double? volumeRaw;
    try {
      volumeRaw = _prefs.getDouble(_keyVolume);
    } catch (e) {
      // Data type mismatch, fall back to default
      volumeRaw = null;
    }

    if (volumeRaw != null && volumeRaw >= 0.0 && volumeRaw <= 1.0) {
      _volume = volumeRaw;
    } else {
      _volume = _defaultVolume;
    }

    // Load app language with validation
    final language = _prefs.getString(_keyAppLanguage);
    if (language != null && (language == 'it' || language == 'en')) {
      _appLanguage = language;
    } else {
      // Fall back to default for invalid or missing language
      _appLanguage = _defaultAppLanguage;
    }

    notifyListeners();
  }

  /// Save all current settings to storage.
  ///
  /// This is typically called automatically by setters, but can be called
  /// explicitly to ensure all settings are persisted.
  Future<void> saveSettings() async {
    await _prefs.setBool(_keyProximityEnabled, _proximitySensorEnabled);
    // Save haptic intensity (old boolean key kept for backward compatibility)
    await _prefs.setInt(_keyHapticIntensity, _hapticIntensity.index);
    await _prefs.setInt(_keyDefaultRecoveryTime, _recoveryTime);
    await _prefs.setBool(_keyDailyReminderEnabled, _dailyReminderEnabled);
    await _prefs.setInt(_keyDailyReminderHour, _dailyReminderHour);
    await _prefs.setInt(_keyDailyReminderMinute, _dailyReminderMinute);
    await _prefs.setBool(_keySoundsEnabled, _soundsEnabled);
    await _prefs.setBool(_keyBeepEnabled, _beepEnabled);
    await _prefs.setBool(_keyAchievementSoundEnabled, _achievementSoundEnabled);
    await _prefs.setBool(_keyPushupSoundEnabled, _pushupSoundEnabled);
    await _prefs.setBool(_keyGoalSoundEnabled, _goalSoundEnabled);
    await _prefs.setDouble(_keyVolume, _volume);
    await _prefs.setString(_keyAppLanguage, _appLanguage);
  }

  /// Reset all settings to defaults.
  Future<void> resetToDefaults() async {
    _proximitySensorEnabled = _defaultProximityEnabled;
    _hapticIntensity = _defaultHapticIntensity;
    _recoveryTime = _defaultRecoveryTime;
    _dailyReminderEnabled = _defaultDailyReminderEnabled;
    _dailyReminderHour = _defaultDailyReminderHour;
    _dailyReminderMinute = _defaultDailyReminderMinute;
    _soundsEnabled = _defaultSoundsEnabled;
    _beepEnabled = _defaultBeepEnabled;
    _achievementSoundEnabled = _defaultAchievementSoundEnabled;
    _pushupSoundEnabled = _defaultPushupSoundEnabled;
    _goalSoundEnabled = _defaultGoalSoundEnabled;
    _volume = _defaultVolume;
    _appLanguage = _defaultAppLanguage;

    await saveSettings();
    notifyListeners();
  }
}
