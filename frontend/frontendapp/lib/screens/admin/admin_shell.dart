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
    final auth = context.watch<AuthProvider>();
    final initials = (auth.userName != null && auth.userName!.isNotEmpty)
        ? auth.userName![0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: 'Administration',
        initials: initials,
        onAvatarTap: () => showProfileSheet(context),
      ),
      body: const AdminUsersScreen(),
    );
  }
}
