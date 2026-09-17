import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String badgeText;
  final Color badgeColor;
  final Color badgeBg;
  final VoidCallback? onTap;

  const StatusRow({
    super.key,
    required this.icon,
    required this.label,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeBg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(color: AppColors.greenSoft, borderRadius: BorderRadius.circular(9)),
                  child: Icon(icon, size: 16, color: AppColors.greenDark),
                ),
                const SizedBox(width: 10),
                Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.text)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
              child: Text(badgeText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: badgeColor)),
            ),
          ],
        ),
      ),
    );
  }
}
