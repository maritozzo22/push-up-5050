import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/screens/workout_execution/workout_execution_screen.dart';
import 'package:push_up_5050/services/haptic_feedback_service.dart';
import 'package:push_up_5050/widgets/design_system/app_background.dart';

/// Series selection screen - configure workout parameters.
///
/// New design with dark glass + orange glow effect.
///
/// Displays:
/// - Top bar with back button
/// - Config card for starting series (1-99)
/// - Config card for rest time (5-60 seconds)
/// - Config card for goal push-ups (0-500)
/// - "BEGIN WORKOUT" button
class SeriesSelectionScreen extends StatefulWidget {
  static const String routeName = '/series_selection';

  const SeriesSelectionScreen({super.key});

  @override
  State<SeriesSelectionScreen> createState() => _SeriesSelectionScreenState();
}

class _SeriesSelectionScreenState extends State<SeriesSelectionScreen> {
  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  static const int _minStartingSeries = 1;
  static const int _maxStartingSeries = 99;
  static const int _minRestTime = 5;
  static const int _maxRestTime = 120;
  static const int _maxGoalPushups = 500;

  int _startingSeries = 1;
  int _restTime = 10;
  int _goalPushups = 0;

  // Long-press acceleration state for goal
  Timer? _goalIncrementTimer;
  Timer? _goalDecrementTimer;
  int _goalAccelerationLevel = 1;
  DateTime? _goalPressStartTime;

  // Long-press acceleration state for rest time
  Timer? _restTimeIncrementTimer;
  Timer? _restTimeDecrementTimer;
  int _restTimeAccelerationLevel = 1;
  DateTime? _restTimePressStartTime;

  int get startingSeries => _startingSeries;

  @override
  void dispose() {
    _goalIncrementTimer?.cancel();
    _goalDecrementTimer?.cancel();
    _restTimeIncrementTimer?.cancel();
    _restTimeDecrementTimer?.cancel();
    super.dispose();
  }

  /// Calculate the next starting series value.
  int _getNextStartingSeries(int current) {
    if (current < 10) return current + 1;
    if (current < 95) return current + 5;
    return 99;
  }

  /// Calculate the previous starting series value.
  int _getPreviousStartingSeries(int current) {
    if (current <= 11) return current - 1;
    if (current <= 15) return 10;
    if (current % 5 == 0) return current - 5;
    return current - 5;
  }

