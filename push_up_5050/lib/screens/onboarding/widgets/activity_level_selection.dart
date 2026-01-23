import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/screens/onboarding/onboarding_data.dart';

/// Activity level selection widget for onboarding.
///
/// Displays 4 vertically stacked cards representing different activity levels.
/// Users can tap a card to select their activity level, which helps personalize
/// their workout plan (particularly recovery time).
///
/// The widget uses a frosted glass effect for cards with visual feedback
/// for the selected state (orange gradient vs semi-transparent dark background).
class ActivityLevelSelection extends StatelessWidget {
  /// Currently selected activity level
  final ActivityLevel selectedLevel;

  /// Callback invoked when user selects a different activity level
  final ValueChanged<ActivityLevel> onChanged;

  const ActivityLevelSelection({
    super.key,
    required this.selectedLevel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          _getLocalizedTitle(l10n),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white.withOpacity(0.95),
          ),
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          _getLocalizedDesc(l10n),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.60),
          ),
        ),
        const SizedBox(height: 32),

        // Activity level cards
        _ActivityLevelCard(
          icon: Icons.event_seat_rounded,
          title: _getSedentaryTitle(l10n),
          description: _getSedentaryDesc(l10n),
          isSelected: selectedLevel == ActivityLevel.sedentary,
          onTap: () => onChanged(ActivityLevel.sedentary),
        ),
        const SizedBox(height: 16),

        _ActivityLevelCard(
          icon: Icons.directions_walk_rounded,
          title: _getLightlyActiveTitle(l10n),
          description: _getLightlyActiveDesc(l10n),
          isSelected: selectedLevel == ActivityLevel.lightlyActive,
          onTap: () => onChanged(ActivityLevel.lightlyActive),
        ),
        const SizedBox(height: 16),

        _ActivityLevelCard(
          icon: Icons.directions_run_rounded,
          title: _getActiveTitle(l10n),
          description: _getActiveDesc(l10n),
          isSelected: selectedLevel == ActivityLevel.active,
          onTap: () => onChanged(ActivityLevel.active),
        ),
        const SizedBox(height: 16),

        _ActivityLevelCard(
          icon: Icons.fitness_center_rounded,
          title: _getVeryActiveTitle(l10n),
          description: _getVeryActiveDesc(l10n),
          isSelected: selectedLevel == ActivityLevel.veryActive,
          onTap: () => onChanged(ActivityLevel.veryActive),
        ),
      ],
    );
  }

  String _getLocalizedTitle(AppLocalizations l10n) {
    // Try new localization key first, fall back to hardcoded
    try {
      return l10n.onboardingActivityLevel;
    } catch (_) {
      return 'How active are you?';
    }
  }

  String _getLocalizedDesc(AppLocalizations l10n) {
    try {
      return l10n.onboardingActivityLevelDesc;
    } catch (_) {
      return 'This helps us personalize your workout plan';
    }
  }

  String _getSedentaryTitle(AppLocalizations l10n) {
    try {
      return l10n.onboardingSedentary;
    } catch (_) {
      return 'Sedentary';
    }
  }

  String _getSedentaryDesc(AppLocalizations l10n) {
    try {
      return l10n.onboardingSedentaryDesc;
    } catch (_) {
      return 'Little to no exercise';
    }
  }

  String _getLightlyActiveTitle(AppLocalizations l10n) {
    try {
      return l10n.onboardingLightlyActive;
    } catch (_) {
      return 'Lightly Active';
    }
  }

  String _getLightlyActiveDesc(AppLocalizations l10n) {
    try {
      return l10n.onboardingLightlyActiveDesc;
    } catch (_) {
      return 'Exercise 1-3 days per week';
    }
  }

  String _getActiveTitle(AppLocalizations l10n) {
    try {
      return l10n.onboardingActive;
    } catch (_) {
      return 'Active';
    }
  }

  String _getActiveDesc(AppLocalizations l10n) {
    try {
      return l10n.onboardingActiveDesc;
    } catch (_) {
      return 'Exercise 3-5 days per week';
    }
  }

  String _getVeryActiveTitle(AppLocalizations l10n) {
    try {
      return l10n.onboardingVeryActive;
    } catch (_) {
      return 'Very Active';
    }
  }

  String _getVeryActiveDesc(AppLocalizations l10n) {
    try {
      return l10n.onboardingVeryActiveDesc;
    } catch (_) {
      return 'Exercise 6-7 days per week';
    }
  }
}

/// Individual activity level card with frosted glass effect.
class _ActivityLevelCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityLevelCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                )
              : null,
          color: isSelected
              ? null
              : const Color(0xFF1B1E24).withOpacity(0.55),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withOpacity(0.10),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF7A18).withOpacity(0.30),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Colors.black.withOpacity(0.20)
                        : const Color(0xFFFFB347).withOpacity(0.15),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? Colors.black.withOpacity(0.75)
                        : const Color(0xFFFFB347),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? Colors.black.withOpacity(0.85)
                              : Colors.white.withOpacity(0.95),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.black.withOpacity(0.60)
                              : Colors.white.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.black.withOpacity(0.75),
                    size: 28,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
