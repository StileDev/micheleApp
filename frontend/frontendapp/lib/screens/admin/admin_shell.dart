import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/profile_sheet.dart';
import 'admin_users_screen.dart';
import 'admin_parcelles_screen.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<AuthProvider>();
    final s = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: s.adminTitle,
        trailing: GestureDetector(
          onTap: () => showProfileSheet(context),
          child: const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.blueSoft,
            child: Icon(Icons.person, size: 17, color: AppColors.blueDark),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(s.adminChooseWhat, style: AppTextStyles.bodyMuted),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _AdminTile(
                    icon: Icons.grass_outlined,
                    label: s.adminParcellesTitle,
                    color: AppColors.green,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminParcellesScreen())),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AdminTile(
                    icon: Icons.people_outline,
                    label: s.adminUsersTitle,
                    color: AppColors.blue,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminUsersScreen())),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AdminTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.text)),
          ],
        ),
      ),
    );
  }
}