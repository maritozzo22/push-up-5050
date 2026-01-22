import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/statistics/calendar_day_cell.dart';

void main() {
  group('CalendarDayCell Widget', () {
    group('Missed Day Cell', () {
      testWidgets('displays day number in red for missed day', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CalendarDayCell(
                day: 5,
                record: null, // No record = missed
                isToday: false,
                isFuture: false,
              ),
            ),
          ),
        );

        // Should find the day number text
        expect(find.text('5'), findsOneWidget);

        // Verify the text is red (Colors.red or red.shade400)
        final textWidget = tester.widget<Text>(find.text('5'));
        expect(
          textWidget.style?.color == Colors.red ||
              textWidget.style?.color == Colors.red.shade400,
          isTrue,
        );
      });

      testWidgets('displays red X icon in top right for missed day', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CalendarDayCell(
                day: 5,
                record: null,
                isToday: false,
                isFuture: false,
              ),
            ),
          ),
        );

        // Should find a close icon
        expect(find.byIcon(Icons.close), findsOneWidget);

        // Verify the icon is red
        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.close));
        expect(
          iconWidget.color == Colors.red ||
              iconWidget.color == Colors.red.shade400,
          isTrue,
        );
      });

      testWidgets('does NOT show X for future days', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CalendarDayCell(
                day: 5,
                record: null,
                isToday: false,
                isFuture: true, // Future day
              ),
            ),
          ),
        );

        // Should NOT find close icon for future days
        expect(find.byIcon(Icons.close), findsNothing);
      });

      testWidgets('missed cell uses Stack layout', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CalendarDayCell(
                day: 5,
                record: null,
                isToday: false,
                isFuture: false,
              ),
            ),
          ),
        );

        // Should have Stack for positioning X in corner
        expect(find.byType(Stack), findsWidgets);
      });
    });
  });
}
