import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';

/// Recovery timer bar widget for workout screen.
///
/// Displays progress of recovery time between series with color-coded states.
///
/// Design specs from UI_MOCKUPS.md:
/// - Height: 12px
/// - Colors (based on remaining %):
///   - 100-66%: #4CAF50 (green)
///   - 66-33%: #FF9800 (orange)
///   - 33-5%: #F44336 (red)
///   - 5-0%: #F44336 (red, flashing)
/// - Labels: "Serie X di Y" (left), "XX%" (right)
/// - Border radius: 6px
class RecoveryTimerBar extends StatefulWidget {
  /// Current series number
  final int currentSeries;

  /// Total number of series
  final int totalSeries;

  /// Remaining seconds in recovery
  final int remainingSeconds;

  /// Total rest time in seconds
  final int totalRestTime;

  const RecoveryTimerBar({
    super.key,
    required this.currentSeries,
    required this.totalSeries,
    required this.remainingSeconds,
    required this.totalRestTime,
  });

  @override
  State<RecoveryTimerBar> createState() => _RecoveryTimerBarState();
}

class _RecoveryTimerBarState extends State<RecoveryTimerBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<double> _flashAnimation;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _flashAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _flashController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _flashController.forward();
        }
      });

    // Start flashing if in critical state
    if (_isCriticalState) {
      _flashController.forward();
    }
  }

  @override
  void didUpdateWidget(RecoveryTimerBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wasCritical = oldWidget.remainingSeconds <=
        (oldWidget.totalRestTime * 0.05).ceil();
    final isCritical = _isCriticalState;

    if (isCritical && !wasCritical) {
      _flashController.forward();
    } else if (!isCritical && wasCritical) {
      _flashController.stop();
      _flashController.reset();
    }
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  bool get _isCriticalState =>
      widget.remainingSeconds <= (widget.totalRestTime * 0.05).ceil();

  double get _progress {
    if (widget.totalRestTime == 0) return 0;
    return widget.remainingSeconds / widget.totalRestTime;
  }

  Color _getProgressColor() {
    final percentage = _progress;
    if (percentage > 0.66) {
      return const Color(0xFF4CAF50); // Green
    } else if (percentage > 0.33) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Red
    }
  }

  int get _percentageDisplay => (_progress * 100).round();

  @override
  Widget build(BuildContext context) {
    final progressColor = _getProgressColor();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Series label (left)
          Text(
            _l10n.workoutSeriesOfTotal(widget.currentSeries, widget.totalSeries),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          // Progress bar
          Expanded(
            child: SizedBox(
              height: 12,
              child: Stack(
                children: [
                  // Background
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // Progress fill
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: _isCriticalState
                        ? AnimatedBuilder(
                            animation: _flashAnimation,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _progress,
                                color: progressColor
                                    .withOpacity(_flashAnimation.value),
                                backgroundColor: Colors.transparent,
                                minHeight: 12,
                              );
                            },
                          )
                        : LinearProgressIndicator(
                            value: _progress,
                            color: progressColor,
                            backgroundColor: Colors.transparent,
                            minHeight: 12,
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Percentage label (right)
          Text(
            '$_percentageDisplay%',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
