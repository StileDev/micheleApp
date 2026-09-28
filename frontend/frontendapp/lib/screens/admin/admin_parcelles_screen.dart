import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_parcelle_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/primary_button.dart';

class AdminParcellesScreen extends StatefulWidget {
  const AdminParcellesScreen({super.key});

  @override
  State<AdminParcellesScreen> createState() => _AdminParcellesScreenState();
}

class _AdminParcellesScreenState extends State<AdminParcellesScreen> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminParcelleProvider>().fetchParcelles();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(int id, String nom) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer la parcelle'),
        content: Text('Voulez-vous vraiment supprimer "$nom" ? Cette action est définitive et supprimera aussi ses mesures et son historique.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer', style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<AdminParcelleProvider>().deleteParcelle(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminParcelleProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(title: 'Parcelles', showBack: true),
      body: RefreshIndicator(
        onRefresh: () => context.read<AdminParcelleProvider>().fetchParcelles(query: _search.text),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
              child: TextField(
                controller: _search,
                onSubmitted: (v) => context.read<AdminParcelleProvider>().fetchParcelles(query: v),
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Rechercher une parcelle ou un propriétaire',
                  hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.muted),
                  filled: true,
                  fillColor: AppColors.surfaceAlt,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.blue, width: 1.4)),
                ),
              ),
            ),
            Expanded(
              child: Builder(builder: (context) {
                if (provider.isLoading && provider.parcelles.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.blue));
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
                          PrimaryButton(label: 'Réessayer', color: AppColors.blue, onPressed: () => context.read<AdminParcelleProvider>().fetchParcelles()),
                        ],
                      ),
                    ),
                  );
                }
                if (provider.parcelles.isEmpty) {
                  return const Center(child: Text('Aucune parcelle enregistrée', style: AppTextStyles.bodyMuted));
                }

                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  itemCount: provider.parcelles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final p = provider.parcelles[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Parcelle N°${p.id}', style: AppTextStyles.caption),
                                    Text(p.nom, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.greenDark)),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => _confirmDelete(p.id, p.nom),
                                style: TextButton.styleFrom(backgroundColor: AppColors.dangerSoft, foregroundColor: AppColors.danger, minimumSize: const Size(0, 32)),
                                child: const Text('Supprimer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const Divider(height: 18, color: AppColors.line),
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 15, color: AppColors.muted),
                              const SizedBox(width: 6),
                              Expanded(child: Text('${p.proprietaireNom} — ${p.proprietaireEmail}', style: AppTextStyles.bodyMuted, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Superficie: ${p.superficie != null ? '${p.superficie!.toStringAsFixed(2)} ha' : 'Non spécifiée'} · Culture: ${p.culture.isNotEmpty ? p.culture : 'Non spécifiée'}',
                            style: AppTextStyles.bodyMuted,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
