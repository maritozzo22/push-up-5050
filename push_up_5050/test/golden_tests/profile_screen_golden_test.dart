import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:push_up_5050/screens/profile/profile_screen.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await setupGoldenTests();
  });

  testGoldens('ProfileScreen golden test', (tester) async {
    final storageService = await StorageService.create();
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    final app = await createGoldenTestApp(
      child: const ProfileScreen(),
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ProfileScreen),
      matchesGoldenFile('goldens/profile_screen.png'),
    );
  });

  testGoldens('ProfileScreen with achievements golden test', (tester) async {
    final storageService = await StorageService.create();
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    final app = await createGoldenTestApp(
      child: const ProfileScreen(),
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // Scroll to see achievements section - use first Scrollable descendant
    final scrollable = find.descendant(
      of: find.byType(ProfileScreen),
      matching: find.byType(Scrollable),
    ).first;
    await tester.drag(scrollable, const Offset(0, -300));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ProfileScreen),
      matchesGoldenFile('goldens/profile_screen_achievements.png'),
    );
  });
}
