import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/main_navigation_wrapper.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/screens/onboarding/onboarding_data.dart';
import 'package:push_up_5050/screens/onboarding/widgets/activity_level_selection.dart';
import 'package:push_up_5050/screens/onboarding/widgets/capacity_slider.dart';
import 'package:push_up_5050/screens/onboarding/widgets/frequency_selector.dart';
import 'package:push_up_5050/screens/onboarding/widgets/daily_goal_slider.dart';

/// Personalized onboarding screen with 4-step flow.
///
/// This screen guides new users through a personalized onboarding experience:
/// 1. Activity Level Selection (4 cards with icons)
/// 2. Max Capacity Slider (preset values: 5, 10, 20, 30, 40, 50)
/// 3. Workout Frequency Selector (1-7 days per week)
/// 4. Daily Goal Slider (preset values: 20, 30, 40, 50, 60, 75, 100)
///
/// Features:
/// - PageView with smooth swipe navigation
/// - Dot indicator showing current position (4 dots)
/// - Back/Next navigation buttons
/// - Data persistence via StorageService and ActiveWorkoutProvider
class PersonalizedOnboardingScreen extends StatefulWidget {
  const PersonalizedOnboardingScreen({super.key});

  @override
  State<PersonalizedOnboardingScreen> createState() =>
      _PersonalizedOnboardingScreenState();
}

class _PersonalizedOnboardingScreenState
    extends State<PersonalizedOnboardingScreen> {
  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  // Page controller for PageView
  late PageController _pageController;

  // Current page index (0-3)
  int _currentPage = 0;

  // Onboarding data with defaults
  ActivityLevel _activityLevel = ActivityLevel.lightlyActive;
  int _maxCapacity = 20;
  int _frequencyDays = 5;
  int _dailyGoal = 50;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Navigate to next page if not on last page
  void _goToNext() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Navigate to previous page if not on first page
  void _goBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
                    _buildActivityLevelPage(),
                    _buildCapacityPage(),
                    _buildFrequencyPage(),
                    _buildDailyGoalPage(),
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

  /// Page 1: Activity Level Selection
  Widget _buildActivityLevelPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ActivityLevelSelection(
        selectedLevel: _activityLevel,
        onChanged: (level) {
          setState(() => _activityLevel = level);
        },
      ),
    );
  }

  /// Page 2: Max Capacity Slider
  Widget _buildCapacityPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: CapacitySlider(
        value: _maxCapacity,
        onChanged: (value) {
          setState(() => _maxCapacity = value);
        },
      ),
    );
  }

  /// Page 3: Workout Frequency Selector
  Widget _buildFrequencyPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: FrequencySelector(
          value: _frequencyDays,
          onChanged: (value) {
            setState(() => _frequencyDays = value);
          },
        ),
      ),
    );
  }

  /// Page 4: Daily Goal Slider
  Widget _buildDailyGoalPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: DailyGoalSlider(
          value: _dailyGoal,
          onChanged: (value) {
            setState(() => _dailyGoal = value);
          },
        ),
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
            children: List.generate(4, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFFFB347)
                      : Colors.white.withOpacity(0.30),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          // Navigation buttons
          SizedBox(
            width: double.infinity,
            height: 64,
            child: _buildNavigationButtons(),
          ),
        ],
      ),
    );
  }

  /// Build navigation buttons based on current page
  Widget _buildNavigationButtons() {
    if (_currentPage == 0) {
      // First page: Only Next button
      return _GradientButton(
        text: _l10n.onboardingNext,
        onTap: _goToNext,
      );
    } else if (_currentPage == 1 || _currentPage == 2) {
      // Middle pages: Back and Next buttons
      return Row(
        children: [
          Expanded(
            child: _OutlinedButton(
              text: _l10n.onboardingBack,
              onTap: _goBack,
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
      // Last page: Back and Get Started buttons
      return Row(
        children: [
          Expanded(
            child: _OutlinedButton(
              text: _l10n.onboardingBack,
              onTap: _goBack,
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

  /// Complete onboarding and save all data
  Future<void> _completeOnboarding() async {
    // Create OnboardingData instance from current state
    final onboardingData = OnboardingData(
      activityLevel: _activityLevel,
      maxCapacity: _maxCapacity,
      frequencyDays: _frequencyDays,
      dailyGoal: _dailyGoal,
    );

    // Calculate recommendations using OnboardingData getters
    final startingSeries = onboardingData.startingSeries;
    final recoveryTime = onboardingData.recoveryTime;
    final dailyGoal = onboardingData.dailyGoal;

    // Save to StorageService
    final storage = context.read<StorageService>();
    await storage.setDailyGoal(dailyGoal);
    await storage.setMonthlyGoal(dailyGoal * 30);

    // Save workout preferences to ActiveWorkoutProvider
    final provider = context.read<ActiveWorkoutProvider>();
    await provider.saveWorkoutPreferences(
      startingSeries: startingSeries,
      restTime: recoveryTime,
    );

    // Mark onboarding as completed (MUST BE LAST)
    await storage.setOnboardingCompleted(true);

    // Navigate to main app
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
      );
    }
  }
}

/// Primary gradient button.
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

/// Outlined secondary button.
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
