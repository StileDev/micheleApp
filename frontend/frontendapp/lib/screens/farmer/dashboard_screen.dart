import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/status_row.dart';
import '../../widgets/primary_button.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onGoToPrevision;

  const DashboardScreen({super.key, this.onGoToPrevision});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboard();
    });
  }

  String _fmtTime(DateTime? dt) {
    if (dt == null) return 'Aucune mesure reçue pour le moment';
    final local = dt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return 'Dernière mesure reçue à $h:$m';
  }

  String _soilStatusLabel(double? value) {
    if (value == null) return 'Aucune donnée disponible';
    if (value < 30) return 'Sol sec, arrosage recommandé';
    if (value < 50) return 'Niveau modéré, à surveiller';
    return 'Niveau optimal pour la culture';
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    final data = dashboard.data;

    return RefreshIndicator(
      onRefresh: () => context.read<DashboardProvider>().fetchDashboard(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              data != null ? data.parcelleNom : 'Chargement de la parcelle',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 16),

            if (dashboard.isLoading && data == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator(color: AppColors.green)),
              )
            else if (dashboard.errorMessage != null && data == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Text(dashboard.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 13), textAlign: TextAlign.center),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      label: 'Réessayer',
                      onPressed: () => context.read<DashboardProvider>().fetchDashboard(),
                    ),
                  ],
                ),
              )
            else ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Humidité du sol', style: TextStyle(fontSize: 12, color: Colors.white70)),
                    Text(
                      data?.humiditeSol != null ? '${data!.humiditeSol!.toStringAsFixed(1)}%' : '--',
                      style: AppTextStyles.title(size: 34, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(_soilStatusLabel(data?.humiditeSol), style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.thermostat,
                      color: AppColors.danger,
                      value: data?.temperature != null ? '${data!.temperature!.toStringAsFixed(1)}°C' : '--',
                      label: 'Température',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.water_drop_outlined,
                      color: AppColors.blue,
                      value: data?.humiditeAir != null ? '${data!.humiditeAir!.toStringAsFixed(1)}%' : '--',
                      label: "Humidité de l'air",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              StatusRow(
                icon: Icons.opacity,
                label: "État de l'irrigation",
                badgeText: (data?.etatIrrigation.actif ?? false) ? 'Active' : 'Arrêtée',
                badgeColor: (data?.etatIrrigation.actif ?? false) ? AppColors.greenDark : AppColors.muted,
                badgeBg: (data?.etatIrrigation.actif ?? false) ? AppColors.greenSoft : AppColors.surfaceAlt,
              ),
              const SizedBox(height: 8),
              StatusRow(
                icon: Icons.schedule,
                label: 'Prévision des besoins en eau',
                badgeText: 'Voir',
                badgeColor: AppColors.blueDark,
                badgeBg: AppColors.blueSoft,
                onTap: widget.onGoToPrevision,
              ),

              const SizedBox(height: 14),
              Center(
                child: Text(_fmtTime(data?.derniereMesure), style: AppTextStyles.caption),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
