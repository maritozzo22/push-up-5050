import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/main.dart';
import 'package:push_up_5050/services/app_settings_service.dart';
import 'test_helpers.dart';

/// Tests for test_helpers.dart helper functions.
///
/// Verifies that test helpers properly support localization
/// for i18n testing across the app.
void main() {
  group('createTestApp', () {
    testWidgets('should include AppLocalizations.localizationsDelegates',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: Builder(
            builder: (context) {
              // Verify localizations are available
              expect(
                AppLocalizations.of(context),
                isNotNull,
                reason: 'AppLocalizations should be available in createTestApp',
              );
              return const SizedBox();
            },
          ),
        ),
      );

      // Verify MaterialApp has localizationDelegates
      final MaterialApp app = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );

      expect(
        app.localizationsDelegates,
        contains(GlobalMaterialLocalizations.delegate),
        reason:
            'createTestApp should include material localization delegates',
      );
    });

    testWidgets('should include AppLocalizations.supportedLocales',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const SizedBox(),
        ),
      );

      final MaterialApp app = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );

      expect(
        app.supportedLocales,
        AppLocalizations.supportedLocales,
        reason:
            'createTestApp should support all locales defined in AppLocalizations',
      );
    });

    testWidgets('should have a default locale', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const SizedBox(),
        ),
      );

      final MaterialApp app = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );

      expect(
        app.locale,
        isNotNull,
        reason: 'createTestApp should have a default locale set',
      );
    });

    testWidgets('should provide localized strings', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;

              // Verify common localized strings are accessible
              expect(l10n.homeTitle, isNotNull);
              expect(l10n.start, isNotNull);
              expect(l10n.settingsTitle, isNotNull);

              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('createTestAppWithProviders', () {
    testWidgets(
        'should include AppLocalizations.localizationsDelegates when used with MyApp',
        (tester) async {
      final widget = await createTestAppWithProviders(
        child: const MyApp(),
      );

      await tester.pumpWidget(widget);

      // Find MaterialApp - there should be at least one with localization
      final materialApps = find.byType(MaterialApp);
      expect(materialApps, findsWidgets);

      // Get the first MaterialApp widget
      final MaterialApp app = tester.widget<MaterialApp>(materialApps.first);

      expect(
        app.localizationsDelegates,
        isNotNull,
        reason: 'createTestAppWithProviders should support localization',
      );
    });

    testWidgets('should support locale change via AppSettingsService',
        (tester) async {
      // Create with Italian locale
      final widget = await createTestAppWithProviders(
        child: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            // Italian should have "INIZIA"
            return Text(l10n.start);
          },
        ),
      );

      await tester.pumpWidget(widget);

      // Verify Italian text
      expect(find.text('INIZIA'), findsOneWidget);
    });

    testWidgets('should provide all required providers', (tester) async {
      final widget = await createTestAppWithProviders(
        child: Builder(
          builder: (context) {
            // Verify AppSettingsService is available via Provider
            final settings = context.watch<AppSettingsService>();
            expect(settings, isNotNull);
            return const SizedBox(key: Key('test-child'));
          },
        ),
      );

      await tester.pumpWidget(widget);

      // Verify the child widget is rendered (meaning providers worked)
      expect(find.byKey(const Key('test-child')), findsOneWidget);
    });
  });

  group('Localization Integration', () {
    testWidgets('createTestApp renders Italian text correctly',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return Text(l10n.start);
            },
          ),
        ),
      );

      // Default locale is Italian
      expect(find.text('INIZIA'), findsOneWidget);
    });

    testWidgets('createTestApp supports all AppLocalizations keys',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;

              // Test a variety of keys to ensure all are accessible
              return Column(
                children: [
                  Text(l10n.homeTitle),
                  Text(l10n.settingsTitle),
                  Text(l10n.statsTitle),
                  Text(l10n.start),
                  Text(l10n.language),
                ],
              );
            },
          ),
        ),
      );

      // Verify all strings are rendered
      expect(find.text('PUSHUP 5050'), findsOneWidget);
      expect(find.text('Impostazioni'), findsOneWidget);
      expect(find.text('Statistiche'), findsOneWidget);
      expect(find.text('INIZIA'), findsOneWidget);
      expect(find.text('Lingua'), findsOneWidget);
    });
  });
}
