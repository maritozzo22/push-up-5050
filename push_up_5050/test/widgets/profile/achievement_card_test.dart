import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/widgets/profile/achievement_card.dart';

/// Helper to create MaterialApp with localization support for AchievementCard tests.
Widget createAchievementCardTestApp({
  required Widget child,
}) {
  return MaterialApp(
    locale: const Locale('it'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: child,
    ),
  );
}

void main() {
  group('AchievementCard Rendering', () {
    testWidgets('displays achievement icon correctly', (tester) async {
      final achievement = Achievement(
        id: 'test_achievement',
        name: 'Test Achievement',
        description: 'Test description',
        points: 100,
        icon: '🎯',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('🎯'),
            ),
          ),
        ),
      );

      expect(find.text('🎯'), findsOneWidget);
    });

    testWidgets('displays achievement name and description', (tester) async {
      final achievement = Achievement(
        id: 'test_achievement',
        name: 'Primo Passo',
        description: 'Completa il tuo primo push-up',
        points: 50,
        icon: '🎯',
      );

      await tester.pumpWidget(
        createAchievementCardTestApp(
          child: AchievementCard(achievement: achievement),
        ),
      );

      expect(find.text('Primo Passo'), findsOneWidget);
      expect(find.text('Completa il tuo primo push-up'), findsOneWidget);
    });

    testWidgets('displays points for unlocked achievement', (tester) async {
      final achievement = Achievement(
        id: 'test_achievement',
        name: 'Test',
        description: 'Test',
        points: 150,
        icon: '🎯',
        isUnlocked: true,
      );

      await tester.pumpWidget(
        createAchievementCardTestApp(
          child: AchievementCard(achievement: achievement),
        ),
      );

      expect(find.text('+150 punti'), findsOneWidget);
    });

    testWidgets('shows lock overlay for locked achievement', (tester) async {
      final achievement = Achievement(
        id: 'test_achievement',
        name: 'Test',
        description: 'Test',
        points: 100,
        icon: '🎯',
        isUnlocked: false,
      );

      await tester.pumpWidget(
        createAchievementCardTestApp(
          child: AchievementCard(achievement: achievement),
        ),
      );

      // Find lock icon
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('shows unlock date for unlocked achievement', (tester) async {
      final achievement = Achievement(
        id: 'test_achievement',
        name: 'Test',
        description: 'Test',
        points: 100,
        icon: '🎯',
        isUnlocked: true,
        unlockedAt: DateTime(2024, 1, 15),
      );

      await tester.pumpWidget(
        createAchievementCardTestApp(
          child: AchievementCard(achievement: achievement),
        ),
      );

      expect(find.textContaining('15/1/2024'), findsOneWidget);
    });

    testWidgets('has correct card dimensions and border radius',
        (tester) async {
      final achievement = Achievement(
        id: 'test_achievement',
        name: 'Test',
        description: 'Test',
        points: 100,
        icon: '🎯',
      );

      await tester.pumpWidget(
        createAchievementCardTestApp(
          child: AchievementCard(achievement: achievement),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AchievementCard),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('uses correct colors for unlocked state', (tester) async {
      final achievement = Achievement(
        id: 'test_achievement',
        name: 'Test',
        description: 'Test',
        points: 100,
        icon: '🎯',
        isUnlocked: true,
      );

      await tester.pumpWidget(
        createAchievementCardTestApp(
          child: AchievementCard(achievement: achievement),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AchievementCard),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, AppColors.cardBackground);

      final border = decoration?.border as Border?;
      expect(border?.top.color, AppColors.primaryOrange);
    });

    testWidgets('uses correct colors for locked state', (tester) async {
      final achievement = Achievement(
        id: 'test_achievement',
        name: 'Test',
        description: 'Test',
        points: 100,
        icon: '🎯',
        isUnlocked: false,
      );

      await tester.pumpWidget(
        createAchievementCardTestApp(
          child: AchievementCard(achievement: achievement),
        ),
      );

      // Locked card should have Opacity widget with 0.5
      final opacity = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(AchievementCard),
          matching: find.byType(Opacity),
        ).first,
      );

      expect(opacity.opacity, 0.5);
    });

    testWidgets('tap callback works correctly', (tester) async {
      final achievement = Achievement(
        id: 'test_achievement',
        name: 'Test',
        description: 'Test',
        points: 100,
        icon: '🎯',
      );

      bool tapped = false;

      await tester.pumpWidget(
        createAchievementCardTestApp(
          child: AchievementCard(
            achievement: achievement,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(AchievementCard));
      expect(tapped, true);
    });
  });

  group('AchievementCard Visual States', () {
    testWidgets('unlocked card shows full color', (tester) async {
      final achievement = Achievement(
        id: 'test_achievement',
        name: 'Test',
        description: 'Test',
        points: 100,
        icon: '🎯',
        isUnlocked: true,
      );

      await tester.pumpWidget(
        createAchievementCardTestApp(
          child: AchievementCard(achievement: achievement),
        ),
      );

      final opacity = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(AchievementCard),
          matching: find.byType(Opacity),
        ).first,
      );

      expect(opacity.opacity, 1.0);
    });

    testWidgets('locked card shows grayed icon', (tester) async {
      final achievement = Achievement(
        id: 'test_achievement',
        name: 'Test',
        description: 'Test',
        points: 100,
        icon: '🎯',
        isUnlocked: false,
      );

      await tester.pumpWidget(
        createAchievementCardTestApp(
          child: AchievementCard(achievement: achievement),
        ),
      );

      expect(find.byIcon(Icons.lock), findsOneWidget);
    });
  });
}
