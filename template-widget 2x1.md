Template widget 2x1:
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF6C737C),
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: 220,
              height: 420,
              child: Pushup5050SmallWidget(),
            ),
          ),
        ),
      ),
    );
  }
}

class Pushup5050SmallWidget extends StatelessWidget {
  const Pushup5050SmallWidget({super.key});

  static const _topA = Color(0xFF20262B);
  static const _topB = Color(0xFF111416);
  static const _bottomA = Color(0xFF0F1113);
  static const _bottomB = Color(0xFF0B0D0F);

  static const _orange = Color(0xFFF46A1E);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth.clamp(160.0, 280.0);
        final h = c.maxHeight.clamp(260.0, 560.0);

        final padX = (w * 0.08).clamp(12.0, 18.0);
        final padTop = (h * 0.075).clamp(14.0, 22.0);
        final padBottom = (h * 0.075).clamp(14.0, 22.0);

        final innerH = h - padTop - padBottom;

        final chipSize = (w * 0.22).clamp(28.0, 44.0);
        final daysH = math.max((h * 0.23).clamp(72.0, 96.0), chipSize + 24.0);

        final gapToDays = (h * 0.018).clamp(5.0, 8.0);
        final statsH = math.max(0.0, innerH - daysH - gapToDays);

        return SizedBox(
          width: w,
          height: h,
          child: _CardShell(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_bottomA, _bottomB],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: h * 0.62,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_topA, _topB],
                      ),
                    ),
                    child: Opacity(
                      opacity: 0.10,
                      child: CustomPaint(painter: _NoiseGridPainter()),
                    ),
                  ),
                ),

                // TUTTO CENTRATO ORIZZONTALMENTE
                Positioned(
                  left: padX,
                  right: padX,
                  top: padTop,
                  height: statsH,
                  child: LayoutBuilder(
                    builder: (context, s) {
                      final sw = s.maxWidth;
                      final sh = s.maxHeight;

                      final betweenHeadingAndValue = (sh * 0.02).clamp(2.0, 6.0);
                      final betweenBlocks = (sh * 0.10).clamp(10.0, 22.0);

                      final headingSize = (sw * 0.10).clamp(12.0, 17.0);

                      // OGGI: leggermente più grande (ma non troppo)
                      final todayByW = (sw * 0.27).clamp(24.0, 44.0);
                      final todayByH = (sh * 0.36).clamp(24.0, 44.0);
                      final todaySize = math.min(todayByW, todayByH);

                      // TOTALE: 3 righe (44 / 5050) centrato
                      final totalByW = (sw * 0.24).clamp(22.0, 40.0);
                      final totalByH = (sh * 0.30).clamp(22.0, 40.0);
                      final totalSize = math.min(totalByW, totalByH);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _StatTightCentered(
                            heading: "OGGI PUSHUPS",
                            headingSize: headingSize,
                            gap: betweenHeadingAndValue,
                            child: Text(
                              "44",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: todaySize,
                                height: 0.95,
                              ),
                            ),
                          ),
                          SizedBox(height: betweenBlocks),
                          _StatTightCentered(
                            heading: "TOTALE PUSHUPS",
                            headingSize: headingSize,
                            gap: betweenHeadingAndValue,
                            child: _TotalThreeLines(
                              top: "44",
                              mid: "/",
                              bottom: "5050",
                              fontSize: totalSize,
                            ),
                          ),
                          const Spacer(),
                        ],
                      );
                    },
                  ),
                ),

                Positioned(
                  left: padX,
                  right: padX,
                  bottom: padBottom,
                  height: daysH,
                  child: Center(
                    child: SizedBox(
                      height: chipSize,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _DayChip(label: "L", selected: false, size: chipSize),
                            SizedBox(width: (w * 0.06).clamp(8.0, 14.0)),
                            _DayChip(label: "M", selected: true, size: chipSize),
                            SizedBox(width: (w * 0.06).clamp(8.0, 14.0)),
                            _DayChip(label: "M", selected: false, size: chipSize),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatTightCentered extends StatelessWidget {
  const _StatTightCentered({
    required this.heading,
    required this.headingSize,
    required this.gap,
    required this.child,
  });

  final String heading;
  final double headingSize;
  final double gap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            heading,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Pushup5050SmallWidget._orange,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
              fontSize: headingSize,
            ),
          ),
        ),
        SizedBox(height: gap),
        Center(child: FittedBox(fit: BoxFit.scaleDown, child: child)),
      ],
    );
  }
}

class _TotalThreeLines extends StatelessWidget {
  const _TotalThreeLines({
    required this.top,
    required this.mid,
    required this.bottom,
    required this.fontSize,
  });

  final String top;
  final String mid;
  final String bottom;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          top,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
            height: 0.95,
          ),
        ),
        Text(
          mid,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: fontSize * 0.80,
            height: 0.95,
          ),
        ),
        Text(
          bottom,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
            height: 0.95,
          ),
        ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.selected,
    required this.size,
  });

  final String label;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bg =
        selected ? Pushup5050SmallWidget._orange : const Color(0xFF3A4046);
    final fg = selected ? const Color(0xFF14171A) : const Color(0xFFD7DEE6);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(selected ? 0.35 : 0.25),
            blurRadius: selected ? 10 : 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w900,
            fontSize: size * 0.45,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0xAA000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: child,
      ),
    );
  }
}

class _NoiseGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFFFFFFFF).withOpacity(0.06);

    const step = 16.0;
    for (double x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint1,
      );
    }

    final paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFFFFFFFF).withOpacity(0.03);

    for (double x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint2,
      );
    }

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFFFFFF).withOpacity(0.02);

    const dotStep = 22.0;
    for (double y = 8; y < size.height; y += dotStep) {
      for (double x = 8; x < size.width; x += dotStep) {
        canvas.drawCircle(Offset(x, y), 0.9, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
