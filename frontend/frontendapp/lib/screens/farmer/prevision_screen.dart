import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/prevision_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/primary_button.dart';

class PrevisionScreen extends StatefulWidget {
  final int parcelleId;
  final String parcelleNom;

  const PrevisionScreen({super.key, required this.parcelleId, required this.parcelleNom});

  @override
  State<PrevisionScreen> createState() => _PrevisionScreenState();
}

class _PrevisionScreenState extends State<PrevisionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrevisionProvider>().fetchPrevision(widget.parcelleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PrevisionProvider>();
    final data = provider.data;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: 'Prévision — ${widget.parcelleNom}', showBack: true),
      body: RefreshIndicator(
        onRefresh: () => context.read<PrevisionProvider>().fetchPrevision(widget.parcelleId),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (provider.isLoading && data == null)
                const Padding(padding: EdgeInsets.symmetric(vertical: 60), child: Center(child: CircularProgressIndicator(color: AppColors.green)))
              else if (provider.errorMessage != null && data == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Text(provider.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 13), textAlign: TextAlign.center),
                      const SizedBox(height: 14),
                      PrimaryButton(label: 'Réessayer', onPressed: () => context.read<PrevisionProvider>().fetchPrevision(widget.parcelleId)),
                    ],
                  ),
                )
              else ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
                  decoration: BoxDecoration(color: (data?.besoinEau ?? false) ? AppColors.blue : AppColors.green, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Icon((data?.besoinEau ?? false) ? Icons.water_drop : Icons.check_circle_outline, color: Colors.white, size: 30),
                      const SizedBox(height: 10),
                      Text(
                        (data?.besoinEau ?? false) ? 'Arrosage recommandé' : 'Aucun arrosage nécessaire',
                        style: AppTextStyles.title(size: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data?.message ?? 'La prévision sera disponible dès la réception des premières mesures.',
                        style: const TextStyle(fontSize: 12.5, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (data != null && data.raisons.isNotEmpty) ...[
                  const Text('Pourquoi cette prévision', style: AppTextStyles.heading),
                  const SizedBox(height: 10),
                  ...data.raisons.map((r) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                        decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(color: AppColors.blueSoft, borderRadius: BorderRadius.circular(9)),
                              child: const Icon(Icons.info_outline, size: 15, color: AppColors.blueDark),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.titre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(r.detail, style: AppTextStyles.bodyMuted),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
                if (data != null && data.courbe.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  const Text('Évolution attendue', style: AppTextStyles.heading),
                  const SizedBox(height: 10),
                  Row(
                    children: data.courbe
                        .map((p) => Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Text(p.label, style: AppTextStyles.caption),
                                    const SizedBox(height: 4),
                                    Text('${p.valeur.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.greenDark)),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
