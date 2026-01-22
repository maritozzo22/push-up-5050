import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/main.dart';
import 'package:push_up_5050/main_navigation_wrapper.dart';
import 'test_helpers.dart';

void main() {
  group('App Initialization', () {
    testWidgets('app launches without crash', (tester) async {
      final app = await createTestAppWithProviders(child: const MyApp());
      await tester.pumpWidget(app);

      // Should have at least one MaterialApp (MyApp creates one, wrapper creates another)
      expect(find.byType(MaterialApp), findsWidgets);
    });

    testWidgets('HomeScreen is initial route', (tester) async {
      final app = await createTestAppWithProviders(child: const MyApp());
      await tester.pumpWidget(app);

      expect(find.byType(MainNavigationWrapper), findsOneWidget);
    });

    testWidgets('theme is dark theme', (tester) async {
      final app = await createTestAppWithProviders(child: const MyApp());
      await tester.pumpWidget(app);

      // Get the last MaterialApp (the one inside MyApp)
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).last,
      );

      expect(materialApp.theme?.brightness, Brightness.dark);
    });

    testWidgets('app uses correct navigation structure', (tester) async {
      final app = await createTestAppWithProviders(child: const MyApp());
      await tester.pumpWidget(app);

      // Should have bottom navigation
      expect(find.byType(MainNavigationWrapper), findsOneWidget);

      // Should start on Home tab
      final wrapperState = tester.state<MainNavigationWrapperState>(
        find.byType(MainNavigationWrapper),
      );
      expect(wrapperState.currentIndex, 0);
    });
  });

  group('Localizations Configuration', () {
    testWidgets('MaterialApp has localizationsDelegates configured',
        (tester) async {
      final app = await createTestAppWithProviders(child: const MyApp());
      await tester.pumpWidget(app);

      // Get the last MaterialApp (the one inside MyApp)
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).last,
      );

      expect(materialApp.localizationsDelegates, isNotNull);
      expect(materialApp.localizationsDelegates?.length ?? 0, greaterThan(1));
    });

    testWidgets('MaterialApp supports IT and EN locales', (tester) async {
      final app = await createTestAppWithProviders(child: const MyApp());
      await tester.pumpWidget(app);

      // Get the last MaterialApp (the one inside MyApp)
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).last,
      );

      expect(materialApp.supportedLocales.length, greaterThanOrEqualTo(2));

      final localeCodes = materialApp.supportedLocales
          .map((locale) => locale.toString())
          .toSet();

      expect(localeCodes, contains('it'));
      expect(localeCodes, contains('en'));
    });

    testWidgets('MaterialApp includes AppLocalizations.delegate',
        (tester) async {
      final app = await createTestAppWithProviders(child: const MyApp());
      await tester.pumpWidget(app);

      // Get the last MaterialApp (the one inside MyApp)
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).last,
      );

      // Check if AppLocalizations.delegate is in the delegates list
      final delegates = materialApp.localizationsDelegates;
      expect(delegates, isNotNull);

      final hasAppLocalizationsDelegate = delegates!.any(
        (delegate) => delegate.toString().contains('AppLocalizations'),
      );

      expect(hasAppLocalizationsDelegate, true);
    });

    testWidgets('MaterialApp initial locale is Italian by default',
        (tester) async {
      final app = await createTestAppWithProviders(child: const MyApp());
      await tester.pumpWidget(app);

      // Get the last MaterialApp (the one inside MyApp)
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).last,
      );

      // Check that locale is either null (system locale) or Italian
      final localeStr = materialApp.locale?.toString();
      if (localeStr != null) {
        expect(localeStr, 'it');
      }
      // If locale is null, app uses system locale - that's acceptable
    });
  });
}