  /// Handle goal increment with long-press acceleration.
  void _handleGoalIncrement(TapDownDetails details) {
    setState(() => _goalPushups = (_goalPushups + 1).clamp(0, _maxGoalPushups));
    _goalPressStartTime = DateTime.now();
    _goalAccelerationLevel = 1;
    _goalIncrementTimer?.cancel();
    _goalIncrementTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final elapsed = DateTime.now().difference(_goalPressStartTime!).inSeconds;
      int newLevel = 1;
      if (elapsed >= 5) {
        newLevel = 4;
      } else if (elapsed >= 3) {
        newLevel = 3;
      } else if (elapsed >= 1) {
        newLevel = 2;
      }
      if (newLevel != _goalAccelerationLevel) {
        setState(() => _goalAccelerationLevel = newLevel);
      }
      setState(() {
        _goalPushups = (_goalPushups + _goalAccelerationLevel).clamp(0, _maxGoalPushups);
      });
    });
  }

  /// Handle goal decrement with long-press acceleration.
  void _handleGoalDecrement(TapDownDetails details) {
    setState(() => _goalPushups = (_goalPushups - 1).clamp(0, _maxGoalPushups));
    _goalPressStartTime = DateTime.now();
    _goalAccelerationLevel = 1;
    _goalDecrementTimer?.cancel();
    _goalDecrementTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final elapsed = DateTime.now().difference(_goalPressStartTime!).inSeconds;
      int newLevel = 1;
      if (elapsed >= 5) {
        newLevel = 4;
      } else if (elapsed >= 3) {
        newLevel = 3;
      } else if (elapsed >= 1) {
        newLevel = 2;
      }
      if (newLevel != _goalAccelerationLevel) {
        setState(() => _goalAccelerationLevel = newLevel);
      }
      setState(() {
        _goalPushups = (_goalPushups - _goalAccelerationLevel).clamp(0, _maxGoalPushups);
      });
    });
  }

  void _handleGoalIncrementUp(TapUpDetails details) {
    _goalIncrementTimer?.cancel();
    setState(() => _goalAccelerationLevel = 1);
  }

  void _handleGoalDecrementUp(TapUpDetails details) {
    _goalDecrementTimer?.cancel();
    setState(() => _goalAccelerationLevel = 1);
  }

  void _handleGoalTapCancel() {
    _goalIncrementTimer?.cancel();
    _goalDecrementTimer?.cancel();
    setState(() => _goalAccelerationLevel = 1);
  }

  /// Handle rest time increment with long-press acceleration.
  void _handleRestTimeIncrement(TapDownDetails details) {
    _triggerHapticFeedback();
    setState(() => _restTime = (_restTime + 1).clamp(_minRestTime, _maxRestTime));
    _restTimePressStartTime = DateTime.now();
    _restTimeAccelerationLevel = 1;
    _restTimeIncrementTimer?.cancel();
    _restTimeIncrementTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final elapsed = DateTime.now().difference(_restTimePressStartTime!).inSeconds;
      int newLevel = 1;
      if (elapsed >= 5) {
        newLevel = 4;
      } else if (elapsed >= 3) {
        newLevel = 3;
      } else if (elapsed >= 1) {
        newLevel = 2;
      }
      if (newLevel != _restTimeAccelerationLevel) {
        setState(() => _restTimeAccelerationLevel = newLevel);
      }
      setState(() {
        _restTime = (_restTime + _restTimeAccelerationLevel).clamp(_minRestTime, _maxRestTime);
      });
    });
  }

  /// Handle rest time decrement with long-press acceleration.
  void _handleRestTimeDecrement(TapDownDetails details) {
    _triggerHapticFeedback();
    setState(() => _restTime = (_restTime - 1).clamp(_minRestTime, _maxRestTime));
    _restTimePressStartTime = DateTime.now();
    _restTimeAccelerationLevel = 1;
    _restTimeDecrementTimer?.cancel();
    _restTimeDecrementTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final elapsed = DateTime.now().difference(_restTimePressStartTime!).inSeconds;
      int newLevel = 1;
      if (elapsed >= 5) {
        newLevel = 4;
      } else if (elapsed >= 3) {
        newLevel = 3;
      } else if (elapsed >= 1) {
        newLevel = 2;
      }
      if (newLevel != _restTimeAccelerationLevel) {
        setState(() => _restTimeAccelerationLevel = newLevel);
      }
      setState(() {
        _restTime = (_restTime - _restTimeAccelerationLevel).clamp(_minRestTime, _maxRestTime);
      });
    });
  }

  void _handleRestTimeIncrementUp(TapUpDetails details) {
    _restTimeIncrementTimer?.cancel();
    setState(() => _restTimeAccelerationLevel = 1);
  }

  void _handleRestTimeDecrementUp(TapUpDetails details) {
    _restTimeDecrementTimer?.cancel();
    setState(() => _restTimeAccelerationLevel = 1);
  }

  void _handleRestTimeTapCancel() {
    _restTimeIncrementTimer?.cancel();
    _restTimeDecrementTimer?.cancel();
    setState(() => _restTimeAccelerationLevel = 1);
  }

  /// Trigger haptic feedback on button press.
  void _triggerHapticFeedback() {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {
      // Silently fail if haptics not available
    }
  }

  /// Trigger haptic feedback for starting series buttons.
  void _triggerStartingSeriesHaptic() {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {
      // Silently fail if haptics not available
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPreferences();
    });
  }

  /// Load saved preferences from the provider.
  Future<void> _loadPreferences() async {
    if (!mounted) return;
    final provider = context.read<ActiveWorkoutProvider?>();
    if (provider == null) return;
    await provider.loadWorkoutPreferences();
    if (provider.savedStartingSeries != null) {
      final savedValue = provider.savedStartingSeries!;
      if (savedValue >= _minStartingSeries &&
          savedValue <= _maxStartingSeries &&
          mounted) {
        setState(() => _startingSeries = savedValue);
      }
    }
    if (provider.savedRestTime != null && mounted) {
      setState(() => _restTime = provider.savedRestTime!);
    }
  }

  /// Save current preferences to the provider.
  Future<void> _savePreferences() async {
    if (!mounted) return;
    final provider = context.read<ActiveWorkoutProvider?>();
    if (provider == null) return;
    await provider.saveWorkoutPreferences(
      startingSeries: startingSeries,
      restTime: _restTime,
    );
  }

  /// Start workout with current settings.
  Future<void> _startWorkout() async {
    if (!mounted) return;

    // Check if goal is already complete before navigating
    final userStats = context.read<UserStatsProvider>();
    if (userStats.todayPushups >= UserStatsProvider.dailyGoal) {
      // Show message and prevent navigation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Obiettivo completato!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final provider = context.read<ActiveWorkoutProvider?>();
    if (provider == null) return;
    await provider.startWorkout(
      startingSeries: startingSeries,
      restTime: _restTime,
      goalPushups: _goalPushups > 0 ? _goalPushups : null,
    );
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider<ActiveWorkoutProvider>.value(
            value: provider,
            child: const WorkoutExecutionScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Top bar with back button
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: const Color(0xFFFFB347).withOpacity(0.95),
                            size: 22,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Title
                    Text(
                      'Workout Setup',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Starting Series Card
                    _FrostCardStepper(
                      height: 80,
                      titleTop: _l10n.startingSeries,
                      value: _startingSeries.toString(),
                      titleBottom: '',
                      onMinus: _startingSeries > _minStartingSeries
                          ? () {
                              _triggerStartingSeriesHaptic();
                              setState(() => _startingSeries =
                                  _getPreviousStartingSeries(_startingSeries));
                              _savePreferences();
                            }
                          : null,
                      onPlus: _startingSeries < _maxStartingSeries
                          ? () {
                              _triggerStartingSeriesHaptic();
                              setState(() => _startingSeries =
                                  _getNextStartingSeries(_startingSeries));
                              _savePreferences();
                            }
                          : null,
                    ),

                    const SizedBox(height: 12),

                    // Rest Time Card with acceleration indicator
                    _FrostCardStepper(
                      height: 90,
                      titleTop: _l10n.restTime,
                      value: _restTime.toString(),
                      titleBottom: 'seconds',
                      accelerationLevel: _restTimeAccelerationLevel,
                      useLongPress: true,
                      onMinus: _restTime > _minRestTime ? () => setState(() => _restTime = (_restTime - 1).clamp(_minRestTime, _maxRestTime)) : null,
                      onPlus: _restTime < _maxRestTime ? () => setState(() => _restTime = (_restTime + 1).clamp(_minRestTime, _maxRestTime)) : null,
                      onMinusLongPress: _restTime > _minRestTime ? _handleRestTimeDecrement : null,
                      onPlusLongPress: _restTime < _maxRestTime ? _handleRestTimeIncrement : null,
                      onLongPressEnd: _handleRestTimeTapCancel,
                    ),

                    const SizedBox(height: 12),

                    // Goal Push-ups Card with acceleration indicator
                    _FrostCardStepper(
                      height: 90,
                      titleTop: 'Goal Push-ups',
                      value: _goalPushups > 0 ? _goalPushups.toString() : '-',
                      titleBottom: 'total',
                      accelerationLevel: _goalAccelerationLevel,
                      useLongPress: true,
                      onMinus: _goalPushups > 0 ? () {
                        _triggerHapticFeedback();
                        setState(() => _goalPushups = (_goalPushups - 1).clamp(0, _maxGoalPushups));
                      } : null,
                      onPlus: _goalPushups < _maxGoalPushups ? () {
                        _triggerHapticFeedback();
                        setState(() => _goalPushups = (_goalPushups + 1).clamp(0, _maxGoalPushups));
                      } : null,
                      onMinusLongPress: _goalPushups > 0 ? _handleGoalDecrement : null,
                      onPlusLongPress: _goalPushups < _maxGoalPushups ? _handleGoalIncrement : null,
                      onLongPressEnd: _handleGoalTapCancel,
                    ),

                    const SizedBox(height: 16),

                    // BEGIN WORKOUT Button
                    _PrimaryButton(
                      text: 'BEGIN WORKOUT',
                      onTap: _startWorkout,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Frost card with stepper controls.
class _FrostCardStepper extends StatelessWidget {
  final double height;
  final String titleTop;
  final String value;
  final String titleBottom;
  final int accelerationLevel;
  final bool useLongPress;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final GestureTapDownCallback? onMinusLongPress;
  final GestureTapDownCallback? onPlusLongPress;
  final VoidCallback? onLongPressEnd;

  const _FrostCardStepper({
    required this.height,
    required this.titleTop,
    required this.value,
    required this.titleBottom,
    this.accelerationLevel = 1,
    this.useLongPress = false,
    this.onMinus,
    this.onPlus,
    this.onMinusLongPress,
    this.onPlusLongPress,
    this.onLongPressEnd,
  });

  @override
  Widget build(BuildContext context) {
    final showAcceleration = accelerationLevel > 1;

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          // Remove fixed height, let content determine size
          constraints: const BoxConstraints(minHeight: 70),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1E24).withOpacity(0.55),
            border: Border.all(color: Colors.white.withOpacity(0.10), width: 1),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            children: [
              // Title row with acceleration indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titleTop,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),
                  if (showAcceleration)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5F1F).withOpacity(0.30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${accelerationLevel}x',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFFB347),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // Value row with +/- buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Minus button
                  _CircleIconButton(
                    icon: Icons.remove_rounded,
                    onTap: onMinus,
                    onTapDown: useLongPress ? onMinusLongPress : null,
                    onTapCancel: useLongPress ? onLongPressEnd : null,
                    isEnabled: onMinus != null,
                    useLongPress: useLongPress,
                  ),
                  // Value
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          if (titleBottom.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              titleBottom,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(0.55),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                    // Plus button
                  _CircleIconButton(
                    icon: Icons.add_rounded,
                    onTap: onPlus,
                    onTapDown: useLongPress ? onPlusLongPress : null,
                    onTapCancel: useLongPress ? onLongPressEnd : null,
                    isEnabled: onPlus != null,
                    useLongPress: useLongPress,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circle icon button with gradient and press animation.
class _CircleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final VoidCallback? onTapCancel;
  final bool isEnabled;
  final bool useLongPress;

  const _CircleIconButton({
    required this.icon,
    this.onTap,
    this.onTapDown,
    this.onTapCancel,
    this.isEnabled = true,
    this.useLongPress = false,
  });

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.08),
        ),
        child: Icon(
          widget.icon,
          color: Colors.white.withOpacity(0.25),
          size: 26,
        ),
      );
    }

    Widget button = Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A18).withOpacity(0.35),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        widget.icon,
        color: Colors.black.withOpacity(0.82),
        size: 26,
      ),
    );

    if (widget.useLongPress && widget.onTapDown != null) {
      return GestureDetector(
        onTapDown: widget.onTapDown,
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTapCancel?.call();
        },
        onTapCancel: () {
          setState(() => _pressed = false);
          widget.onTapCancel?.call();
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([]),
          builder: (context, child) {
            return AnimatedScale(
              scale: _pressed ? 0.92 : 1.0,
              duration: const Duration(milliseconds: 90),
              curve: Curves.easeOut,
              child: button,
            );
          },
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() => _pressed = true);
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) setState(() => _pressed = false);
        });
        widget.onTap?.call();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: button,
      ),
    );
  }
}

/// Primary gradient button.
class _PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.text,
    required this.onTap,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          height: 68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF7A18).withOpacity(0.35),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
