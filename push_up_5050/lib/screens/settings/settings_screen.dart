import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/models/haptic_intensity.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/screens/onboarding/personalized_onboarding_screen.dart';
import 'package:push_up_5050/services/app_settings_service.dart';
import 'package:push_up_5050/services/notification_service.dart';
import 'package:push_up_5050/widgets/design_system/app_background.dart';
import 'package:push_up_5050/widgets/design_system/settings_switch_tile.dart';
import 'package:push_up_5050/widgets/design_system/settings_slider_tile.dart';

/// Settings screen - allows user to configure app preferences.
///
/// New design with dark glass + orange glow effect.
///
/// Displays:
/// - Language settings (Italian/English)
/// - Sensor settings (proximity sensor toggle)
/// - Feedback settings (haptic intensity)
/// - Workout settings (recovery time slider)
/// - Notification settings (daily reminder + time picker)
/// - Audio settings (master, beep, achievement, push-up, goal sounds + volume)
/// - Reset to defaults button
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    final notificationService = context.read<NotificationService>();
    final enabled = await notificationService.areNotificationsEnabled();
    if (mounted) {
      setState(() {
        _notificationsEnabled = enabled;
      });
    }
  }

  Future<void> _requestNotificationPermission() async {
    final notificationService = context.read<NotificationService>();
    final granted = await notificationService.requestPermissions();

    if (!granted && mounted) {
      // Show explanation and offer to open settings
      _showPermissionDeniedDialog(context);
    } else {
      // Refresh status
      await _checkNotificationStatus();
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          l10n.notificationPermissionRequired,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        content: Text(
          l10n.notificationPermissionExplanation,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.80),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.notificationCancel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final notificationService = context.read<NotificationService>();
              await notificationService.openNotificationSettings();
              // Note: Status will update when user returns to app
            },
            child: Text(
              l10n.notificationOpenSettings,
              style: const TextStyle(
                color: Color(0xFFFFB347),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Consumer<AppSettingsService>(
                  builder: (context, settings, child) {
                    return Column(
                      children: [
                        const SizedBox(height: 24),

                        // Top bar with back button and title
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
                            const SizedBox(width: 16),
                            Text(
                              l10n.settingsTitle,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Language Settings Card
                        _SettingsSectionCard(
                          icon: Icons.language,
                          title: l10n.language,
                          child: _buildLanguageDropdown(settings: settings),
                        ),

                        const SizedBox(height: 16),

                        // Sensor Settings Card
                        _SettingsSectionCard(
                          icon: Icons.sensors,
                          title: l10n.sensors,
                          child: SettingsSwitchTile(
                            title: l10n.settingsProximitySensor,
                            subtitle: l10n.settingsProximitySensorDesc,
                            value: settings.proximitySensorEnabled,
                            onChanged: (value) {
                              settings.setProximitySensorEnabled(value);
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Feedback Settings Card
                        _SettingsSectionCard(
                          icon: Icons.vibration,
                          title: l10n.feedback,
                          child: _buildHapticIntensityDropdown(
                            settings: settings,
                            l10n: l10n,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Workout Settings Card
                        _SettingsSectionCard(
                          icon: Icons.timer,
                          title: l10n.workout,
                          child: SettingsSliderTile(
                            title: l10n.settingsDefaultRecoveryTime,
                            value: settings.defaultRecoveryTime.toDouble(),
                            valueDisplay: '${settings.defaultRecoveryTime}s',
                            min: 5,
                            max: 60,
                            divisions: 11,
                            icon: Icons.timer_outlined,
                            onChanged: (value) {
                              settings.setDefaultRecoveryTime(value.toInt());
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Notifications Settings Card
                        _SettingsSectionCard(
                          icon: Icons.notifications,
                          title: l10n.notifications,
                          child: Column(
                            children: [
                              // Permission status display
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  _notificationsEnabled
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _notificationsEnabled
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                title: Text(
                                  _notificationsEnabled
                                      ? l10n.notificationsEnabled
                                      : l10n.notificationsDisabled,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: _notificationsEnabled
                                    ? null
                                    : ElevatedButton(
                                        onPressed: () async {
                                          await _requestNotificationPermission();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFFFB347),
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                        child: Text(
                                          l10n.requestNotificationPermission,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 8),
                              SettingsSwitchTile(
                                title: l10n.settingsDailyReminder,
                                subtitle: l10n.settingsDailyReminderDesc,
                                value: settings.dailyReminderEnabled,
                                onChanged: (value) async {
                                  await settings.setDailyReminderEnabled(value);
                                  if (value && mounted) {
                                    _showTimePicker(context, settings);
                                  } else {
                                    final notificationService =
                                        context.read<NotificationService>();
                                    await notificationService
                                        .cancelDailyReminder();
                                  }
                                },
                              ),
                              if (settings.dailyReminderEnabled)
                                _buildReminderTimeTile(
                                  settings: settings,
                                  l10n: l10n,
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Audio Settings Card
                        _SettingsSectionCard(
                          icon: Icons.volume_up,
                          title: l10n.audio,
                          child: Column(
                            children: [
                              SettingsSwitchTile(
                                title: l10n.settingsSoundsMaster,
                                subtitle: l10n.settingsSoundsMasterDesc,
                                value: settings.soundsEnabled,
                                onChanged: (value) {
                                  settings.setSoundsEnabled(value);
                                },
                              ),
                              if (settings.soundsEnabled) ...[
                                SettingsSwitchTile(
                                  title: l10n.settingsBeepSound,
                                  subtitle: l10n.settingsBeepSoundDesc,
                                  value: settings.beepEnabled,
                                  onChanged: (value) {
                                    settings.setBeepEnabled(value);
                                  },
                                ),
                                SettingsSwitchTile(
                                  title: l10n.settingsAchievementSound,
                                  subtitle: l10n.settingsAchievementSoundDesc,
                                  value: settings.achievementSoundEnabled,
                                  onChanged: (value) {
                                    settings.setAchievementSoundEnabled(value);
                                  },
                                ),
                                SettingsSwitchTile(
                                  title: 'Suono Push-up',
                                  subtitle: 'Suono quando conti una ripetizione',
                                  value: settings.pushupSoundEnabled,
                                  onChanged: (value) {
                                    settings.setPushupSoundEnabled(value);
                                  },
                                ),
                                SettingsSwitchTile(
                                  title: 'Suono Obiettivo Raggiunto',
                                  subtitle: 'Suono quando raggiungi l\'obiettivo',
                                  value: settings.goalSoundEnabled,
                                  onChanged: (value) {
                                    settings.setGoalSoundEnabled(value);
                                  },
                                ),
                                const SizedBox(height: 8),
                                SettingsSliderTile(
                                  title: l10n.settingsVolume,
                                  value: settings.volume,
                                  valueDisplay: '${(settings.volume * 100).toInt()}%',
                                  min: 0,
                                  max: 1,
                                  divisions: 20,
                                  icon: Icons.volume_up,
                                  onChanged: (value) {
                                    settings.setVolume(value);
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Reset Settings Button
                        TextButton.icon(
                          onPressed: () => _showResetDialog(context, settings, l10n),
                          icon: const Icon(Icons.restore, color: Color(0xFFFFB347)),
                          label: Text(
                            l10n.settingsResetDefaults,
                            style: const TextStyle(
                              color: Color(0xFFFFB347),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Reset Profile Button (resets all user data)
                        TextButton.icon(
                          onPressed: () => _showResetProfileDialog(context, l10n),
                          icon: const Icon(Icons.delete_forever, color: Color(0xFFF44336)),
                          label: Text(
                            'Reset Profilo',
                            style: const TextStyle(
                              color: Color(0xFFF44336),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Restart Tutorial Button
                        TextButton.icon(
                          onPressed: () => _showRestartTutorialDialog(context, l10n),
                          icon: const Icon(Icons.info_outline, color: Color(0xFF2196F3)),
                          label: Text(
                            l10n.settingsRestartTutorial,
                            style: const TextStyle(
                              color: Color(0xFF2196F3),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown({
    required AppSettingsService settings,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.language,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.10),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: settings.appLanguage,
              dropdownColor: const Color(0xFF1A1F28),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              iconEnabledColor: const Color(0xFFFFB347),
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: 'it',
                  child: Text(l10n.italian),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text(l10n.english),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  settings.setAppLanguage(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHapticIntensityDropdown({
    required AppSettingsService settings,
    required AppLocalizations l10n,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsHapticIntensity,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.10),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<HapticIntensity>(
              value: settings.hapticIntensity,
              dropdownColor: const Color(0xFF1A1F28),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              iconEnabledColor: const Color(0xFFFFB347),
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: HapticIntensity.off,
                  child: Text(HapticIntensity.off.localizedLabel(context)),
                ),
                DropdownMenuItem(
                  value: HapticIntensity.light,
                  child: Text(HapticIntensity.light.localizedLabel(context)),
                ),
                DropdownMenuItem(
                  value: HapticIntensity.medium,
                  child: Text(HapticIntensity.medium.localizedLabel(context)),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  settings.setHapticIntensity(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReminderTimeTile({
    required AppSettingsService settings,
    required AppLocalizations l10n,
  }) {
    final time = settings.dailyReminderTime;
    final formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: () => _showTimePicker(context, settings),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFFB347).withOpacity(0.30),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.settingsReminderTime,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Text(
                  formattedTime,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFFB347),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.access_time,
                  size: 18,
                  color: Color(0xFFFFB347),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker(
    BuildContext context,
    AppSettingsService settings,
  ) async {
    final initialTime = settings.dailyReminderTime;

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFFB347),
              onPrimary: Colors.white,
              surface: Color(0xFF1A1F28),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      await settings.setDailyReminderTime(picked);
      final notificationService = context.read<NotificationService>();
      await notificationService.scheduleDailyReminder(
        hour: picked.hour,
        minute: picked.minute,
      );
    }
  }

  void _showResetDialog(
    BuildContext context,
    AppSettingsService settings,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          l10n.settingsResetDefaults,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        content: Text(
          l10n.settingsResetConfirm,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.80),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.settingsResetConfirmNo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await settings.resetToDefaults();
              if (context.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: Text(
              l10n.settingsResetConfirmYes,
              style: const TextStyle(
                color: Color(0xFFFFB347),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetProfileDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Reset Profilo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        content: const Text(
          'Questo eliminerà TUTTI i tuoi dati:\n\n'
          '• Storia allenamenti\n'
          '• Achievement sbloccati\n'
          '• Statistiche e punti\n'
          '• Data inizio programma\n'
          '• Preferenze workout\n\n'
          'Questa azione NON può essere annullata.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Annulla',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final storage = context.read<StorageService>();
              final userStats = context.read<UserStatsProvider>();

              await storage.resetAllUserData();
              await userStats.loadStats();

              if (context.mounted) {
                Navigator.pop(dialogContext);
                // Show confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profilo resettato con successo'),
                    backgroundColor: Color(0xFF4CAF50),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text(
              'Elimina tutto',
              style: TextStyle(
                color: Color(0xFFF44336),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRestartTutorialDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          l10n.settingsRestartTutorial,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        content: Text(
          l10n.settingsRestartTutorialDesc,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.80),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.settingsResetConfirmNo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final storage = context.read<StorageService>();
              await storage.resetOnboarding();
              if (context.mounted) {
                Navigator.pop(dialogContext);
                // Navigate to onboarding
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const PersonalizedOnboardingScreen(),
                  ),
                );
              }
            },
            child: Text(
              l10n.onboardingGetStarted,
              style: const TextStyle(
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings section card with glass effect.
class _SettingsSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SettingsSectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF161A20).withOpacity(0.60),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and title
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
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
                      size: 16,
                      color: Colors.black.withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Content
              child,
            ],
          ),
        ),
      ),
    );
  }
}
