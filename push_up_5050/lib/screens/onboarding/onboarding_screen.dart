import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/main_navigation_wrapper.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

/// Onboarding screen - first-time user introduction with goal configuration.
///
/// Displays 3 pages:
/// 1. Welcome - App introduction with philosophy
/// 2. How It Works - Feature overview with icons
/// 3. Set Your Goals - Daily/monthly goal configuration
///
/// Features:
/// - PageView with swipe navigation
/// - Dot indicator showing current page
/// - Long-press acceleration for goal adjustment
/// - Progress preview based on selected daily goal
/// - Saves goals and onboarding flag on completion
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  static const int _minDailyGoal = 10;
  static const int _maxDailyGoal = 200;
  static const int _totalTarget = 5050;

  late PageController _pageController;
  int _currentPage = 0;
  int _dailyGoal = 50;
  int _monthlyGoal = 1500;
  bool _editingMonthlyGoal = false;

  // Long-press acceleration for daily goal
  Timer? _goalIncrementTimer;
  Timer? _goalDecrementTimer;
  int _goalAccelerationLevel = 1;
  DateTime? _goalPressStartTime;

  // Long-press acceleration for monthly goal
  Timer? _monthlyIncrementTimer;
  Timer? _monthlyDecrementTimer;
  int _monthlyAccelerationLevel = 1;
  DateTime? _monthlyPressStartTime;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _updateMonthlyGoal();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _goalIncrementTimer?.cancel();
    _goalDecrementTimer?.cancel();
    _monthlyIncrementTimer?.cancel();
    _monthlyDecrementTimer?.cancel();
    super.dispose();
  }

  void _updateMonthlyGoal() {
    _monthlyGoal = _dailyGoal * 30;
  }

  /// Calculate progress preview text based on daily goal
  String _getProgressPreview() {
    if (_dailyGoal <= 0) return '';

    final daysNeeded = (_totalTarget / _dailyGoal).ceil();
    final monthsNeeded = (daysNeeded / 30).ceil();

    if (_l10n.appLocale?.languageCode == 'it') {
      if (monthsNeeded <= 1) {
        return 'A questo ritmo raggiungerai 5050 in circa $monthsNeeded mese';
      } else if (monthsNeeded <= 6) {
        return 'A questo ritmo raggiungerai 5050 in circa $monthsNeeded mesi';
      } else if (monthsNeeded <= 12) {
        return 'A questo ritmo raggiungerai 5050 in circa 1 anno';
      } else {
        final years = (monthsNeeded / 12).ceil();
        return 'A questo ritmo raggiungerai 5050 in circa $years anni';
      }
    } else {
      if (monthsNeeded <= 1) {
        return 'At this pace, you\'ll reach 5050 in about $monthsNeeded month';
      } else if (monthsNeeded <= 6) {
        return 'At this pace, you\'ll reach 5050 in about $monthsNeeded months';
      } else if (monthsNeeded <= 12) {
        return 'At this pace, you\'ll reach 5050 in about 1 year';
      } else {
        final years = (monthsNeeded / 12).ceil();
        return 'At this pace, you\'ll reach 5050 in about $years years';
      }
    }
  }

  /// Handle daily goal increment with long-press acceleration
  void _handleGoalIncrement(TapDownDetails details) {
    setState(() => _dailyGoal = (_dailyGoal + 1).clamp(_minDailyGoal, _maxDailyGoal));
    _updateMonthlyGoal();
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
      if (newLevel != _goalAccelerationLevel && mounted) {
        setState(() => _goalAccelerationLevel = newLevel);
      }
      if (mounted) {
        setState(() {
          _dailyGoal = (_dailyGoal + _goalAccelerationLevel).clamp(_minDailyGoal, _maxDailyGoal);
          _updateMonthlyGoal();
        });
      }
    });
  }

  /// Handle daily goal decrement with long-press acceleration
  void _handleGoalDecrement(TapDownDetails details) {
    setState(() => _dailyGoal = (_dailyGoal - 1).clamp(_minDailyGoal, _maxDailyGoal));
    _updateMonthlyGoal();
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
      if (newLevel != _goalAccelerationLevel && mounted) {
        setState(() => _goalAccelerationLevel = newLevel);
      }
      if (mounted) {
        setState(() {
          _dailyGoal = (_dailyGoal - _goalAccelerationLevel).clamp(_minDailyGoal, _maxDailyGoal);
          _updateMonthlyGoal();
        });
      }
    });
  }

  void _handleGoalTapCancel() {
    _goalIncrementTimer?.cancel();
    _goalDecrementTimer?.cancel();
    if (mounted) setState(() => _goalAccelerationLevel = 1);
  }

  /// Handle monthly goal increment with long-press acceleration
  void _handleMonthlyIncrement(TapDownDetails details) {
    setState(() => _monthlyGoal = _monthlyGoal + 10);
    _monthlyPressStartTime = DateTime.now();
    _monthlyAccelerationLevel = 1;
    _monthlyIncrementTimer?.cancel();
    _monthlyIncrementTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final elapsed = DateTime.now().difference(_monthlyPressStartTime!).inSeconds;
      int newLevel = 1;
      if (elapsed >= 5) {
        newLevel = 4;
      } else if (elapsed >= 3) {
        newLevel = 3;
      } else if (elapsed >= 1) {
        newLevel = 2;
      }
      if (newLevel != _monthlyAccelerationLevel && mounted) {
        setState(() => _monthlyAccelerationLevel = newLevel);
      }
      if (mounted) {
        setState(() => _monthlyGoal = _monthlyGoal + (10 * _monthlyAccelerationLevel));
      }
    });
  }

  /// Handle monthly goal decrement with long-press acceleration
  void _handleMonthlyDecrement(TapDownDetails details) {
    setState(() => _monthlyGoal = (_monthlyGoal - 10).clamp(10, 10000));
    _monthlyPressStartTime = DateTime.now();
    _monthlyAccelerationLevel = 1;
    _monthlyDecrementTimer?.cancel();
    _monthlyDecrementTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final elapsed = DateTime.now().difference(_monthlyPressStartTime!).inSeconds;
      int newLevel = 1;
      if (elapsed >= 5) {
        newLevel = 4;
      } else if (elapsed >= 3) {
        newLevel = 3;
      } else if (elapsed >= 1) {
        newLevel = 2;
      }
      if (newLevel != _monthlyAccelerationLevel && mounted) {
        setState(() => _monthlyAccelerationLevel = newLevel);
      }
      if (mounted) {
        setState(() => _monthlyGoal = (_monthlyGoal - (10 * _monthlyAccelerationLevel)).clamp(10, 10000));
      }
    });
  }

  void _handleMonthlyTapCancel() {
    _monthlyIncrementTimer?.cancel();
    _monthlyDecrementTimer?.cancel();
    if (mounted) setState(() => _monthlyAccelerationLevel = 1);
  }

  /// Navigate to next page
  void _goToNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Navigate to previous page
  void _goToBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Complete onboarding and save goals
  Future<void> _completeOnboarding() async {
    final storage = context.read<StorageService>();
    await storage.setDailyGoal(_dailyGoal);
    await storage.setMonthlyGoal(_monthlyGoal);
    await storage.setOnboardingCompleted(true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // PageView takes remaining space
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  children: [
                    _buildWelcomePage(),
                    _buildHowItWorksPage(),
                    _buildGoalsPage(),
                  ],
                ),
              ),

              // Dot indicator and navigation buttons
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  /// Page 1: Welcome
  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hero illustration placeholder
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF7A18).withOpacity(0.40),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '5050',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withOpacity(0.75),
                  letterSpacing: -2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // App title
          Text(
            'PUSHUP 5050',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.95),
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 24),

          // Welcome title
          Text(
            _l10n.onboardingWelcomeTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFFB347),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Philosophy text
          Text(
            _l10n.onboardingPhilosophyTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white.withOpacity(0.90),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            _l10n.onboardingPhilosophyText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.65),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Page 2: How It Works
  Widget _buildHowItWorksPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Text(
            _l10n.onboardingHowItWorksTitle,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.95),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 48),

          // Feature list
          _FeatureItem(
            icon: Icons.trending_up_rounded,
            title: _l10n.onboardingProgressiveSeries,
            description: _l10n.onboardingProgressiveSeriesDesc,
          ),

          const SizedBox(height: 24),

          _FeatureItem(
            icon: Icons.calendar_today_rounded,
            title: _l10n.onboardingStreakTracking,
            description: _l10n.onboardingStreakTrackingDesc,
          ),

          const SizedBox(height: 24),

          _FeatureItem(
            icon: Icons.stars_rounded,
            title: _l10n.onboardingPointsSystem,
            description: _l10n.onboardingPointsSystemDesc,
          ),

          const SizedBox(height: 24),

          _FeatureItem(
            icon: Icons.emoji_events_rounded,
            title: _l10n.onboardingAchievements,
            description: _l10n.onboardingAchievementsDesc,
          ),
        ],
      ),
    );
  }

  /// Page 3: Goals
  Widget _buildGoalsPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Text(
            _l10n.onboardingGoalTitle,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.95),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 48),

          // Daily goal card
          _GoalCard(
            title: _l10n.onboardingDailyGoal,
            value: _dailyGoal.toString(),
            unit: _l10n.onboardingPushups,
            accelerationLevel: _goalAccelerationLevel,
            showAcceleration: _goalAccelerationLevel > 1,
            onMinus: _dailyGoal > _minDailyGoal ? _handleGoalDecrement : null,
            onPlus: _dailyGoal < _maxDailyGoal ? _handleGoalIncrement : null,
            onLongPressEnd: _handleGoalTapCancel,
          ),

          const SizedBox(height: 24),

          // Monthly goal card
          _GoalCard(
            title: _l10n.onboardingMonthlyGoal,
            value: _monthlyGoal.toString(),
            unit: _l10n.onboardingPushups,
            accelerationLevel: _monthlyAccelerationLevel,
            showAcceleration: _monthlyAccelerationLevel > 1,
            isEditable: true,
            onMinus: _monthlyGoal > 100 ? _handleMonthlyDecrement : null,
            onPlus: _monthlyGoal < 10000 ? _handleMonthlyIncrement : null,
            onLongPressEnd: _handleMonthlyTapCancel,
          ),

          const SizedBox(height: 32),

          // Progress preview
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1E24).withOpacity(0.60),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFFB347).withOpacity(0.30),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFFFB347),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getProgressPreview(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom controls with dot indicator and navigation buttons
  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        children: [
          // Dot indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFFFB347) : Colors.white.withOpacity(0.30),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          // Navigation button
          SizedBox(
            width: double.infinity,
            height: 64,
            child: _buildNavigationButton(),
          ),
        ],
      ),
    );
  }

  /// Build navigation button based on current page
  Widget _buildNavigationButton() {
    if (_currentPage == 0) {
      // First page: Only Next button
      return _GradientButton(
        text: _l10n.onboardingNext,
        onTap: _goToNext,
      );
    } else if (_currentPage == 1) {
      // Second page: Back and Next buttons
      return Row(
        children: [
          Expanded(
            child: _OutlinedButton(
              text: _l10n.onboardingBack,
              onTap: _goToBack,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _GradientButton(
              text: _l10n.onboardingNext,
              onTap: _goToNext,
            ),
          ),
        ],
      );
    } else {
      // Third page: Back and Get Started buttons
      return Row(
        children: [
          Expanded(
            child: _OutlinedButton(
              text: _l10n.onboardingBack,
              onTap: _goToBack,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _GradientButton(
              text: _l10n.onboardingGetStarted,
              onTap: _completeOnboarding,
            ),
          ),
        ],
      );
    }
  }
}

/// Feature item widget for "How It Works" page
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1E24).withOpacity(0.50),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
              ),
            ),
            child: Icon(
              icon,
              color: Colors.black.withOpacity(0.75),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.60),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Goal card widget for goal selection
