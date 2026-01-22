import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/widgets/workout/recovery_timer_bar.dart';

/// Helper to create a MaterialApp with localization support for RecoveryTimerBar tests.
Widget createRecoveryTestApp({
  required Widget child,
  Locale locale = const Locale('it'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('RecoveryTimerBar Widget', () {
    // Clean up state between tests to prevent cross-test pollution
    tearDown(() {
      // Reset any test-specific state
    });

    testWidgets('displays series label (Serie X di Y)', (tester) async {
      await tester.pumpWidget(
        createRecoveryTestApp(
          child: const RecoveryTimerBar(
            currentSeries: 3,
            totalSeries: 5,
            remainingSeconds: 6,
            totalRestTime: 10,
          ),
        ),
      );

      expect(find.text('Serie 3 di 5'), findsOneWidget);
    });

    testWidgets('displays correct percentage', (tester) async {
      await tester.pumpWidget(
        createRecoveryTestApp(
          child: const RecoveryTimerBar(
            currentSeries: 2,
            totalSeries: 5,
            remainingSeconds: 5,
            totalRestTime: 10,
          ),
        ),
      );

      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('shows green color when 100-66% remaining', (tester) async {
      await tester.pumpWidget(
        createRecoveryTestApp(
          child: const RecoveryTimerBar(
            currentSeries: 1,
            totalSeries: 5,
            remainingSeconds: 8,
            totalRestTime: 10,
          ),
        ),
      );

      // Pump and settle to let animations complete
      await tester.pumpAndSettle();

      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(progressIndicator.value, 0.8);
      expect(progressIndicator.color, const Color(0xFF4CAF50)); // Green
    });

    testWidgets('shows orange color when 66-33% remaining', (tester) async {
      await tester.pumpWidget(
        createRecoveryTestApp(
          child: const RecoveryTimerBar(
            currentSeries: 1,
            totalSeries: 5,
            remainingSeconds: 5,
            totalRestTime: 10,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(progressIndicator.value, 0.5);
      expect(progressIndicator.color, const Color(0xFFFF9800)); // Orange
    });

    testWidgets('shows red color when 33-5% remaining', (tester) async {
      await tester.pumpWidget(
        createRecoveryTestApp(
          child: const RecoveryTimerBar(
            currentSeries: 1,
            totalSeries: 5,
            remainingSeconds: 2,
            totalRestTime: 10,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(progressIndicator.value, 0.2);
      expect(progressIndicator.color, const Color(0xFFF44336)); // Red
    });

    testWidgets('has correct height (12px)', (tester) async {
      await tester.pumpWidget(
        createRecoveryTestApp(
          child: const RecoveryTimerBar(
            currentSeries: 1,
            totalSeries: 5,
            remainingSeconds: 5,
            totalRestTime: 10,
          ),
        ),
      );

      // Find Container with height 12 (background of progress bar)
      final containers = find.byType(Container);
      bool foundHeight12 = false;
      for (final element in containers.evaluate()) {
        final container = element.widget as Container;
        if (container.constraints?.minHeight == 12 ||
            container.constraints?.maxHeight == 12) {
          foundHeight12 = true;
          break;
        }
      }
      expect(foundHeight12, isTrue);
    });

    testWidgets('has correct border radius (6px)', (tester) async {
      await tester.pumpWidget(
        createRecoveryTestApp(
          child: const RecoveryTimerBar(
            currentSeries: 1,
            totalSeries: 5,
            remainingSeconds: 5,
            totalRestTime: 10,
          ),
        ),
      );

      // Find Container with borderRadius 6
      final containers = find.byType(Container);
      bool foundRadius6 = false;
      for (final element in containers.evaluate()) {
        final container = element.widget as Container;
        final decoration = container.decoration as BoxDecoration?;
        if (decoration?.borderRadius == BorderRadius.circular(6)) {
          foundRadius6 = true;
          break;
        }
      }
      expect(foundRadius6, isTrue);
    });
  });

  group('RecoveryTimerBar - I18n', () {
    testWidgets('displays series label in Italian', (tester) async {
      await tester.pumpWidget(
        createRecoveryTestApp(
          child: const RecoveryTimerBar(
            currentSeries: 3,
            totalSeries: 5,
            remainingSeconds: 6,
            totalRestTime: 10,
          ),
        ),
      );
      expect(find.text('Serie 3 di 5'), findsOneWidget);
    });

    testWidgets('displays series label in English', (tester) async {
      await tester.pumpWidget(
        createRecoveryTestApp(
          locale: const Locale('en'),
          child: const RecoveryTimerBar(
            currentSeries: 3,
            totalSeries: 5,
            remainingSeconds: 6,
            totalRestTime: 10,
          ),
        ),
      );
      expect(find.text('Series 3 of 5'), findsOneWidget);
    });

    testWidgets('displays different series numbers correctly in Italian',
        (tester) async {
      await tester.pumpWidget(
        createRecoveryTestApp(
          child: const RecoveryTimerBar(
            currentSeries: 7,
            totalSeries: 10,
            remainingSeconds: 5,
            totalRestTime: 10,
          ),
        ),
      );
      expect(find.text('Serie 7 di 10'), findsOneWidget);
    });

    testWidgets('displays different series numbers correctly in English',
        (tester) async {
      await tester.pumpWidget(
        createRecoveryTestApp(
          locale: const Locale('en'),
          child: const RecoveryTimerBar(
            currentSeries: 7,
            totalSeries: 10,
            remainingSeconds: 5,
            totalRestTime: 10,
          ),
        ),
      );
      expect(find.text('Series 7 of 10'), findsOneWidget);
    });
  });
}
