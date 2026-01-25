import 'package:flutter/material.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';

/// Weekly Chart Card - displays weekly progress as area chart.
///
/// Shows:
/// - Title "PROGRESSI SETTIMANALI"
/// - Area chart with 7 days (Mon-Sun)
/// - Orange gradient fill under the line
/// - Weekly progress summary (total / target)
class WeeklyChartCard extends StatelessWidget {
  final List<double>? weeklySeries;
  final int weekTotal;
  final int weeklyTarget;

  const WeeklyChartCard({
    super.key,
    this.weeklySeries,
    this.weekTotal = 0,
    this.weeklyTarget = 250,
  });

  @override
  Widget build(BuildContext context) {
    // Use provided data or placeholder
    final data = weeklySeries ?? _placeholderData;

    return FrostCard(
      height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROGRESSI SETTIMANALI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: Colors.white.withOpacity(0.70),
                ),
              ),
              Text(
                '$weekTotal / $weeklyTarget',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: weekTotal >= weeklyTarget
                      ? const Color(0xFF4CAF50) // Green when complete
                      : Colors.white.withOpacity(0.70),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: WeeklyChartPainter(data: data),
          ),
        ],
      ),
    );
  }

  /// Placeholder data for visual demonstration.
  static const List<double> _placeholderData = [0.3, 0.5, 0.4, 0.7, 0.6, 0.8, 0.65];
}

/// CustomPainter for weekly area chart.
///
/// Draws:
/// - Smooth curve connecting 7 data points
/// - Gradient fill under the curve
/// - Optional data points (circles)
class WeeklyChartPainter extends StatelessWidget {
  final List<double> data;
  final Color lineColor;
  final Color fillColorStart;
  final Color fillColorEnd;

  WeeklyChartPainter({
    super.key,
    required this.data,
    this.lineColor = const Color(0xFFFFB347),
    this.fillColorStart = const Color(0x4DFF7A18), // 0.3 opacity
    this.fillColorEnd = const Color(0x00FF7A18), // 0.0 opacity
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WeeklyChartPainter(
        data: data,
        lineColor: lineColor,
        fillColorStart: fillColorStart,
        fillColorEnd: fillColorEnd,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _WeeklyChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color fillColorStart;
  final Color fillColorEnd;

  _WeeklyChartPainter({
    required this.data,
    required this.lineColor,
    required this.fillColorStart,
    required this.fillColorEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || data.length < 2) return;

    const padding = 8.0;
    final chartWidth = size.width - (padding * 2);
    final chartHeight = size.height - (padding * 2);
    final stepX = chartWidth / (data.length - 1);

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = padding + (i * stepX);
      final y = padding + (chartHeight * (1 - data[i].clamp(0.0, 1.0)));
      points.add(Offset(x, y));
    }

    // Create gradient for fill
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [fillColorStart, fillColorEnd],
    );

    // Draw fill (area under curve)
    final fillPath = Path();
    fillPath.moveTo(points.first.dx, size.height - padding);
    fillPath.lineTo(points.first.dx, points.first.dy);

    // Draw smooth curve through points
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      fillPath.cubicTo(
        midX, p0.dy,
        midX, p1.dy,
        p1.dx, p1.dy,
      );
    }

    fillPath.lineTo(points.last.dx, size.height - padding);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(
        midX, p0.dy,
        midX, p1.dy,
        p1.dx, p1.dy,
      );
    }

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(point, 4, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WeeklyChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.lineColor != lineColor;
  }
}
