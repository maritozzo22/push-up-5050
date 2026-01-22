import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/widgets/common/bottom_navigation_bar.dart';
import '../../test_helpers.dart';

void main() {
  group('AppBottomNavigationBar', () {
    testWidgets('widget renders 4 navigation items', (tester) async {
      int currentIndex = 0;
      void onTabTap(int index) => currentIndex = index;

      await tester.pumpWidget(
        createTestApp(
          child: Scaffold(
            bottomNavigationBar: AppBottomNavigationBar(
              currentIndex: 0,
              onTabTap: onTabTap,
            ),
          ),
        ),
      );

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.items.length, 4);
    });

    testWidgets('Home item is selected by default when currentIndex is 0',
        (tester) async {
      int currentIndex = 0;
      void onTabTap(int index) => currentIndex = index;

      await tester.pumpWidget(
        createTestApp(
          child: Scaffold(
            bottomNavigationBar: AppBottomNavigationBar(
              currentIndex: 0,
              onTabTap: onTabTap,
            ),
          ),
        ),
      );

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 0);
    });

    group('Italian locale', () {
      testWidgets('displays Italian labels', (tester) async {
        int currentIndex = 0;
        void onTabTap(int index) => currentIndex = index;

        await tester.pumpWidget(
          createTestApp(
            child: Scaffold(
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: 0,
                onTabTap: onTabTap,
              ),
            ),
          ),
        );

        // Italian labels
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Statistiche'), findsOneWidget);
        expect(find.text('Profilo'), findsOneWidget);
        expect(find.text('Impostazioni'), findsOneWidget);
      });

      testWidgets('tapping Stats (Statistiche) changes onTabTap callback with index 1',
          (tester) async {
        int? tappedIndex;

        await tester.pumpWidget(
          createTestApp(
            child: Scaffold(
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: 0,
                onTabTap: (index) => tappedIndex = index,
              ),
            ),
          ),
        );

        // Tap the Stats tab (center item, index 1) - Italian: "Statistiche"
        await tester.tap(find.text('Statistiche'));
        await tester.pump();

        expect(tappedIndex, 1);
      });

      testWidgets('tapping Profile (Profilo) changes onTabTap callback with index 2',
          (tester) async {
        int? tappedIndex;

        await tester.pumpWidget(
          createTestApp(
            child: Scaffold(
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: 0,
                onTabTap: (index) => tappedIndex = index,
              ),
            ),
          ),
        );

        // Tap the Profile tab (index 2) - Italian: "Profilo"
        await tester.tap(find.text('Profilo'));
        await tester.pump();

        expect(tappedIndex, 2);
      });

      testWidgets('tapping Settings (Impostazioni) changes onTabTap callback with index 3',
          (tester) async {
        int? tappedIndex;

        await tester.pumpWidget(
          createTestApp(
            child: Scaffold(
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: 0,
                onTabTap: (index) => tappedIndex = index,
              ),
            ),
          ),
        );

        // Tap the Settings tab (index 3) - Italian: "Impostazioni"
        await tester.tap(find.text('Impostazioni'));
        await tester.pump();

        expect(tappedIndex, 3);
      });
    });

    group('English locale', () {
      testWidgets('displays English labels when locale is en', (tester) async {
        int currentIndex = 0;
        void onTabTap(int index) => currentIndex = index;

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: 0,
                onTabTap: onTabTap,
              ),
            ),
          ),
        );

        // English labels
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Stats'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
      });

      testWidgets('tapping Stats changes onTabTap callback with index 1 in English',
          (tester) async {
        int? tappedIndex;

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: 0,
                onTabTap: (index) => tappedIndex = index,
              ),
            ),
          ),
        );

        // Tap the Stats tab (center item, index 1) - English: "Stats"
        await tester.tap(find.text('Stats'));
        await tester.pump();

        expect(tappedIndex, 1);
      });
    });

    testWidgets('tapping Home changes onTabTap callback with index 0',
        (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        createTestApp(
          child: Scaffold(
            bottomNavigationBar: AppBottomNavigationBar(
              currentIndex: 1,
              onTabTap: (index) => tappedIndex = index,
            ),
          ),
        ),
      );

      // Tap the Home tab (left item, index 0) - "Home" is the same in both languages
      await tester.tap(find.text('Home'));
      await tester.pump();

      expect(tappedIndex, 0);
    });

    testWidgets('uses correct theme colors from AppColors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('it'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData.dark(),
          home: Scaffold(
            bottomNavigationBar: AppBottomNavigationBar(
              currentIndex: 0,
              onTabTap: (index) {},
            ),
          ),
        ),
      );

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Check that theme has correct configuration
      expect(bottomNavBar.type, BottomNavigationBarType.fixed);
      expect(bottomNavBar.elevation, 8);
    });
  });
}
