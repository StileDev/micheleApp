import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_globals.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/role_badge.dart';

/// Ouvre la fiche profil sous forme de panneau remontant du bas.
Future<void> showProfileSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const ProfileSheet(),
  );
}

class ProfileSheet extends StatelessWidget {
  const ProfileSheet({super.key});

  Future<void> _logout(BuildContext context) async {
    Navigator.pop(context);
    await authProvider.logout();
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final initials = (auth.userName != null && auth.userName!.isNotEmpty)
        ? auth.userName![0].toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.greenSoft,
            child: Text(
              initials,
              style: AppTextStyles.title(size: 26, color: AppColors.greenDark),
            ),
          ),
          const SizedBox(height: 12),
          Text(auth.userName ?? '', style: AppTextStyles.heading),
          const SizedBox(height: 6),
          RoleBadge(role: auth.userRole ?? 'agriculteur'),
          const SizedBox(height: 20),
          _InfoLine(label: 'Email', value: auth.userEmail ?? ''),
          _InfoLine(label: 'Téléphone', value: auth.userPhone ?? ''),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.dangerSoft),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _logout(context),
              child: const Text('Se déconnecter', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMuted),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
