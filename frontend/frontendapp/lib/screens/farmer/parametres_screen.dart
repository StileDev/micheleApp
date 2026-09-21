import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';

/// Rien n'a été précisé sur le contenu réel de "Paramètres" (notifications,
/// langue, unités...). En attendant, cet écran affiche des options
/// statiques pour respecter la structure visuelle de la maquette — aucune
/// d'entre elles n'est encore connectée à une action ou un endpoint.
class ParametresScreen extends StatelessWidget {
  const ParametresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(title: 'Paramètres', showBack: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          _SettingRow(icon: Icons.notifications_outlined, label: 'Notifications'),
          _SettingRow(icon: Icons.language_outlined, label: 'Langue'),
          _SettingRow(icon: Icons.straighten_outlined, label: 'Unités de mesure'),
          _SettingRow(icon: Icons.info_outline, label: 'À propos d\'IrrigaSmart'),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SettingRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ce réglage sera disponible prochainement.')),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(12)),
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
