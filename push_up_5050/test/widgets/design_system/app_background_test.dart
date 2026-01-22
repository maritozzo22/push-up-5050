import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/design_system/app_background.dart';

void main() {
  group('AppBackground', () {
    testWidgets('renders Positioned.fill with Stack', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 800,
              child: Stack(
                children: [
                  AppBackground(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Positioned), findsWidgets);
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('contains two DecoratedBox widgets', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 800,
              child: Stack(
                children: [
                  AppBackground(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(DecoratedBox), findsWidgets);
    });

    testWidgets('has correct main radial gradient colors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 800,
              child: Stack(
                children: [
                  AppBackground(),
                ],
              ),
            ),
          ),
        ),
      );

      final decoratedBoxes = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
      final mainBox = decoratedBoxes.first;

      final gradient = (mainBox.decoration as BoxDecoration).gradient as RadialGradient;
      expect(gradient.colors.first, const Color(0xFF1C222C));
      expect(gradient.colors.last, const Color(0xFF0B0C0F));
    });

    testWidgets('has correct orange radial gradient', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 800,
              child: Stack(
                children: [
                  AppBackground(),
                ],
              ),
            ),
          ),
        ),
      );

      final decoratedBoxes = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
      expect(decoratedBoxes.length, greaterThanOrEqualTo(2));

      final orangeBox = decoratedBoxes.skip(1).first;
      final gradient = (orangeBox.decoration as BoxDecoration).gradient as RadialGradient;
      expect(gradient.colors.first, const Color(0x14FF7A18));
      expect(gradient.colors.last, Colors.transparent);
    });
  });
}
