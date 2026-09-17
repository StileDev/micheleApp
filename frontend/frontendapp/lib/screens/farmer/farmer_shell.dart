import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/profile_sheet.dart';
import 'dashboard_screen.dart';
import 'prevision_screen.dart';
import 'irrigation_screen.dart';

class FarmerShell extends StatefulWidget {
  const FarmerShell({super.key});

  @override
  State<FarmerShell> createState() => _FarmerShellState();
}

class _FarmerShellState extends State<FarmerShell> {
  int _index = 0;

  static const _titles = ['Tableau de bord', 'Prévision', 'Irrigation'];

  late final List<Widget> _screens = [
    DashboardScreen(onGoToPrevision: () => setState(() => _index = 1)),
    const PrevisionScreen(),
    const IrrigationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final initials = (auth.userName != null && auth.userName!.isNotEmpty)
        ? auth.userName![0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: _titles[_index],
        initials: initials,
        onAvatarTap: () => showProfileSheet(context),
      ),
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.greenSoft,
        elevation: 0,
        height: 62,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: AppColors.muted),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.greenDark),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.query_stats_outlined, color: AppColors.muted),
            selectedIcon: Icon(Icons.query_stats, color: AppColors.greenDark),
            label: 'Prévision',
          ),
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined, color: AppColors.muted),
            selectedIcon: Icon(Icons.water_drop, color: AppColors.greenDark),
            label: 'Irrigation',
          ),
        ],
      ),
    );
  }
}
