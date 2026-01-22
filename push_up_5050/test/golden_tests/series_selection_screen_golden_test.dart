import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:push_up_5050/screens/series_selection/series_selection_screen.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await setupGoldenTests();
  });

  testGoldens('SeriesSelectionScreen golden test', (tester) async {
    final storageService = await StorageService.create();
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    final app = await createGoldenTestApp(
      child: const SeriesSelectionScreen(),
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SeriesSelectionScreen),
      matchesGoldenFile('goldens/series_selection.png'),
    );
  });

  testGoldens('SeriesSelectionScreen scrolled golden test', (tester) async {
    final storageService = await StorageService.create();
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    final app = await createGoldenTestApp(
      child: const SeriesSelectionScreen(),
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // Scroll to see more options
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -200));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SeriesSelectionScreen),
      matchesGoldenFile('goldens/series_selection_scrolled.png'),
    );
  });
}
