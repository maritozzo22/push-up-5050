import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'package:push_up_5050/core/theme/app_theme.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';

/// Custom bottom navigation bar for the app.
///
/// Displays 4 tabs: Home, Stats, Profile, and Settings.
/// Follows the design specifications from UI_MOCKUPS.md.
class AppBottomNavigationBar extends StatelessWidget {
  /// Currently selected tab index (0-3)
  final int currentIndex;

  /// Callback when a tab is tapped
  final ValueChanged<int> onTabTap;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.background.withOpacity(0.9),
      selectedItemColor: AppColors.primaryOrange,
      unselectedItemColor: AppColors.textSecondary,
      elevation: 8,
      selectedLabelStyle: AppTextStyles.caption,
      unselectedLabelStyle: AppTextStyles.caption,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined, size: 24),
          activeIcon: const Icon(Icons.home, size: 24),
          label: l10n.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bar_chart_outlined, size: 24),
          activeIcon: const Icon(Icons.bar_chart, size: 24),
          label: l10n.stats,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline, size: 24),
          activeIcon: const Icon(Icons.person, size: 24),
          label: l10n.profile,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined, size: 24),
          activeIcon: const Icon(Icons.settings, size: 24),
          label: l10n.settings,
        ),
      ],
    );
  }
}
