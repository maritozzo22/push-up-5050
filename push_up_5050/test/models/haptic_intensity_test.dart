import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/haptic_intensity.dart';

void main() {
  group('HapticIntensity - i18n', () {
    group('localizedLabel (Italian)', () {
      testWidgets('returns "Spento" for HapticIntensity.off',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('it'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                expect(
                  HapticIntensity.off.localizedLabel(context),
                  'Spento',
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns "Leggero" for HapticIntensity.light',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('it'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                expect(
                  HapticIntensity.light.localizedLabel(context),
                  'Leggero',
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns "Medio" for HapticIntensity.medium',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('it'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                expect(
                  HapticIntensity.medium.localizedLabel(context),
                  'Medio',
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('localizedLabel (English)', () {
      testWidgets('returns "Off" for HapticIntensity.off', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                expect(
                  HapticIntensity.off.localizedLabel(context),
                  'Off',
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns "Light" for HapticIntensity.light',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                expect(
                  HapticIntensity.light.localizedLabel(context),
                  'Light',
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns "Medium" for HapticIntensity.medium',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                expect(
                  HapticIntensity.medium.localizedLabel(context),
                  'Medium',
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });
  });
}
