import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/parcelle_list_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import 'parcelle_detail_screen.dart';

class ParcellesScreen extends StatefulWidget {
  const ParcellesScreen({super.key});

  @override
  State<ParcellesScreen> createState() => _ParcellesScreenState();
}

class _ParcellesScreenState extends State<ParcellesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParcelleListProvider>().fetchParcelles();
    });
  }

  void _openAddSheet(BuildContext context) {
    final nomCtrl = TextEditingController();
    final superficieCtrl = TextEditingController();
    final cultureCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Ajouter une parcelle', style: AppTextStyles.title(size: 18)),
                const SizedBox(height: 16),
                AppTextField(label: 'Nom de la parcelle', controller: nomCtrl, hint: 'Ex: Parcelle Odza'),
                AppTextField(label: 'Superficie (ha)', controller: superficieCtrl, keyboardType: TextInputType.number, hint: 'Ex: 25'),
                AppTextField(label: 'Culture', controller: cultureCtrl, hint: 'Ex: Tomates'),
                PrimaryButton(
                  label: 'Ajouter',
                  onPressed: () async {
                    if (nomCtrl.text.trim().isEmpty) return;
                    final success = await context.read<ParcelleListProvider>().creerParcelle(
                          nom: nomCtrl.text.trim(),
                          superficie: double.tryParse(superficieCtrl.text.trim()),
                          culture: cultureCtrl.text.trim(),
                        );
                    if (success && sheetContext.mounted) Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, int id, String nom) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer la parcelle'),
        content: Text('Voulez-vous vraiment supprimer "$nom" ? Cette action est définitive.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer', style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<ParcelleListProvider>().supprimerParcelle(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParcelleListProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(title: 'Mes parcelles', showBack: true),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.green,
        onPressed: () => _openAddSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ParcelleListProvider>().fetchParcelles(),
        child: Builder(builder: (context) {
          if (provider.isLoading && provider.parcelles.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.green));
          }
          if (provider.errorMessage != null && provider.parcelles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(provider.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 13), textAlign: TextAlign.center),
                    const SizedBox(height: 14),
                    PrimaryButton(label: 'Réessayer', onPressed: () => context.read<ParcelleListProvider>().fetchParcelles()),
                  ],
                ),
              ),
            );
          }
          if (provider.parcelles.isEmpty) {
            return const Center(child: Text('Aucune parcelle pour le moment', style: AppTextStyles.bodyMuted));
          }

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
            itemCount: provider.parcelles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final p = provider.parcelles[index];
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ParcelleDetailScreen(parcelleId: p.id, parcelleNom: p.nom))),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(p.nom, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.greenDark))),
                          TextButton(
                            onPressed: () => _confirmDelete(context, p.id, p.nom),
                            style: TextButton.styleFrom(backgroundColor: AppColors.dangerSoft, foregroundColor: AppColors.danger, minimumSize: const Size(0, 32)),
                            child: const Text('Supprimer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Superficie: ${p.superficie != null ? '${p.superficie!.toStringAsFixed(2)} ha' : 'Non spécifiée'}\n'
                        'Culture: ${p.culture.isNotEmpty ? p.culture : 'Non spécifiée'}\n'
                        '${p.localisation}',
                        style: AppTextStyles.bodyMuted,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
