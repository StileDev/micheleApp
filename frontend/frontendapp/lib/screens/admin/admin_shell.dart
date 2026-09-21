import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/profile_sheet.dart';
import 'admin_users_screen.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: 'Administration',
        trailing: GestureDetector(
          onTap: () => showProfileSheet(context),
          child: const CircleAvatar(radius: 16, backgroundColor: AppColors.blueSoft, child: Icon(Icons.person, size: 17, color: AppColors.blueDark)),
        ),
      ),
      body: const AdminUsersScreen(),
    );
  }
}