class _GoalCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final int accelerationLevel;
  final bool showAcceleration;
  final bool isEditable;
  final GestureTapDownCallback? onMinus;
  final GestureTapDownCallback? onPlus;
  final VoidCallback? onLongPressEnd;

  const _GoalCard({
    required this.title,
    required this.value,
    required this.unit,
    this.accelerationLevel = 1,
    this.showAcceleration = false,
    this.isEditable = false,
    this.onMinus,
    this.onPlus,
    this.onLongPressEnd,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1E24).withOpacity(0.55),
            border: Border.all(color: Colors.white.withOpacity(0.10), width: 1),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.30),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.70),
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
              const SizedBox(height: 16),
              // Value row with +/- buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Minus button
                  _CircleButton(
                    icon: Icons.remove_rounded,
                    onTapDown: onMinus,
                    onTapCancel: onLongPressEnd,
                    isEnabled: onMinus != null,
                  ),
                  // Value display
                  Column(
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),
                  // Plus button
                  _CircleButton(
                    icon: Icons.add_rounded,
                    onTapDown: onPlus,
                    onTapCancel: onLongPressEnd,
                    isEnabled: onPlus != null,
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

/// Circle button for +/- controls
class _CircleButton extends StatefulWidget {
  final IconData icon;
  final GestureTapDownCallback? onTapDown;
  final VoidCallback? onTapCancel;
  final bool isEnabled;

  const _CircleButton({
    required this.icon,
    this.onTapDown,
    this.onTapCancel,
    this.isEnabled = true,
  });

  @override
  State<_CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<_CircleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.08),
        ),
        child: Icon(
          widget.icon,
          color: Colors.white.withOpacity(0.25),
          size: 28,
        ),
      );
    }

    Widget button = Container(
      width: 56,
      height: 56,
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
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        widget.icon,
        color: Colors.black.withOpacity(0.75),
        size: 28,
      ),
    );

    return GestureDetector(
      onTapDown: widget.onTapDown != null
          ? (_) {
              setState(() => _pressed = true);
              widget.onTapDown?.call(_);
            }
          : null,
      onTapUp: widget.onTapCancel != null
          ? (_) {
              setState(() => _pressed = false);
              widget.onTapCancel?.call();
            }
          : null,
      onTapCancel: widget.onTapCancel != null
          ? () {
              setState(() => _pressed = false);
              widget.onTapCancel?.call();
            }
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: button,
      ),
    );
  }
}

/// Primary gradient button
class _GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _GradientButton({
    required this.text,
    required this.onTap,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
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
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF7A18).withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined secondary button
class _OutlinedButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _OutlinedButton({
    required this.text,
    required this.onTap,
  });

  @override
  State<_OutlinedButton> createState() => _OutlinedButtonState();
}

class _OutlinedButtonState extends State<_OutlinedButton> {
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
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.30),
              width: 1.5,
            ),
            color: Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ),
      ),
    );
  }
}
