import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:push_up_5050/screens/settings/settings_screen.dart';
import 'package:push_up_5050/main_navigation_wrapper.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await setupGoldenTests();
  });

  testGoldens('SettingsScreen golden test', (tester) async {
    final storageService = await StorageService.create();
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    final app = await createGoldenTestApp(
      child: const SettingsScreen(),
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SettingsScreen),
      matchesGoldenFile('goldens/settings_screen.png'),
    );
  });

  testGoldens('SettingsScreen with toggles golden test', (tester) async {
    final storageService = await StorageService.create();
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    final app = await createGoldenTestApp(
      child: const SettingsScreen(),
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // Scroll to see all settings
    await tester.drag(find.byType(Scrollable), const Offset(0, -200));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SettingsScreen),
      matchesGoldenFile('goldens/settings_screen_scrolled.png'),
    );
  });
}
