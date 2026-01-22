import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const Pushup5050App());

class Pushup5050App extends StatelessWidget {
  const Pushup5050App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF6C737C),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Pushup5050Widget(),
            ),
          ),
        ),
      ),
    );
  }
}

class Pushup5050Widget extends StatelessWidget {
  const Pushup5050Widget({super.key});

  static const _topA = Color(0xFF20262B);
  static const _topB = Color(0xFF111416);
  static const _bottomA = Color(0xFF0F1113);
  static const _bottomB = Color(0xFF0B0D0F);

  static const _textSoft = Color(0xFFB9C0C7);
  static const _orange = Color(0xFFF46A1E);
  static const _orange2 = Color(0xFFEF7A1A);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth.clamp(320.0, 520.0);
        final h = (w * 0.98).clamp(280.0, c.maxHeight);

        final padX = (w * 0.06).clamp(14.0, 34.0);
        final padTop = (h * 0.05).clamp(12.0, 26.0);
        final padBottom = (h * 0.05).clamp(12.0, 26.0);

        final innerW = w - padX * 2;
        final innerH = h - padTop - padBottom;

        final topH = innerH * 0.58;

        final startD =
            math.min(innerW * 0.40, innerH * 0.34).clamp(96.0, 210.0);

        final boundaryY = padTop + topH;
        final contentTopLimit = boundaryY - (startD * 0.55);

        final statsTop = padTop;
        final statsH = (contentTopLimit - statsTop).clamp(120.0, topH);

        // FIX overflow days: daysH >= chip size (+ padding)
        final dayChipSize = (w * 0.11).clamp(34.0, 62.0);
        final daysHBase = (innerH - topH - (startD * 0.5)).clamp(64.0, 120.0);
        final daysH = math.max(daysHBase, dayChipSize + 10.0);

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
                  height: padTop + topH + (startD * 0.05),
                  child: ClipPath(
                    clipper: _TopPanelClipper(),
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
                ),

                Positioned(
                  left: padX,
                  top: statsTop + (w * 0.10).clamp(18.0, 34.0), // spazio sotto titolo
                  width: innerW * 0.46,
                  height: statsH - (w * 0.10).clamp(18.0, 34.0),
                  child: _StatBlockNoOverflow(
                    heading: "OGGI:",
                    value: "41",
                    unit: "push-ups",
                    alignLeft: true,
                    scale: w,
                  ),
                ),

                Positioned(
                  right: padX,
                  top: statsTop + (w * 0.10).clamp(18.0, 34.0),
                  width: innerW * 0.46,
                  height: statsH - (w * 0.10).clamp(18.0, 34.0),
                  child: _StatBlockNoOverflow(
                    heading: "OBIETTIVO:",
                    value: "44 / 5050",
                    unit: "push-ups",
                    alignLeft: false,
                    scale: w,
                  ),
                ),

                Positioned(
                  left: (w - startD) / 2,
                  top: boundaryY - (startD / 2),
                  width: startD,
                  height: startD,
                  child: StartButton(
                    diameter: startD,
                    onPressed: () {},
                  ),
                ),

                Positioned(
                  left: padX,
                  right: padX,
                  bottom: padBottom,
                  height: daysH,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomCenter,
                      child: _DaysRow(
                        width: innerW,
                        chipSize: dayChipSize,
                        selectedIndexes: const {0, 1},
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

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0xAA000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: child,
      ),
    );
  }
}

/// FIX overflow stats: niente SizedBox fissi; spazi gestiti con Spacer + FittedBox.
class _StatBlockNoOverflow extends StatelessWidget {
  const _StatBlockNoOverflow({
    required this.heading,
    required this.value,
    required this.unit,
    required this.alignLeft,
    required this.scale,
  });

  final String heading;
  final String value;
  final String unit;
  final bool alignLeft;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final align = alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final textAlign = alignLeft ? TextAlign.left : TextAlign.right;

    final headingSize = scale * 0.060;
    final valueSize = scale * 0.135;
    final unitSize = scale * 0.055;

    return LayoutBuilder(
      builder: (context, c) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: align,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
              child: Text(
                heading,
                textAlign: textAlign,
                style: TextStyle(
                  color: Pushup5050Widget._orange,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  fontSize: headingSize,
                ),
              ),
            ),
            const Spacer(flex: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
              child: Text(
                value,
                maxLines: 1,
                textAlign: textAlign,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  fontSize: valueSize,
                  height: 0.95,
                ),
              ),
            ),
            const Spacer(flex: 1),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
              child: Text(
                unit,
                textAlign: textAlign,
                style: TextStyle(
                  color: Pushup5050Widget._textSoft,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                  fontSize: unitSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class StartButton extends StatefulWidget {
  const StartButton({
    super.key,
    required this.diameter,
    required this.onPressed,
  });

  final double diameter;
  final VoidCallback onPressed;

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
  );

  late final Animation<double> _scale =
      Tween<double>(begin: 1.0, end: 0.94).animate(
    CurvedAnimation(parent: _c, curve: Curves.easeOut),
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _tap() async {
    widget.onPressed();
    await _c.forward();
    await _c.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.diameter;

    return GestureDetector(
      onTap: _tap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: SizedBox(
          width: d,
          height: d,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: d,
                height: d,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xAA000000),
                      blurRadius: 24,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
              ),
              Container(
                width: d,
                height: d,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2A2F35),
                ),
              ),
              Container(
                width: d * 0.88,
                height: d * 0.88,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Pushup5050Widget._orange2, Pushup5050Widget._orange],
                  ),
                ),
              ),
              ClipOval(
                child: SizedBox(
                  width: d * 0.88,
                  height: d * 0.88,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: double.infinity,
                      height: d * 0.40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.22),
                            Colors.transparent
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "START",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  fontSize: d * 0.20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DaysRow extends StatelessWidget {
  const _DaysRow({
    required this.width,
    required this.chipSize,
    required this.selectedIndexes,
  });

  final double width;
  final double chipSize;
  final Set<int> selectedIndexes;

  @override
  Widget build(BuildContext context) {
    const days = ["L", "M", "M", "G", "V", "S", "D"];

    return SizedBox(
      width: width,
      height: chipSize, // FIX overflow bottom: altezza vincolata
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(days.length, (i) {
          final selected = selectedIndexes.contains(i);
          return _DayChip(label: days[i], selected: selected, size: chipSize);
        }),
      ),
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
    final bg = selected ? Pushup5050Widget._orange : const Color(0xFF3A4046);
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
            fontSize: size * 0.42,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}

class _TopPanelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final w = s.width;
    final h = s.height;
    final curveDepth = (h * 0.12).clamp(18.0, 34.0);

    return Path()
      ..lineTo(0, h - curveDepth)
      ..quadraticBezierTo(w * 0.5, h + curveDepth, w, h - curveDepth)
      ..lineTo(w, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
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
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), paint1);
    }

    final paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFFFFFFFF).withOpacity(0.03);

    for (double x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), paint2);
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
