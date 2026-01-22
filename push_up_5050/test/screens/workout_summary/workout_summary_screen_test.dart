import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/screens/workout_summary/workout_summary_screen.dart';

/// Helper to create a MaterialApp with localization support for WorkoutSummaryScreen tests.
Widget createSummaryTestApp({
  required Widget child,
  Locale locale = const Locale('it'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  group('WorkoutSummaryScreen Widget Tests', () {
    // Test data
    final testDuration = Duration(minutes: 5, seconds: 30);
    final testAchievement = Achievement(
      id: 'first_pushup',
      name: 'Primo Passo',
      description: 'Completa il tuo primo push-up',
      points: 50,
      icon: '🎯',
    )..unlock();

    testWidgets('widget builds without errors', (tester) async {
      await tester.pumpWidget(
        createSummaryTestApp(
          child: WorkoutSummaryScreen(
            seriesStart: 1,
            seriesCompleted: 5,
            totalReps: 15,
            totalKcal: 6.75,
            totalDuration: testDuration,
            pointsEarned: 200,
            streakMultiplier: 1.2,
            newlyUnlockedAchievements: [],
          ),
        ),
      );

      expect(find.byType(WorkoutSummaryScreen), findsOneWidget);
    });

    testWidgets('displays workout complete title', (tester) async {
      await tester.pumpWidget(
        createSummaryTestApp(
          child: WorkoutSummaryScreen(
            seriesStart: 1,
            seriesCompleted: 5,
            totalReps: 15,
            totalKcal: 6.75,
            totalDuration: testDuration,
            pointsEarned: 200,
            streakMultiplier: 1.2,
            newlyUnlockedAchievements: [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Allenamento Completato!'), findsOneWidget);
    });

    testWidgets('displays correct statistics', (tester) async {
      await tester.pumpWidget(
        createSummaryTestApp(
          child: WorkoutSummaryScreen(
            seriesStart: 1,
            seriesCompleted: 5,
            totalReps: 15,
            totalKcal: 6.75,
            totalDuration: testDuration,
            pointsEarned: 200,
            streakMultiplier: 1.2,
            newlyUnlockedAchievements: [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Series range
      expect(find.text('1-5'), findsOneWidget);
      // Total reps
      expect(find.textContaining('15'), findsWidgets);
      // Kcal (6.75 rounded to 6.8 with toStringAsFixed(1))
      expect(find.text('6.8'), findsOneWidget);
    });

    testWidgets('formats duration correctly', (tester) async {
      await tester.pumpWidget(
        createSummaryTestApp(
          child: WorkoutSummaryScreen(
            seriesStart: 1,
            seriesCompleted: 5,
            totalReps: 15,
            totalKcal: 6.75,
            totalDuration: testDuration, // 5:30
            pointsEarned: 200,
            streakMultiplier: 1.2,
            newlyUnlockedAchievements: [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('00:05:30'), findsOneWidget);
    });

    testWidgets('formats duration with hours correctly', (tester) async {
      final longDuration = Duration(hours: 1, minutes: 5, seconds: 30);

      await tester.pumpWidget(
        createSummaryTestApp(
          child: WorkoutSummaryScreen(
            seriesStart: 1,
            seriesCompleted: 5,
            totalReps: 15,
            totalKcal: 6.75,
            totalDuration: longDuration,
            pointsEarned: 200,
            streakMultiplier: 1.2,
            newlyUnlockedAchievements: [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('01:05:30'), findsOneWidget);
    });

    testWidgets('displays points with multiplier', (tester) async {
      await tester.pumpWidget(
        createSummaryTestApp(
          child: WorkoutSummaryScreen(
            seriesStart: 1,
            seriesCompleted: 5,
            totalReps: 15,
            totalKcal: 6.75,
            totalDuration: testDuration,
            pointsEarned: 200,
            streakMultiplier: 1.2,
            newlyUnlockedAchievements: [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('200'), findsOneWidget);
      expect(find.textContaining('1.2'), findsOneWidget);
      expect(find.text('Punti Guadagnati'), findsOneWidget);
      expect(find.text('Moltiplicatore Streak'), findsOneWidget);
    });

    testWidgets('shows newly unlocked achievements', (tester) async {
      await tester.pumpWidget(
        createSummaryTestApp(
          child: WorkoutSummaryScreen(
            seriesStart: 1,
            seriesCompleted: 5,
            totalReps: 15,
            totalKcal: 6.75,
            totalDuration: testDuration,
            pointsEarned: 200,
            streakMultiplier: 1.2,
            newlyUnlockedAchievements: [testAchievement],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Primo Passo'), findsOneWidget);
      expect(find.text('Completa il tuo primo push-up'), findsOneWidget);
      expect(find.text('🎯'), findsOneWidget);
      expect(find.text('Nuovi Sbloccati'), findsOneWidget);
    });

    testWidgets('hides achievements section when none unlocked', (tester) async {
      await tester.pumpWidget(
        createSummaryTestApp(
          child: WorkoutSummaryScreen(
            seriesStart: 1,
            seriesCompleted: 5,
            totalReps: 15,
            totalKcal: 6.75,
            totalDuration: testDuration,
            pointsEarned: 200,
            streakMultiplier: 1.2,
            newlyUnlockedAchievements: [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nuovi Sbloccati'), findsNothing);
      expect(
        find.text('Nessun achievement sbloccato questa volta'),
        findsNothing,
      );
    });

    testWidgets('continue button returns to home', (tester) async {
      await tester.pumpWidget(
        createSummaryTestApp(
          child: WorkoutSummaryScreen(
            seriesStart: 1,
            seriesCompleted: 5,
            totalReps: 15,
            totalKcal: 6.75,
            totalDuration: testDuration,
            pointsEarned: 200,
            streakMultiplier: 1.2,
            newlyUnlockedAchievements: [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final continueButton = find.text('CONTINUA');
      expect(continueButton, findsOneWidget);

      // Verify button is tappable (doesn't throw)
      await tester.tap(continueButton);
      await tester.pump();
    });

    testWidgets('uses dark theme colors', (tester) async {
      await tester.pumpWidget(
        createSummaryTestApp(
          child: WorkoutSummaryScreen(
            seriesStart: 1,
            seriesCompleted: 5,
            totalReps: 15,
            totalKcal: 6.75,
            totalDuration: testDuration,
            pointsEarned: 200,
            streakMultiplier: 1.2,
            newlyUnlockedAchievements: [],
          ),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        scaffold.backgroundColor?.value,
        0xFF1A1A1A,
      ); // AppColors.background
    });

    group('WorkoutSummaryScreen - I18n', () {
      testWidgets('displays Italian text correctly', (tester) async {
        await tester.pumpWidget(
          createSummaryTestApp(
            locale: const Locale('it'),
            child: WorkoutSummaryScreen(
              seriesStart: 1,
              seriesCompleted: 5,
              totalReps: 15,
              totalKcal: 6.75,
              totalDuration: testDuration,
              pointsEarned: 200,
              streakMultiplier: 1.2,
              newlyUnlockedAchievements: [],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Allenamento Completato!'), findsOneWidget);
        expect(find.text('Serie Completate'), findsOneWidget);
        expect(find.text('Tempo Impiegato'), findsOneWidget);
        expect(find.text('Punti Guadagnati'), findsOneWidget);
        expect(find.text('Moltiplicatore Streak'), findsOneWidget);
        expect(find.text('CONTINUA'), findsOneWidget);
      });

      testWidgets('displays English text correctly', (tester) async {
        await tester.pumpWidget(
          createSummaryTestApp(
            locale: const Locale('en'),
            child: WorkoutSummaryScreen(
              seriesStart: 1,
              seriesCompleted: 5,
              totalReps: 15,
              totalKcal: 6.75,
              totalDuration: testDuration,
              pointsEarned: 200,
              streakMultiplier: 1.2,
              newlyUnlockedAchievements: [],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Workout Complete!'), findsOneWidget);
        expect(find.text('Series Completed'), findsOneWidget);
        expect(find.text('Time Spent'), findsOneWidget);
        expect(find.text('Points Earned'), findsOneWidget);
        expect(find.text('Streak Multiplier'), findsOneWidget);
        expect(find.text('CONTINUE'), findsOneWidget);
      });

      testWidgets('displays series range correctly in Italian', (tester) async {
        await tester.pumpWidget(
          createSummaryTestApp(
            locale: const Locale('it'),
            child: WorkoutSummaryScreen(
              seriesStart: 2,
              seriesCompleted: 3,
              totalReps: 10,
              totalKcal: 4.5,
              totalDuration: testDuration,
              pointsEarned: 100,
              streakMultiplier: 1.0,
              newlyUnlockedAchievements: [],
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should show 2-4 (start to start+completed)
        expect(find.text('2-4'), findsOneWidget);
      });

      testWidgets('displays series range correctly in English', (tester) async {
        await tester.pumpWidget(
          createSummaryTestApp(
            locale: const Locale('en'),
            child: WorkoutSummaryScreen(
              seriesStart: 5,
              seriesCompleted: 3,
              totalReps: 10,
              totalKcal: 4.5,
              totalDuration: testDuration,
              pointsEarned: 100,
              streakMultiplier: 1.0,
              newlyUnlockedAchievements: [],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('5-7'), findsOneWidget);
      });
    });

    group('WorkoutSummaryScreen - Edge Cases', () {
      testWidgets('handles zero push-ups correctly', (tester) async {
        await tester.pumpWidget(
          createSummaryTestApp(
            child: WorkoutSummaryScreen(
              seriesStart: 1,
              seriesCompleted: 0,
              totalReps: 0,
              totalKcal: 0.0,
              totalDuration: Duration(seconds: 30),
              pointsEarned: 0,
              streakMultiplier: 1.0,
              newlyUnlockedAchievements: [],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('0'), findsWidgets);
        expect(find.text('00:00:30'), findsOneWidget);
      });

      testWidgets('handles very short duration correctly', (tester) async {
        await tester.pumpWidget(
          createSummaryTestApp(
            child: WorkoutSummaryScreen(
              seriesStart: 1,
              seriesCompleted: 1,
              totalReps: 1,
              totalKcal: 0.45,
              totalDuration: Duration(seconds: 5),
              pointsEarned: 10,
              streakMultiplier: 1.0,
              newlyUnlockedAchievements: [],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('00:00:05'), findsOneWidget);
      });

      testWidgets('displays multiple achievements', (tester) async {
        final achievement2 = Achievement(
          id: 'ten_in_a_row',
          name: 'Dieci in Un Row',
          description: 'Completa 10 push-up in una singola serie',
          points: 150,
          icon: '💪',
        )..unlock();

        await tester.pumpWidget(
          createSummaryTestApp(
            child: WorkoutSummaryScreen(
              seriesStart: 1,
              seriesCompleted: 5,
              totalReps: 15,
              totalKcal: 6.75,
              totalDuration: testDuration,
              pointsEarned: 200,
              streakMultiplier: 1.2,
              newlyUnlockedAchievements: [testAchievement, achievement2],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Primo Passo'), findsOneWidget);
        expect(find.text('Dieci in Un Row'), findsOneWidget);
        expect(find.text('🎯'), findsOneWidget);
        expect(find.text('💪'), findsOneWidget);
      });

      testWidgets('handles high multiplier values', (tester) async {
        await tester.pumpWidget(
          createSummaryTestApp(
            child: WorkoutSummaryScreen(
              seriesStart: 1,
              seriesCompleted: 10,
              totalReps: 100,
              totalKcal: 45.0,
              totalDuration: testDuration,
              pointsEarned: 1000,
              streakMultiplier: 2.0,
              newlyUnlockedAchievements: [],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('2.0'), findsOneWidget);
      });
    });
  });
}
