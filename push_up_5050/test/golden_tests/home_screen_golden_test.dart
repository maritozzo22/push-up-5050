import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:push_up_5050/screens/home/home_screen.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/main_navigation_wrapper.dart';
import 'golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await setupGoldenTests();
  });

  testGoldens('HomeScreen golden test', (tester) async {
    // Create a storage service with some data
    final storageService = await StorageService.create();

    // Create providers with sample data
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    final app = await createGoldenTestApp(
      child: const MainNavigationWrapper(),
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MainNavigationWrapper),
      matchesGoldenFile(
        'goldens/home_screen.png',
      ),
    );
  });

  testGoldens('HomeScreen dark theme golden test', (tester) async {
    final storageService = await StorageService.create();
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    final app = await createGoldenTestApp(
      child: const MainNavigationWrapper(),
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // Verify dark theme colors
    await expectLater(
      find.byType(MainNavigationWrapper),
      matchesGoldenFile(
        'goldens/home_screen_dark.png',
      ),
    );
  });
}
