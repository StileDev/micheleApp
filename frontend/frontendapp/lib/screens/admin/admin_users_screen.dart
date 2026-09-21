import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/role_badge.dart';
import '../../widgets/primary_button.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchUsers();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _confirmDeactivate(BuildContext context, int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Désactiver ce compte'),
        content: Text('Voulez-vous vraiment désactiver le compte de $name ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Désactiver', style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AdminProvider>().deactivateUser(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminProvider>();

    return RefreshIndicator(
      onRefresh: () => context.read<AdminProvider>().fetchUsers(query: _search.text),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: TextField(
              controller: _search,
              onSubmitted: (v) => context.read<AdminProvider>().fetchUsers(query: v),
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Rechercher un utilisateur',
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
              if (provider.isLoading && provider.users.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.blue));
              }
              if (provider.errorMessage != null && provider.users.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(provider.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 13), textAlign: TextAlign.center),
                        const SizedBox(height: 14),
                        PrimaryButton(label: 'Réessayer', color: AppColors.blue, onPressed: () => context.read<AdminProvider>().fetchUsers()),
                      ],
                    ),
                  ),
                );
              }
              if (provider.users.isEmpty) {
                return const Center(child: Text('Aucun utilisateur trouvé', style: AppTextStyles.bodyMuted));
              }

              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                itemCount: provider.users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final user = provider.users[index];
                  final initials = user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?';

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 18, backgroundColor: AppColors.blueSoft, child: Text(initials, style: const TextStyle(color: AppColors.blueDark, fontWeight: FontWeight.w700, fontSize: 13))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.fullName, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(user.email, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        RoleBadge(role: user.role),
                        IconButton(icon: const Icon(Icons.more_vert, size: 18, color: AppColors.muted), onPressed: () => _confirmDeactivate(context, user.id, user.fullName)),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
