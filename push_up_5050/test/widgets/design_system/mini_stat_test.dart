import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/design_system/mini_stat.dart';
import 'package:push_up_5050/widgets/design_system/progress_bar.dart';

void main() {
  group('MiniStat', () {
    testWidgets('renders Column with children', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniStat(
              label: 'THIS WEEK',
              value: '125',
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('displays label text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniStat(
              label: 'THIS WEEK',
              value: '125',
            ),
          ),
        ),
      );

      expect(find.text('THIS WEEK'), findsOneWidget);
    });

    testWidgets('displays value text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniStat(
              label: 'THIS WEEK',
              value: '125',
            ),
          ),
        ),
      );

      expect(find.text('125'), findsOneWidget);
    });

    testWidgets('label has correct text style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniStat(
              label: 'THIS WEEK',
              value: '125',
            ),
          ),
        ),
      );

      final labelWidget = tester.widget<Text>(find.text('THIS WEEK'));
      expect(labelWidget.style?.fontSize, 12);
      expect(labelWidget.style?.fontWeight, FontWeight.w800);
      expect(labelWidget.style?.letterSpacing, 1.0);
      expect(labelWidget.style?.color, Colors.white.withOpacity(0.55));
    });

    testWidgets('value has correct text style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniStat(
              label: 'THIS WEEK',
              value: '125',
            ),
          ),
        ),
      );

      final valueWidget = tester.widget<Text>(find.text('125'));
      expect(valueWidget.style?.fontSize, 34);
      expect(valueWidget.style?.fontWeight, FontWeight.w900);
      expect(valueWidget.style?.color, Colors.white);
    });

    testWidgets('shows ProgressBar when showBar is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniStat(
              label: 'THIS WEEK',
              value: '125',
              showBar: true,
              barValue: 0.5,
            ),
          ),
        ),
      );

      expect(find.byType(ProgressBar), findsOneWidget);
    });

    testWidgets('does not show ProgressBar when showBar is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniStat(
              label: 'THIS WEEK',
              value: '125',
              showBar: false,
            ),
          ),
        ),
      );

      expect(find.byType(ProgressBar), findsNothing);
    });

    testWidgets('passes barValue to ProgressBar', (tester) async {
      const testBarValue = 0.75;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniStat(
              label: 'THIS WEEK',
              value: '125',
              showBar: true,
              barValue: testBarValue,
            ),
          ),
        ),
      );

      final progressBar = tester.widget<ProgressBar>(find.byType(ProgressBar));
      expect(progressBar.value, testBarValue);
    });

    testWidgets('has correct spacing with SizedBox', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniStat(
              label: 'THIS WEEK',
              value: '125',
            ),
          ),
        ),
      );

      // Should have SizedBox for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
