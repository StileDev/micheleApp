import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/parcelle_detail_provider.dart';
import '../../providers/settings_provider.dart';
import '../../l10n/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/primary_button.dart';
import '../../utils/materiel_icons.dart';
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

  // Gardé dans un champ : on ne peut pas utiliser context dans dispose().
  late final ParcelleDetailProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = context.read<ParcelleDetailProvider>();
    _provider.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final s = S.read(context);
      _provider.notificationsEnabled = context.read<SettingsProvider>().notificationsEnabled;
      _provider.notificationTitle = s.notifAutoTitle;
      _provider.notificationBody = s.notifAutoBody(widget.parcelleNom);

      await _provider.fetchDetail(widget.parcelleId);
      if (mounted) _provider.connectRealtime(widget.parcelleId);
    });
  }

  @override
  void dispose() {
    _materielCtrl.dispose();
    _provider.disconnectRealtime();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParcelleDetailProvider>();
    final settings = context.watch<SettingsProvider>();
    final s = S.of(context);
    final data = provider.data;
    final isAuto = (data?.etat.irrigationMode ?? 'manuel') == 'auto';
    final irrigationActive = data?.etat.irrigationActive ?? false;

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
                        PrimaryButton(label: s.retry, onPressed: () => _provider.fetchDetail(widget.parcelleId)),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => _provider.fetchDetail(widget.parcelleId),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(s.parcelleNumber(widget.parcelleId), style: AppTextStyles.caption),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(color: AppColors.greenSoft, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: (data?.etat.iotConnecte ?? false) ? AppColors.green : AppColors.muted,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                (data?.etat.iotConnecte ?? false) ? s.iotConnected : s.iotDisconnected,
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.greenDark),
                              ),
                              const Spacer(),
                              if (data?.derniereMesure != null)
                                Text(s.lastUpdate(_fmtTime(data!.derniereMesure!)), style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                icon: Icons.thermostat,
                                color: AppColors.danger,
                                value: data?.temperature != null
                                    ? '${settings.convertTemp(data!.temperature!).toStringAsFixed(1)}${settings.tempSuffix}'
                                    : '--',
                                label: s.temperature,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: StatCard(
                                icon: Icons.water_drop_outlined,
                                color: AppColors.blue,
                                value: data?.humiditeAir != null ? '${data!.humiditeAir!.toStringAsFixed(1)}%' : '--',
                                label: s.airHumidity,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: StatCard(
                                icon: Icons.grass,
                                color: AppColors.green,
                                value: data?.humiditeSol != null ? '${data!.humiditeSol!.toStringAsFixed(1)}%' : '--',
                                label: s.soilHumidity,
                              ),
                            ),
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
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PrevisionScreen(parcelleId: widget.parcelleId, parcelleNom: widget.parcelleNom),
                              ),
                            ),
                            icon: const Icon(Icons.query_stats, size: 18),
                            label: Text(s.seePrevision, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            border: Border.all(color: AppColors.line),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(color: AppColors.blueSoft, borderRadius: BorderRadius.circular(9)),
                                child: const Icon(Icons.vpn_key_outlined, size: 16, color: AppColors.blueDark),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(s.deviceKeyTitle, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text(
                                      data?.deviceKey ?? '',
                                      style: const TextStyle(fontSize: 11.5, color: AppColors.muted, fontFamily: 'monospace'),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18, color: AppColors.blueDark),
                                onPressed: data == null
                                    ? null
                                    : () {
                                        Clipboard.setData(ClipboardData(text: data.deviceKey));
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.deviceKeyCopied)));
                                      },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        Text(s.materielsTitle, style: AppTextStyles.heading),
                        const SizedBox(height: 10),
                        ...(data?.materiels ?? []).map((m) {
                          final visual = materielVisual(m.nom);
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
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(color: visual.background, borderRadius: BorderRadius.circular(9)),
                                  child: Icon(visual.icon, size: 16, color: visual.color),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Text(m.nom, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500))),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18, color: AppColors.muted),
                                  onPressed: () => _provider.supprimerMateriel(widget.parcelleId, m.id),
                                ),
                              ],
                            ),
                          );
                        }),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _materielCtrl,
                                style: AppTextStyles.body,
                                decoration: InputDecoration(
                                  hintText: s.materielHint,
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  if (_materielCtrl.text.trim().isEmpty) return;
                                  _provider.ajouterMateriel(widget.parcelleId, _materielCtrl.text.trim());
                                  _materielCtrl.clear();
                                },
                                child: Text(s.add),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),
                        Text(s.irrigationTitle, style: AppTextStyles.heading),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
                          child: Row(
                            children: [
                              Expanded(
                                child: _ModeTab(
                                  label: s.modeAuto,
                                  selected: isAuto,
                                  onTap: () => _provider.setIrrigationMode(widget.parcelleId, 'auto'),
                                ),
                              ),
                              Expanded(
                                child: _ModeTab(
                                  label: s.modeManuel,
                                  selected: !isAuto,
                                  onTap: () => _provider.setIrrigationMode(widget.parcelleId, 'manuel'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (isAuto)
                          // Mode auto : aucun bouton. Le serveur décide seul à
                          // chaque mesure reçue, l'agriculteur observe seulement.
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: irrigationActive ? AppColors.greenSoft : AppColors.surface,
                              border: Border.all(color: irrigationActive ? AppColors.green : AppColors.line),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      irrigationActive ? Icons.water_drop : Icons.water_drop_outlined,
                                      color: irrigationActive ? AppColors.greenDark : AppColors.muted,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        irrigationActive ? s.autoStatusOn : s.autoStatusOff,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: irrigationActive ? AppColors.greenDark : AppColors.text,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(s.autoModeExplain, style: AppTextStyles.caption),
                              ],
                            ),
                          )
                        else
                          PrimaryButton(
                            label: irrigationActive ? s.stopIrrigation : s.startIrrigation,
                            color: irrigationActive ? AppColors.danger : AppColors.green,
                            loading: provider.isActing,
                            onPressed: () => _provider.toggleIrrigationManuel(widget.parcelleId),
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
    return '$h:$m';
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.muted),
        ),
      ),
    );
  }
}