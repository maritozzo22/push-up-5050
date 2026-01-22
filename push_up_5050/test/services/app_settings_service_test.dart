import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:push_up_5050/models/haptic_intensity.dart';
import 'package:push_up_5050/services/app_settings_service.dart';

void main() {
  group('AppSettingsService', () {
    late AppSettingsService settings;
    late SharedPreferences prefs;

    setUp(() async {
      // Initialize SharedPreferences with empty data for each test
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      settings = AppSettingsService(prefs: prefs);
    });

    group('Default Values', () {
      test('should have correct default values when first created', () async {
        await settings.loadSettings();

        expect(settings.proximitySensorEnabled, true);
        expect(settings.hapticFeedbackEnabled, true);
        expect(settings.hapticIntensity, HapticIntensity.light);
        expect(settings.soundsEnabled, true);
        expect(settings.beepEnabled, true);
        expect(settings.achievementSoundEnabled, true);
        expect(settings.volume, 0.5);
        expect(settings.defaultRecoveryTime, 10);
        expect(settings.dailyReminderEnabled, false);
        expect(settings.dailyReminderTime.hour, 21);
        expect(settings.dailyReminderTime.minute, 0);
      });
    });

    group('Proximity Sensor Setting', () {
      test('should get proximity sensor enabled', () async {
        await settings.loadSettings();
        expect(settings.proximitySensorEnabled, true);
      });

      test('should set and persist proximity sensor enabled', () async {
        await settings.loadSettings();
        await settings.setProximitySensorEnabled(false);

        expect(settings.proximitySensorEnabled, false);

        // Create new instance to verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.proximitySensorEnabled, false);
      });

      test('should toggle proximity sensor enabled', () async {
        await settings.loadSettings();
        await settings.setProximitySensorEnabled(false);
        expect(settings.proximitySensorEnabled, false);

        await settings.setProximitySensorEnabled(true);
        expect(settings.proximitySensorEnabled, true);
      });
    });

    group('Haptic Feedback Setting', () {
      test('should get haptic feedback enabled', () async {
        await settings.loadSettings();
        expect(settings.hapticFeedbackEnabled, true);
      });

      test('should set and persist haptic feedback enabled', () async {
        await settings.loadSettings();
        await settings.setHapticFeedbackEnabled(false);

        expect(settings.hapticFeedbackEnabled, false);

        // Verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.hapticFeedbackEnabled, false);
      });
    });

    group('Haptic Intensity Setting', () {
      test('should have default light intensity', () async {
        await settings.loadSettings();
        expect(settings.hapticIntensity, HapticIntensity.light);
      });

      test('should set and persist haptic intensity', () async {
        await settings.loadSettings();
        await settings.setHapticIntensity(HapticIntensity.off);

        expect(settings.hapticIntensity, HapticIntensity.off);

        // Create new instance to verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.hapticIntensity, HapticIntensity.off);
      });

      test('should set to medium intensity', () async {
        await settings.loadSettings();
        await settings.setHapticIntensity(HapticIntensity.medium);

        expect(settings.hapticIntensity, HapticIntensity.medium);

        // Verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.hapticIntensity, HapticIntensity.medium);
      });

      test('should migrate old boolean false setting to off', () async {
        // Set old boolean to false
        await prefs.setBool('settings_haptic_enabled', false);

        await settings.loadSettings();

        // Should migrate to off
        expect(settings.hapticIntensity, HapticIntensity.off);
        expect(settings.hapticFeedbackEnabled, false);
      });

      test('should migrate old boolean true setting to light', () async {
        // Set old boolean to true
        await prefs.setBool('settings_haptic_enabled', true);

        await settings.loadSettings();

        // Should migrate to light (default when enabled)
        expect(settings.hapticIntensity, HapticIntensity.light);
        expect(settings.hapticFeedbackEnabled, true);
      });

      test('should map off intensity to hapticFeedbackEnabled false', () async {
        await settings.loadSettings();
        await settings.setHapticIntensity(HapticIntensity.off);

        expect(settings.hapticFeedbackEnabled, false);
      });

      test('should map light intensity to hapticFeedbackEnabled true', () async {
        await settings.loadSettings();
        await settings.setHapticIntensity(HapticIntensity.light);

        expect(settings.hapticFeedbackEnabled, true);
      });

      test('should map medium intensity to hapticFeedbackEnabled true', () async {
        await settings.loadSettings();
        await settings.setHapticIntensity(HapticIntensity.medium);

        expect(settings.hapticFeedbackEnabled, true);
      });

      test('should notify listeners when haptic intensity changes', () async {
        await settings.loadSettings();

        bool notified = false;
        settings.addListener(() {
          notified = true;
        });

        await settings.setHapticIntensity(HapticIntensity.medium);

        expect(notified, true);
      });

      test('deprecated setHapticFeedbackEnabled should work for backward compatibility', () async {
        await settings.loadSettings();

        // Setting false should set intensity to off
        await settings.setHapticFeedbackEnabled(false);
        expect(settings.hapticIntensity, HapticIntensity.off);

        // Setting true should set intensity to light
        await settings.setHapticFeedbackEnabled(true);
        expect(settings.hapticIntensity, HapticIntensity.light);
      });
    });

    group('Default Recovery Time Setting', () {
      test('should have default value of 10 seconds', () async {
        await settings.loadSettings();
        expect(settings.defaultRecoveryTime, 10);
      });

      test('should set and persist recovery time', () async {
        await settings.loadSettings();
        await settings.setDefaultRecoveryTime(30);

        expect(settings.defaultRecoveryTime, 30);

        // Create new instance to verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.defaultRecoveryTime, 30);
      });

      test('should set to minimum 5 seconds', () async {
        await settings.loadSettings();
        await settings.setDefaultRecoveryTime(5);

        expect(settings.defaultRecoveryTime, 5);

        // Verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.defaultRecoveryTime, 5);
      });

      test('should set to maximum 60 seconds', () async {
        await settings.loadSettings();
        await settings.setDefaultRecoveryTime(60);

        expect(settings.defaultRecoveryTime, 60);

        // Verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.defaultRecoveryTime, 60);
      });

      test('should clamp values below 5 to 5', () async {
        await settings.loadSettings();
        await settings.setDefaultRecoveryTime(2);

        expect(settings.defaultRecoveryTime, 5);
      });

      test('should clamp values above 60 to 60', () async {
        await settings.loadSettings();
        await settings.setDefaultRecoveryTime(90);

        expect(settings.defaultRecoveryTime, 60);
      });

      test('should notify listeners when recovery time changes', () async {
        await settings.loadSettings();

        bool notified = false;
        settings.addListener(() {
          notified = true;
        });

        await settings.setDefaultRecoveryTime(20);

        expect(notified, true);
      });

      test('should not notify if value is the same', () async {
        await settings.loadSettings();

        bool notified = false;
        settings.addListener(() {
          notified = true;
        });

        await settings.setDefaultRecoveryTime(10); // Same as default

        expect(notified, false);
      });
    });

    group('Daily Reminder Settings', () {
      test('should have default reminder disabled and 21:00 time', () async {
        await settings.loadSettings();

        expect(settings.dailyReminderEnabled, false);
        expect(settings.dailyReminderTime.hour, 21);
        expect(settings.dailyReminderTime.minute, 0);
      });

      test('should set and persist daily reminder enabled', () async {
        await settings.loadSettings();
        await settings.setDailyReminderEnabled(true);

        expect(settings.dailyReminderEnabled, true);

        // Create new instance to verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.dailyReminderEnabled, true);
      });

      test('should set and persist reminder time', () async {
        await settings.loadSettings();
        await settings.setDailyReminderTime(const TimeOfDay(hour: 8, minute: 30));

        expect(settings.dailyReminderTime.hour, 8);
        expect(settings.dailyReminderTime.minute, 30);

        // Verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.dailyReminderTime.hour, 8);
        expect(newSettings.dailyReminderTime.minute, 30);
      });

      test('should notify listeners when reminder enabled changes', () async {
        await settings.loadSettings();

        bool notified = false;
        settings.addListener(() {
          notified = true;
        });

        await settings.setDailyReminderEnabled(true);

        expect(notified, true);
      });

      test('should notify listeners when reminder time changes', () async {
        await settings.loadSettings();

        bool notified = false;
        settings.addListener(() {
          notified = true;
        });

        await settings.setDailyReminderTime(const TimeOfDay(hour: 20, minute: 0));

        expect(notified, true);
      });
    });

    group('Sounds Enabled Setting', () {
      test('should get sounds enabled', () async {
        await settings.loadSettings();
        expect(settings.soundsEnabled, true);
      });

      test('should set and persist sounds enabled', () async {
        await settings.loadSettings();
        await settings.setSoundsEnabled(false);

        expect(settings.soundsEnabled, false);

        // Verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.soundsEnabled, false);
      });
    });

    group('Beep Enabled Setting', () {
      test('should get beep enabled', () async {
        await settings.loadSettings();
        expect(settings.beepEnabled, true);
      });

      test('should set and persist beep enabled', () async {
        await settings.loadSettings();
        await settings.setBeepEnabled(false);

        expect(settings.beepEnabled, false);

        // Verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.beepEnabled, false);
      });
    });

    group('Achievement Sound Enabled Setting', () {
      test('should get achievement sound enabled', () async {
        await settings.loadSettings();
        expect(settings.achievementSoundEnabled, true);
      });

      test('should set and persist achievement sound enabled', () async {
        await settings.loadSettings();
        await settings.setAchievementSoundEnabled(false);

        expect(settings.achievementSoundEnabled, false);

        // Verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.achievementSoundEnabled, false);
      });
    });

    group('Volume Setting', () {
      test('should get default volume', () async {
        await settings.loadSettings();
        expect(settings.volume, 0.5);
      });

      test('should set and persist volume', () async {
        await settings.loadSettings();
        await settings.setVolume(0.8);

        expect(settings.volume, 0.8);

        // Verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.volume, 0.8);
      });

      test('should clamp volume to maximum 1.0', () async {
        await settings.loadSettings();
        await settings.setVolume(1.5);

        expect(settings.volume, 1.0);
      });

      test('should clamp volume to minimum 0.0', () async {
        await settings.loadSettings();
        await settings.setVolume(-0.5);

        expect(settings.volume, 0.0);
      });
    });

    group('Save Settings', () {
      test('should save all settings to storage', () async {
        await settings.loadSettings();
        await settings.setProximitySensorEnabled(false);
        await settings.setHapticFeedbackEnabled(false);
        await settings.setVolume(0.75);

        await settings.saveSettings();

        // Create new instance to verify all settings persisted
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();

        expect(newSettings.proximitySensorEnabled, false);
        expect(newSettings.hapticFeedbackEnabled, false);
        expect(newSettings.volume, 0.75);
      });
    });

    group('Load Settings', () {
      test('should load settings from storage', () async {
        // Manually set values in SharedPreferences
        await prefs.setBool('settings_proximity_enabled', false);
        await prefs.setBool('settings_haptic_enabled', false);
        await prefs.setBool('settings_sounds_enabled', false);
        await prefs.setBool('settings_beep_enabled', false);
        await prefs.setBool('settings_achievement_sound_enabled', false);
        await prefs.setDouble('settings_volume', 0.3);

        await settings.loadSettings();

        expect(settings.proximitySensorEnabled, false);
        expect(settings.hapticFeedbackEnabled, false);
        expect(settings.soundsEnabled, false);
        expect(settings.beepEnabled, false);
        expect(settings.achievementSoundEnabled, false);
        expect(settings.volume, 0.3);
      });
    });

    group('Settings Together', () {
      test('should handle multiple settings changes together', () async {
        await settings.loadSettings();

        // Change multiple settings
        await settings.setProximitySensorEnabled(false);
        await settings.setVolume(0.9);
        await settings.setAchievementSoundEnabled(false);

        expect(settings.proximitySensorEnabled, false);
        expect(settings.volume, 0.9);
        expect(settings.achievementSoundEnabled, false);

        // Verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();

        expect(newSettings.proximitySensorEnabled, false);
        expect(newSettings.volume, 0.9);
        expect(newSettings.achievementSoundEnabled, false);
      });
    });

    group('Edge Cases', () {
      test('should handle corrupted settings data gracefully', () async {
        // Set invalid data type for volume
        await prefs.setString('settings_volume', 'invalid');

        await settings.loadSettings();

        // Should fall back to default
        expect(settings.volume, 0.5);
      });

      test('should handle missing settings keys', () async {
        // Don't set any keys, just load
        await settings.loadSettings();

        // Should use all defaults
        expect(settings.proximitySensorEnabled, true);
        expect(settings.hapticFeedbackEnabled, true);
        expect(settings.soundsEnabled, true);
        expect(settings.beepEnabled, true);
        expect(settings.achievementSoundEnabled, true);
        expect(settings.volume, 0.5);
      });

      test('should notify listeners when settings change', () async {
        await settings.loadSettings();

        bool notified = false;
        settings.addListener(() {
          notified = true;
        });

        await settings.setProximitySensorEnabled(false);

        expect(notified, true);
      });
    });

    group('Language Setting', () {
      test('appLanguage defaults to IT', () async {
        await settings.loadSettings();
        expect(settings.appLanguage, 'it');
      });

      test('should set and persist language to EN', () async {
        await settings.loadSettings();
        await settings.setAppLanguage('en');

        expect(settings.appLanguage, 'en');

        // Create new instance to verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.appLanguage, 'en');
      });

      test('should set and persist language to IT', () async {
        await settings.loadSettings();
        await settings.setAppLanguage('en');
        await settings.setAppLanguage('it');

        expect(settings.appLanguage, 'it');

        // Verify persistence
        final newSettings = AppSettingsService(prefs: prefs);
        await newSettings.loadSettings();
        expect(newSettings.appLanguage, 'it');
      });

      test('should load language from storage', () async {
        // Manually set language in SharedPreferences
        await prefs.setString('settings_app_language', 'en');

        await settings.loadSettings();

        expect(settings.appLanguage, 'en');
      });

      test('should fall back to IT for invalid language', () async {
        // Set invalid language code
        await prefs.setString('settings_app_language', 'fr');

        await settings.loadSettings();

        // Should fall back to default 'it'
        expect(settings.appLanguage, 'it');
      });

      test('should notify listeners when language changes', () async {
        await settings.loadSettings();

        bool notified = false;
        settings.addListener(() {
          notified = true;
        });

        await settings.setAppLanguage('en');

        expect(notified, true);
      });

      test('should not notify if language is the same', () async {
        await settings.loadSettings();

        bool notified = false;
        settings.addListener(() {
          notified = true;
        });

        await settings.setAppLanguage('it'); // Same as default

        expect(notified, false);
      });

      test('should include language in resetToDefaults', () async {
        await settings.loadSettings();
        await settings.setAppLanguage('en');

        await settings.resetToDefaults();

        expect(settings.appLanguage, 'it');
      });
    });
  });
}
