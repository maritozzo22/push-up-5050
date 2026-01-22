import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/core/router.dart';

void main() {
  group('AppRoutes', () {
    test('home route should be root path', () {
      expect(AppRoutes.home, '/');
    });

    test('seriesSelection route should be correct', () {
      expect(AppRoutes.seriesSelection, '/series_selection');
    });

    test('workoutExecution route should be correct', () {
      expect(AppRoutes.workoutExecution, '/workout_execution');
    });

    test('statistics route should be correct', () {
      expect(AppRoutes.statistics, '/statistics');
    });

    test('profile route should be correct', () {
      expect(AppRoutes.profile, '/profile');
    });

    test('all route constants should be unique strings', () {
      final routes = [
        AppRoutes.home,
        AppRoutes.seriesSelection,
        AppRoutes.workoutExecution,
        AppRoutes.statistics,
        AppRoutes.profile,
      ];

      expect(routes.toSet().length, equals(routes.length),
        reason: 'All route constants should be unique');
    });

    test('all routes should start with forward slash', () {
      expect(AppRoutes.home, startsWith('/'));
      expect(AppRoutes.seriesSelection, startsWith('/'));
      expect(AppRoutes.workoutExecution, startsWith('/'));
      expect(AppRoutes.statistics, startsWith('/'));
      expect(AppRoutes.profile, startsWith('/'));
    });
  });
}
