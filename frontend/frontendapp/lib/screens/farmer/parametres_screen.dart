import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../l10n/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';

class ParametresScreen extends StatelessWidget {
  const ParametresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: s.settingsTitle, showBack: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          _SettingRow(
            icon: Icons.notifications_outlined,
            label: s.settingsNotifications,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
          _SettingRow(
            icon: Icons.language_outlined,
            label: s.settingsLanguage,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageScreen())),
          ),
          _SettingRow(
            icon: Icons.straighten_outlined,
            label: s.settingsUnits,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UnitsScreen())),
          ),
          _SettingRow(
            icon: Icons.info_outline,
            label: s.settingsAbout,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 19, color: AppColors.greenDark),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTextStyles.body)),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

// ---------- Notifications ----------

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: s.notificationsScreenTitle, showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.notificationsToggleLabel, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(s.notificationsToggleBody, style: AppTextStyles.bodyMuted),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: settings.notificationsEnabled,
                activeColor: AppColors.green,
                onChanged: (v) => context.read<SettingsProvider>().setNotificationsEnabled(v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Langue ----------

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: s.languageScreenTitle, showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _ChoiceRow(
              label: s.languageFrench,
              selected: settings.language == langFr,
              onTap: () => context.read<SettingsProvider>().setLanguage(langFr),
            ),
            const SizedBox(height: 10),
            _ChoiceRow(
              label: s.languageEnglish,
              selected: settings.language == langEn,
              onTap: () => context.read<SettingsProvider>().setLanguage(langEn),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Unités de mesure ----------

class UnitsScreen extends StatelessWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: s.unitsScreenTitle, showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(s.unitsTempLabel, style: AppTextStyles.heading),
            const SizedBox(height: 10),
            _ChoiceRow(
              label: s.unitsCelsius,
              selected: settings.tempUnit == tempUnitCelsius,
              onTap: () => context.read<SettingsProvider>().setTempUnit(tempUnitCelsius),
            ),
            const SizedBox(height: 10),
            _ChoiceRow(
              label: s.unitsKelvin,
              selected: settings.tempUnit == tempUnitKelvin,
              onTap: () => context.read<SettingsProvider>().setTempUnit(tempUnitKelvin),
            ),
            const SizedBox(height: 18),
            Text(s.unitsHumidityNote, style: AppTextStyles.bodyMuted),
          ],
        ),
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceRow({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.greenSoft : AppColors.surface,
          border: Border.all(color: selected ? AppColors.green : AppColors.line),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: selected ? AppColors.green : AppColors.muted,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.greenDark : AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- À propos ----------

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: s.aboutScreenTitle, showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          s.aboutBody,
          style: const TextStyle(fontSize: 13.5, height: 1.6, color: AppColors.text),
        ),
      ),
    );
  }
}