import 'package:flutter/material.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';

/// Monthly Calendar Widget - displays monthly progress calendar.
///
/// Shows:
/// - Header with month/year
/// - Weekday labels (L M M G V S D)
/// - 7-column grid with day cells
/// - Completed days: orange gradient fill
/// - Connector lines between consecutive completed days
/// - Today: orange border ring
/// - Missed days: dark background with X
/// - Blocked days: gray background (days before first workout)
/// - Future days: dimmed
class MonthlyCalendar extends StatelessWidget {
  final DateTime? month;
  final Set<int>? completedDays;
  final Set<int>? missedDays;
  final Set<int>? blockedDays;

  const MonthlyCalendar({
    super.key,
    this.month,
    this.completedDays,
    this.missedDays,
    this.blockedDays,
  });

  @override
  Widget build(BuildContext context) {
    final displayMonth = month ?? DateTime.now();
    final today = DateTime.now();

    return FrostCard(
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month/Year header
          Text(
            _formatMonthYear(displayMonth),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),

          // Weekday labels
          _buildWeekdayLabels(),
          const SizedBox(height: 8),

          // Calendar grid
          Expanded(
            child: _buildCalendarGrid(displayMonth, today),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    const weekdays = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return SizedBox(
          width: 32,
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.50),
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(DateTime month, DateTime today) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final startingWeekday = _getStartingWeekday(firstDayOfMonth);

    // Build grid data structure
    final gridData = _buildGridData(month, today, firstDayOfMonth, lastDayOfMonth, startingWeekday);

    return Stack(
      children: [
        // Connector lines layer (behind cells)
        _MonthlyConnectorLines(
          gridData: gridData,
          completedDays: completedDays ?? {},
        ),
        // Day cells layer
        _buildDayCells(gridData, today, month),
      ],
    );
  }

  List<List<_DayCellData?>> _buildGridData(
    DateTime month,
    DateTime today,
    DateTime firstDayOfMonth,
    DateTime lastDayOfMonth,
    int startingWeekday,
  ) {
    final gridData = <List<_DayCellData?>>[];
    int dayCounter = 1;

    for (int row = 0; row < 6; row++) {
      final rowData = <_DayCellData?>[];
      for (int col = 0; col < 7; col++) {
        if (row == 0 && col < startingWeekday) {
          rowData.add(null);
        } else if (dayCounter > lastDayOfMonth.day) {
          rowData.add(null);
        } else {
          final isToday = dayCounter == today.day &&
              month.year == today.year &&
              month.month == today.month;

          final isCompleted = completedDays?.contains(dayCounter) ?? false;
          final isMissed = missedDays?.contains(dayCounter) ?? false;
          final isBlocked = blockedDays?.contains(dayCounter) ?? false;
          final isFuture = dayCounter > today.day &&
              month.year == today.year &&
              month.month == today.month;

          rowData.add(_DayCellData(
            day: dayCounter,
            row: row,
            col: col,
            isCompleted: isCompleted,
            isMissed: isMissed,
            isToday: isToday,
            isFuture: isFuture,
            isBlocked: isBlocked,
          ));
          dayCounter++;
        }
      }
      gridData.add(rowData);
      if (dayCounter > lastDayOfMonth.day) break;
    }

    return gridData;
  }

  Widget _buildDayCells(List<List<_DayCellData?>> gridData, DateTime today, DateTime month) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: gridData.asMap().entries.map((rowEntry) {
        final row = rowEntry.key;
        final rowData = rowEntry.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: rowData.asMap().entries.map((colEntry) {
            final col = colEntry.key;
            final cellData = colEntry.value;

            if (cellData == null) {
              return const SizedBox(width: 32, height: 32);
            }

            // Determine connections for this cell
            final isConnectedLeft = _isConnectedTo(cellData, gridData, -1, 0);
            final isConnectedRight = _isConnectedTo(cellData, gridData, 1, 0);
            final isConnectedUp = _isConnectedTo(cellData, gridData, 0, -1);
            final isConnectedDown = _isConnectedTo(cellData, gridData, 0, 1);

            return _CalendarDayCell(
              day: cellData.day,
              isCompleted: cellData.isCompleted,
              isMissed: cellData.isMissed,
              isToday: cellData.isToday,
              isFuture: cellData.isFuture,
              isBlocked: cellData.isBlocked,
              isConnectedLeft: isConnectedLeft,
              isConnectedRight: isConnectedRight,
              isConnectedUp: isConnectedUp,
              isConnectedDown: isConnectedDown,
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  /// Check if current cell is connected to adjacent cell
  bool _isConnectedTo(_DayCellData current, List<List<_DayCellData?>> grid, int colOffset, int rowOffset) {
    if (!current.isCompleted) return false;

    final targetRow = current.row + rowOffset;
    final targetCol = current.col + colOffset;

    if (targetRow < 0 || targetRow >= grid.length) return false;
    if (targetCol < 0 || targetCol >= 7) return false;

    final targetCell = grid[targetRow][targetCol];
    return targetCell != null && targetCell.isCompleted;
  }

  int _getStartingWeekday(DateTime firstDay) {
    return (firstDay.weekday - 1) % 7;
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'GENNAIO', 'FEBBRAIO', 'MARZO', 'APRILE', 'MAGGIO', 'GIUGNO',
      'LUGLIO', 'AGOSTO', 'SETTEMBRE', 'OTTOBRE', 'NOVEMBRE', 'DICEMBRE'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

/// Data class for calendar day cell
class _DayCellData {
  final int day;
  final int row;
  final int col;
  final bool isCompleted;
  final bool isMissed;
  final bool isToday;
  final bool isFuture;
  final bool isBlocked;

  _DayCellData({
    required this.day,
    required this.row,
    required this.col,
    required this.isCompleted,
    required this.isMissed,
    required this.isToday,
    required this.isFuture,
    required this.isBlocked,
  });
}

/// Widget that draws connector lines between consecutive completed days
class _MonthlyConnectorLines extends StatelessWidget {
  final List<List<_DayCellData?>> gridData;
  final Set<int> completedDays;

  const _MonthlyConnectorLines({
    required this.gridData,
    required this.completedDays,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MonthlyConnectorPainter(
        gridData: gridData,
        completedDays: completedDays,
      ),
      size: const Size.fromHeight(280),
    );
  }
}

/// Custom painter for drawing connector lines between completed days
class _MonthlyConnectorPainter extends CustomPainter {
  final List<List<_DayCellData?>> gridData;
  final Set<int> completedDays;

  _MonthlyConnectorPainter({
    required this.gridData,
    required this.completedDays,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFFF7A18)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = const Color(0xFFFF7A18).withOpacity(0.3)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Cell size and spacing
    const cellSize = 32.0;
    const spacing = 6.0;
    const rowSpacing = 4.0;

    // Calculate offset to center the grid
    final totalWidth = 7 * cellSize + 6 * spacing;
    final startX = (size.width - totalWidth) / 2 + cellSize / 2;
    final startY = 30.0; // Approximate top offset after header

    // Draw lines between adjacent completed cells
    for (int row = 0; row < gridData.length; row++) {
      for (int col = 0; col < 7; col++) {
        final cell = gridData[row][col];
        if (cell == null || !cell.isCompleted) continue;

        final center = Offset(
          startX + col * (cellSize + spacing),
          startY + row * (cellSize + rowSpacing),
        );

        // Check right neighbor
        if (col + 1 < 7) {
          final rightCell = gridData[row][col + 1];
          if (rightCell != null && rightCell.isCompleted) {
            final rightCenter = Offset(
              startX + (col + 1) * (cellSize + spacing),
              startY + row * (cellSize + rowSpacing),
            );
            canvas.drawLine(center, rightCenter, glowPaint);
            canvas.drawLine(center, rightCenter, linePaint);
          }
        }

        // Check bottom neighbor
        if (row + 1 < gridData.length) {
          final bottomCell = gridData[row + 1][col];
          if (bottomCell != null && bottomCell.isCompleted) {
            final bottomCenter = Offset(
              startX + col * (cellSize + spacing),
              startY + (row + 1) * (cellSize + rowSpacing),
            );
            canvas.drawLine(center, bottomCenter, glowPaint);
            canvas.drawLine(center, bottomCenter, linePaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MonthlyConnectorPainter oldDelegate) {
    return oldDelegate.completedDays != completedDays;
  }
}

/// Individual calendar day cell.
class _CalendarDayCell extends StatelessWidget {
  final int day;
  final bool isCompleted;
  final bool isMissed;
  final bool isToday;
  final bool isFuture;
  final bool isBlocked;
  final bool isConnectedLeft;
  final bool isConnectedRight;
  final bool isConnectedUp;
  final bool isConnectedDown;

  const _CalendarDayCell({
    required this.day,
    required this.isCompleted,
    required this.isMissed,
    required this.isToday,
    required this.isFuture,
    this.isBlocked = false,
    this.isConnectedLeft = false,
    this.isConnectedRight = false,
    this.isConnectedUp = false,
    this.isConnectedDown = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background container
          if (isCompleted)
            _CompletedDayBackground(
              isConnectedLeft: isConnectedLeft,
              isConnectedRight: isConnectedRight,
              isConnectedUp: isConnectedUp,
              isConnectedDown: isConnectedDown,
            )
          else if (isMissed)
            _MissedDayBackground()
          else if (isBlocked)
            _BlockedDayBackground()
          else if (!isFuture)
            _NormalDayBackground(),

          // Today ring
          if (isToday)
            _TodayRing(),

          // Day number
          Text(
            day.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isCompleted
                  ? Colors.black87
                  : isBlocked
                      ? Colors.white.withOpacity(0.30)
                      : isFuture
                          ? Colors.white.withOpacity(0.25)
                          : Colors.white.withOpacity(0.70),
            ),
          ),

          // Missed indicator X
          if (isMissed)
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFF44336),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.close,
                    size: 5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Locked icon for blocked days
          if (isBlocked)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock,
                    size: 6,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CompletedDayBackground extends StatelessWidget {
  final bool isConnectedLeft;
  final bool isConnectedRight;
  final bool isConnectedUp;
  final bool isConnectedDown;

  const _CompletedDayBackground({
    this.isConnectedLeft = false,
    this.isConnectedRight = false,
    this.isConnectedUp = false,
    this.isConnectedDown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A18).withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _MissedDayBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
        border: Border.all(
          color: const Color(0xFFF44336).withOpacity(0.3),
          width: 1,
        ),
      ),
    );
  }
}

class _NormalDayBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.05),
      ),
    );
  }
}

class _TodayRing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFF7A18),
          width: 2,
        ),
      ),
    );
  }
}

class _BlockedDayBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2A2A2A),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
    );
  }
}
