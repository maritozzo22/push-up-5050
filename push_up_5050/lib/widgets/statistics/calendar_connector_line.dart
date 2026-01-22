import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/models/daily_record.dart';

/// Custom painter that draws connector lines between completed calendar days.
///
/// Draws orange lines connecting adjacent completed cells following the grid path
/// (left-to-right, then next row).
class CalendarConnectorLinePainter extends CustomPainter {
  /// List of 30 daily records (null for missed days)
  final List<DailyRecord?> records;

  /// Number of columns in the grid
  final int columns;

  /// Size of each cell
  final Size cellSize;

  /// Spacing between cells
  final double spacing;

  CalendarConnectorLinePainter({
    required this.records,
    this.columns = 5,
    required this.cellSize,
    this.spacing = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (records.isEmpty) return;

    // Main orange line paint - thicker and more visible
    final linePaint = Paint()
      ..color = AppColors.primaryOrange
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Glow effect paint (semi-transparent orange)
    final glowPaint = Paint()
      ..color = AppColors.primaryOrange.withOpacity(0.3)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Find indices of completed days (has pushups)
    final List<int> completedIndices = [];
    for (int i = 0; i < records.length && i < 30; i++) {
      if (records[i] != null && records[i]!.totalPushups > 0) {
        completedIndices.add(i);
      }
    }

    if (completedIndices.isEmpty) return;

    // Draw lines between consecutive completed indices
    for (int i = 0; i < completedIndices.length - 1; i++) {
      final currentIndex = completedIndices[i];
      final nextIndex = completedIndices[i + 1];

      // Only draw line if cells are adjacent in the grid
      if (_areAdjacent(currentIndex, nextIndex)) {
        final start = _getCellCenter(currentIndex);
        final end = _getCellCenter(nextIndex);

        // Draw glow first, then main line
        canvas.drawLine(start, end, glowPaint);
        canvas.drawLine(start, end, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CalendarConnectorLinePainter oldDelegate) {
    return oldDelegate.records != records;
  }

  /// Check if two indices are adjacent in the grid
  bool _areAdjacent(int index1, int index2) {
    // Same row, adjacent columns
    if (index1 ~/ columns == index2 ~/ columns) {
      return (index1 - index2).abs() == 1;
    }
    // Adjacent rows, same column
    if ((index1 - index2).abs() == columns) {
      return index1 % columns == index2 % columns;
    }
    return false;
  }

  /// Get the center point of a cell at the given index
  Offset _getCellCenter(int index) {
    final row = index ~/ columns;
    final col = index % columns;

    final x = col * (cellSize.width + spacing) + cellSize.width / 2;
    final y = row * (cellSize.height + spacing) + cellSize.height / 2;

    return Offset(x, y);
  }
}

/// Widget that draws connector lines between completed calendar days.
class CalendarConnectorLine extends StatelessWidget {
  /// List of 30 daily records (null for missed days)
  final List<DailyRecord?> records;

  /// Number of columns in the grid
  final int columns;

  /// Size of each cell
  final Size cellSize;

  /// Spacing between cells
  final double spacing;

  const CalendarConnectorLine({
    super.key,
    required this.records,
    this.columns = 5,
    required this.cellSize,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CalendarConnectorLinePainter(
        records: records,
        columns: columns,
        cellSize: cellSize,
        spacing: spacing,
      ),
      size: Size(
        columns * (cellSize.width + spacing),
        6 * (cellSize.height + spacing), // 6 rows
      ),
    );
  }
}
