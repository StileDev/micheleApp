import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'administrateur';
    final color = isAdmin ? AppColors.blueDark : AppColors.greenDark;
    final bg = isAdmin ? AppColors.blueSoft : AppColors.greenSoft;
    final label = isAdmin ? 'Administrateur' : 'Agriculteur';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
