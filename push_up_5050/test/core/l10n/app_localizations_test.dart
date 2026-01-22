import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/l10n/app_localizations_en.dart';
import 'package:push_up_5050/l10n/app_localizations_it.dart';

void main() {
  group('AppLocalizations', () {
    late AppLocalizations itLocalizations;
    late AppLocalizations enLocalizations;

    setUp(() {
      itLocalizations = AppLocalizationsIt();
      enLocalizations = AppLocalizationsEn();
    });

    group('Italian translations', () {
      test('appName returns PUSHUP 5050', () {
        expect(itLocalizations.appName, 'PUSHUP 5050');
      });

      test('homeTitle returns PUSHUP 5050', () {
        expect(itLocalizations.homeTitle, 'PUSHUP 5050');
      });

      test('start returns INIZIA', () {
        expect(itLocalizations.start, 'INIZIA');
      });

      test('settingsTitle returns Impostazioni', () {
        expect(itLocalizations.settingsTitle, 'Impostazioni');
      });

      test('todayPushups with placeholder works correctly', () {
        expect(itLocalizations.todayPushups(15), 'OGGI: 15 PUSHUP');
      });

      test('dayXofY with placeholders works correctly', () {
        expect(itLocalizations.dayXofY(5, 30), 'Giorno 5 di 30');
      });

      test('achievementPoints with placeholder works correctly', () {
        expect(itLocalizations.achievementPoints(100), '+100 punti');
      });

      test('achievementUnlocked with placeholder works correctly', () {
        expect(itLocalizations.achievementUnlocked('Prima Serie'), 'Prima Serie');
      });

      test('level names are correct', () {
        expect(itLocalizations.levelBeginner, 'Beginner');
        expect(itLocalizations.levelIntermediate, 'Intermediate');
        expect(itLocalizations.levelAdvanced, 'Advanced');
        expect(itLocalizations.levelExpert, 'Expert');
        expect(itLocalizations.levelMaster, 'Master');
      });

      test('haptic intensity labels are correct', () {
        expect(itLocalizations.hapticOff, 'Spento');
        expect(itLocalizations.hapticLight, 'Leggero');
        expect(itLocalizations.hapticMedium, 'Medio');
      });
    });

    group('English translations', () {
      test('appName returns PUSHUP 5050', () {
        expect(enLocalizations.appName, 'PUSHUP 5050');
      });

      test('homeTitle returns PUSHUP 5050', () {
        expect(enLocalizations.homeTitle, 'PUSHUP 5050');
      });

      test('start returns START', () {
        expect(enLocalizations.start, 'START');
      });

      test('settingsTitle returns Settings', () {
        expect(enLocalizations.settingsTitle, 'Settings');
      });

      test('todayPushups with placeholder works correctly', () {
        expect(enLocalizations.todayPushups(15), 'TODAY: 15 PUSHUP');
      });

      test('dayXofY with placeholders works correctly', () {
        expect(enLocalizations.dayXofY(5, 30), 'Day 5 of 30');
      });

      test('achievementPoints with placeholder works correctly', () {
        expect(enLocalizations.achievementPoints(100), '+100 points');
      });

      test('achievementUnlocked with placeholder works correctly', () {
        expect(enLocalizations.achievementUnlocked('First Series'), 'First Series');
      });

      test('haptic intensity labels are correct', () {
        expect(enLocalizations.hapticOff, 'Off');
        expect(enLocalizations.hapticLight, 'Light');
        expect(enLocalizations.hapticMedium, 'Medium');
      });
    });

    group('AppLocalizations configuration', () {
      test('supportedLocales contains IT and EN', () {
        expect(AppLocalizations.supportedLocales.length, 2);
        final localeCodes = AppLocalizations.supportedLocales
            .map((locale) => locale.toString())
            .toSet();
        expect(localeCodes, containsAll(['it', 'en']));
      });

      test('localizationsDelegates is not empty', () {
        expect(AppLocalizations.localizationsDelegates.isNotEmpty, true);
        expect(AppLocalizations.localizationsDelegates.length, greaterThan(1));
      });

      test('delegate is _AppLocalizationsDelegate', () {
        expect(AppLocalizations.delegate, isA<LocalizationsDelegate<AppLocalizations>>());
      });
    });
  });
}
