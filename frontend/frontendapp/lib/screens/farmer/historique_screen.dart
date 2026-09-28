import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/parcelle_list_provider.dart';
import '../../providers/historique_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/parcelle_model.dart';
import '../../l10n/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/primary_button.dart';

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  ParcelleModel? _selected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final listProvider = context.read<ParcelleListProvider>();
      await listProvider.fetchParcelles();
      if (listProvider.parcelles.isNotEmpty && mounted) {
        setState(() => _selected = listProvider.parcelles.first);
        context.read<HistoriqueProvider>().fetchHistorique(_selected!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final parcelles = context.watch<ParcelleListProvider>().parcelles;
    final historique = context.watch<HistoriqueProvider>();
    final settings = context.watch<SettingsProvider>();
    final s = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: s.historyTitle, showBack: true),
      body: Column(
        children: [
          if (parcelles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
              child: DropdownButtonFormField<ParcelleModel>(
                initialValue: _selected,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceAlt,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
                ),
                items: parcelles.map((p) => DropdownMenuItem(value: p, child: Text(p.nom))).toList(),
                onChanged: (p) {
                  if (p == null) return;
                  setState(() => _selected = p);
                  context.read<HistoriqueProvider>().fetchHistorique(p.id);
                },
              ),
            ),
          Expanded(
            child: Builder(builder: (context) {
              if (historique.isLoading && historique.actions.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.green));
              }
              if (historique.errorMessage != null && historique.actions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(historique.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 13), textAlign: TextAlign.center),
                        const SizedBox(height: 14),
                        if (_selected != null)
                          PrimaryButton(
                            label: s.retry,
                            onPressed: () => context.read<HistoriqueProvider>().fetchHistorique(_selected!.id),
                          ),
                      ],
                    ),
                  ),
                );
              }
              if (historique.actions.isEmpty && historique.mesures.isEmpty) {
                return Center(child: Text(s.historyEmpty, style: AppTextStyles.bodyMuted));
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                children: [
                  Text(s.historyActionsTitle, style: AppTextStyles.heading),
                  const SizedBox(height: 10),
                  if (historique.actions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Text(s.historyNoActions, style: AppTextStyles.bodyMuted),
                    )
                  else
                    ...historique.actions.map((a) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.line),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(color: AppColors.greenSoft, borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.water_drop_outlined, size: 17, color: AppColors.greenDark),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.isDemarrage ? s.irrigationStarted : s.irrigationStopped,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(_fmtDateTime(a.createdAt), style: AppTextStyles.caption),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: a.declencheeAutomatiquement ? AppColors.blueSoft : AppColors.surfaceAlt,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                a.declencheeAutomatiquement ? s.automaticTag : s.manualTag,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: a.declencheeAutomatiquement ? AppColors.blueDark : AppColors.muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                  const SizedBox(height: 10),
                  Text(s.historyMesuresTitle, style: AppTextStyles.heading),
                  const SizedBox(height: 10),
                  if (historique.mesures.isEmpty)
                    Text(s.historyNoMesures, style: AppTextStyles.bodyMuted)
                  else
                    ...historique.mesures.map((m) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            border: Border.all(color: AppColors.line),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(_fmtDateTime(m.createdAt), style: AppTextStyles.caption)),
                              Text(
                                '${s.soilLabel} ${m.humiditeSol.toStringAsFixed(0)}%',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.greenDark),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${s.airLabel} ${m.humiditeAir.toStringAsFixed(0)}%',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.blueDark),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${settings.convertTemp(m.temperature).toStringAsFixed(0)}${settings.tempSuffix}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.danger),
                              ),
                            ],
                          ),
                        )),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  String _fmtDateTime(DateTime dt) {
    final local = dt.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$d/$m à $h:$min';
  }
}