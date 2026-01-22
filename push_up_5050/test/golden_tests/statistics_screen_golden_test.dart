import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/screens/statistics/statistics_screen.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await setupGoldenTests();
  });

  testGoldens('StatisticsScreen golden test', (tester) async {
    final storageService = await StorageService.create();
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    final app = await createGoldenTestApp(
      child: const StatisticsScreen(),
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(StatisticsScreen),
      matchesGoldenFile('goldens/statistics_screen.png'),
    );
  });

  testGoldens('StatisticsScreen with data golden test', (tester) async {
    final storageService = await StorageService.create();
    final statsProvider = UserStatsProvider(storage: storageService);
    final achievementsProvider = AchievementsProvider(storage: storageService);

    // Add some sample data
    await storageService.saveDailyRecord(
      DailyRecord(
        date: DateTime(2024, 1, 15),
        totalPushups: 50,
        seriesCompleted: 7,
      ),
    );
    await statsProvider.refreshStats();

    final app = await createGoldenTestApp(
      child: const StatisticsScreen(),
      statsProvider: statsProvider,
      achievementsProvider: achievementsProvider,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(StatisticsScreen),
      matchesGoldenFile('goldens/statistics_screen_data.png'),
    );
  });
}
