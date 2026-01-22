import 'package:flutter/material.dart';
import 'package:push_up_5050/core/router.dart';
import 'package:push_up_5050/screens/home/home_screen.dart';
import 'package:push_up_5050/screens/profile/profile_screen.dart';
import 'package:push_up_5050/screens/series_selection/series_selection_screen.dart';
import 'package:push_up_5050/screens/settings/settings_screen.dart';
import 'package:push_up_5050/screens/statistics/statistics_screen.dart';
import 'package:push_up_5050/screens/workout_execution/workout_execution_screen.dart';
import 'package:push_up_5050/widgets/common/bottom_navigation_bar.dart';

/// Main navigation wrapper that manages bottom navigation state and screen switching.
///
/// This widget:
/// - Manages the current tab index (Home: 0, Stats: 1, Profile: 2, Settings: 3)
/// - Switches screens based on selected tab
/// - Provides navigation methods for push navigation (Series Selection, Workout)
/// - Wraps each screen with the appropriate bottom navigation configuration
class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => MainNavigationWrapperState();
}

/// State class for MainNavigationWrapper.
///
/// Provides public methods for navigation:
/// - `onTabTap(int index)` - Switch bottom nav tab
/// - `navigateToSeriesSelection()` - Push to series selection screen
/// - `navigateToWorkout()` - Push to workout execution screen
/// - `navigateToHome()` - Switch to home tab (index 0)
class MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  /// Currently selected tab index
  int get currentIndex => _currentIndex;

  /// Handle bottom navigation tab tap
  void onTabTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// Navigate to Series Selection screen (push navigation)
  void navigateToSeriesSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SeriesSelectionScreen(),
      ),
    );
  }

  /// Navigate to Workout Execution screen (push navigation)
  void navigateToWorkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WorkoutExecutionScreen(),
      ),
    );
  }

  /// Navigate to Home tab (switch navigation)
  void navigateToHome() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentScreen(),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTap: onTabTap,
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          onStartWorkout: navigateToSeriesSelection,
        );
      case 1:
        return StatisticsScreen();
      case 2:
        return ProfileScreen();
      case 3:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }
}

/// Extension to provide bottom navigation wrapper for screens that need it.
///
/// Screens that want to include bottom navigation should wrap their content
/// with a Scaffold that has the bottomNavigationBar set to AppBottomNavigationBar.
///
/// The individual screens (HomeScreen, StatisticsScreen, ProfileScreen, SettingsScreen) already
/// include their own bottom navigation, so this wrapper only manages the state.
