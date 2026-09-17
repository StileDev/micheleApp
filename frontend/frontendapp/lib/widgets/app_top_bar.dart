import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Barre supérieure commune à tous les écrans principaux. L'avatar à
/// droite ouvre la fiche profil (bottom sheet) au clic.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String initials;
  final VoidCallback onAvatarTap;

  const AppTopBar({
    super.key,
    required this.title,
    required this.initials,
    required this.onAvatarTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 16, 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.line, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.title(size: 19)),
            GestureDetector(
              onTap: onAvatarTap,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.greenSoft,
                child: Text(
                  initials,
                  style: const TextStyle(color: AppColors.greenDark, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
