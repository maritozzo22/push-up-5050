import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/daily_record.dart';

void main() {
  test('Debug series calculation', () {
    // Test case 1: 6 reps starting from series 1
    int totalReps = 6;
    int startingSeries = 1;

    int seriesCompleted = 0;
    int repsCount = 0;
    int seriesNum = startingSeries;

    while (repsCount < totalReps) {
      repsCount += seriesNum;
      print('After series $seriesNum: repsCount=$repsCount, seriesCompleted=$seriesCompleted');
      seriesCompleted++;
      seriesNum++;
    }

    print('Final: totalReps=$totalReps, seriesCompleted=$seriesCompleted');
    expect(seriesCompleted, equals(3));

    // Test case 2: 3 reps starting from series 1
    totalReps = 3;
    startingSeries = 1;

    seriesCompleted = 0;
    repsCount = 0;
    seriesNum = startingSeries;

    while (repsCount < totalReps) {
      repsCount += seriesNum;
      print('After series $seriesNum: repsCount=$repsCount, seriesCompleted=$seriesCompleted');
      seriesCompleted++;
      seriesNum++;
    }

    print('Final: totalReps=$totalReps, seriesCompleted=$seriesCompleted');
    expect(seriesCompleted, equals(2));
  });
}
