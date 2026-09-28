import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/profile_sheet.dart';
import 'parcelles_screen.dart';
import 'parametres_screen.dart';
import 'historique_screen.dart';

class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.greenSoft,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(s.homeWelcome1, style: AppTextStyles.title(size: 22, color: AppColors.greenDark), textAlign: TextAlign.center),
                  Text('IrrigaSmart', style: AppTextStyles.title(size: 22, color: AppColors.greenDark), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    s.homeSubtitleItalic,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: AppColors.greenDark, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 6),
                  Text(s.homeSubtitle, textAlign: TextAlign.center, style: AppTextStyles.bodyMuted),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: _MenuTile(
                          icon: Icons.grass_outlined,
                          label: s.tileParcelles,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParcellesScreen())),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MenuTile(
                          icon: Icons.settings_outlined,
                          label: s.tileParametres,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParametresScreen())),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _MenuTile(
                          icon: Icons.person_outline,
                          label: s.tileProfil,
                          onTap: () => showProfileSheet(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MenuTile(
                          icon: Icons.history,
                          label: s.tileHistorique,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoriqueScreen())),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        Text(s.quickActionsTitle, style: AppTextStyles.title(size: 15, color: AppColors.greenDark)),
                        const SizedBox(height: 8),
                        Text(s.quickActionsBody, textAlign: TextAlign.center, style: AppTextStyles.bodyMuted),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: FloatingActionButton(
                backgroundColor: AppColors.green,
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.chatComingSoon))),
                child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 26),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Icon(icon, size: 26, color: AppColors.green),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.greenDark)),
          ],
        ),
      ),
    );
  }
}