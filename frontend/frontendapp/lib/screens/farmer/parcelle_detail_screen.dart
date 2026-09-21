import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/parcelle_detail_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/primary_button.dart';
import 'prevision_screen.dart';

class ParcelleDetailScreen extends StatefulWidget {
  final int parcelleId;
  final String parcelleNom;

  const ParcelleDetailScreen({super.key, required this.parcelleId, required this.parcelleNom});

  @override
  State<ParcelleDetailScreen> createState() => _ParcelleDetailScreenState();
}

class _ParcelleDetailScreenState extends State<ParcelleDetailScreen> {
  final _materielCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParcelleDetailProvider>().fetchDetail(widget.parcelleId);
    });
  }

  @override
  void dispose() {
    _materielCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParcelleDetailProvider>();
    final data = provider.data;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: widget.parcelleNom, showBack: true),
      body: provider.isLoading && data == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.green))
          : provider.errorMessage != null && data == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(provider.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 13), textAlign: TextAlign.center),
                        const SizedBox(height: 14),
                        PrimaryButton(label: 'Réessayer', onPressed: () => context.read<ParcelleDetailProvider>().fetchDetail(widget.parcelleId)),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => context.read<ParcelleDetailProvider>().fetchDetail(widget.parcelleId),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(color: AppColors.greenSoft, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(color: (data?.etat.iotConnecte ?? false) ? AppColors.green : AppColors.muted, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                (data?.etat.iotConnecte ?? false) ? 'IoT connecté' : 'IoT déconnecté',
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.greenDark),
                              ),
                              const Spacer(),
                              if (data?.derniereMesure != null)
                                Text(_fmtTime(data!.derniereMesure!), style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.5,
                          children: [
                            StatCard(icon: Icons.thermostat, color: AppColors.danger, value: data?.temperature != null ? '${data!.temperature!.toStringAsFixed(1)}°C' : '--', label: 'Température'),
                            StatCard(icon: Icons.water_drop_outlined, color: AppColors.blue, value: data?.humiditeAir != null ? '${data!.humiditeAir!.toStringAsFixed(1)}%' : '--', label: "Humidité de l'air"),
                            StatCard(icon: Icons.grass, color: AppColors.green, value: data?.humiditeSol != null ? '${data!.humiditeSol!.toStringAsFixed(1)}%' : '--', label: 'Humidité du sol'),
                            StatCard(icon: Icons.science_outlined, color: AppColors.warning, value: data?.phSol != null ? data!.phSol!.toStringAsFixed(1) : '--', label: 'pH du sol'),
                          ],
                        ),
                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.blueDark,
                              side: const BorderSide(color: AppColors.blueSoft),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PrevisionScreen(parcelleId: widget.parcelleId, parcelleNom: widget.parcelleNom))),
                            icon: const Icon(Icons.query_stats, size: 18),
                            label: const Text('Voir la prévision des besoins en eau', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Text('Matériels', style: AppTextStyles.heading),
                        const SizedBox(height: 10),
                        ...(data?.materiels ?? []).map((m) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30, height: 30,
                                    decoration: BoxDecoration(color: AppColors.blueSoft, borderRadius: BorderRadius.circular(9)),
                                    child: const Icon(Icons.sensors, size: 16, color: AppColors.blueDark),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(m.nom, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500))),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 18, color: AppColors.muted),
                                    onPressed: () => context.read<ParcelleDetailProvider>().supprimerMateriel(widget.parcelleId, m.id),
                                  ),
                                ],
                              ),
                            )),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _materielCtrl,
                                style: AppTextStyles.body,
                                decoration: InputDecoration(
                                  hintText: 'Ajouter un matériel (ex: Capteur pH)',
                                  hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
                                  filled: true,
                                  fillColor: AppColors.surfaceAlt,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.green)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                onPressed: () {
                                  if (_materielCtrl.text.trim().isEmpty) return;
                                  context.read<ParcelleDetailProvider>().ajouterMateriel(widget.parcelleId, _materielCtrl.text.trim());
                                  _materielCtrl.clear();
                                },
                                child: const Text('Ajouter'),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                label: (data?.etat.irrigationActive ?? false) ? "Arrêter l'irrigation" : "Démarrer l'irrigation",
                                color: (data?.etat.irrigationActive ?? false) ? AppColors.danger : AppColors.green,
                                loading: provider.isActing,
                                onPressed: () => context.read<ParcelleDetailProvider>().toggleIrrigation(widget.parcelleId),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                label: (data?.etat.drainageActif ?? false) ? 'Arrêter le drainage' : 'Démarrer le drainage',
                                color: (data?.etat.drainageActif ?? false) ? AppColors.danger : AppColors.blue,
                                loading: provider.isActing,
                                onPressed: () => context.read<ParcelleDetailProvider>().toggleDrainage(widget.parcelleId),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  String _fmtTime(DateTime dt) {
    final local = dt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return 'Dernière mise à jour: $h:$m';
  }
}
