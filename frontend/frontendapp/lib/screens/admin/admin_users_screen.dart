import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/manage_user_model.dart';
import '../../l10n/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/role_badge.dart';

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

  void _openCreateSheet() {
    final s = S.read(context);
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    String role = 'agriculteur';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          final admin = ctx.watch<AdminProvider>();

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(s.adminAddUser, style: AppTextStyles.title(size: 18)),
                    const SizedBox(height: 16),
                    AppTextField(label: s.fullName, controller: nameCtrl),
                    AppTextField(label: s.email, controller: emailCtrl, keyboardType: TextInputType.emailAddress),
                    AppTextField(label: s.phone, controller: phoneCtrl, keyboardType: TextInputType.phone),
                    AppTextField(label: s.password, controller: passwordCtrl, obscure: true),
                    Text(s.roleLabel, style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _RoleChoice(
                            label: s.roleFarmer,
                            selected: role == 'agriculteur',
                            onTap: () => setSheetState(() => role = 'agriculteur'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _RoleChoice(
                            label: s.roleAdmin,
                            selected: role == 'administrateur',
                            onTap: () => setSheetState(() => role = 'administrateur'),
                          ),
                        ),
                      ],
                    ),
                    if (admin.errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(admin.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 12.5)),
                    ],
                    const SizedBox(height: 18),
                    PrimaryButton(
                      label: s.create,
                      color: AppColors.blue,
                      loading: admin.isActing,
                      onPressed: () async {
                        if (nameCtrl.text.trim().isEmpty || emailCtrl.text.trim().isEmpty || passwordCtrl.text.isEmpty) return;
                        final success = await context.read<AdminProvider>().createUser(
                              fullName: nameCtrl.text.trim(),
                              email: emailCtrl.text.trim(),
                              phone: phoneCtrl.text.trim(),
                              password: passwordCtrl.text,
                              role: role,
                            );
                        if (success && ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _openEditSheet(ManageUserModel user) {
    final s = S.read(context);
    final nameCtrl = TextEditingController(text: user.fullName);
    final phoneCtrl = TextEditingController(text: user.phone);
    String role = user.role;
    bool isActive = user.isActive;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          final admin = ctx.watch<AdminProvider>();

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(s.adminEditUser, style: AppTextStyles.title(size: 18)),
                    const SizedBox(height: 4),
                    Text(user.email, style: AppTextStyles.bodyMuted),
                    const SizedBox(height: 16),
                    AppTextField(label: s.fullName, controller: nameCtrl),
                    AppTextField(label: s.phone, controller: phoneCtrl, keyboardType: TextInputType.phone),
                    Text(s.roleLabel, style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _RoleChoice(
                            label: s.roleFarmer,
                            selected: role == 'agriculteur',
                            onTap: () => setSheetState(() => role = 'agriculteur'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _RoleChoice(
                            label: s.roleAdmin,
                            selected: role == 'administrateur',
                            onTap: () => setSheetState(() => role = 'administrateur'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.adminAccountActive, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        Switch(
                          value: isActive,
                          activeColor: AppColors.green,
                          onChanged: (v) => setSheetState(() => isActive = v),
                        ),
                      ],
                    ),
                    if (admin.errorMessage != null) ...[
                      const SizedBox(height: 6),
                      Text(admin.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 12.5)),
                    ],
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: s.save,
                      color: AppColors.blue,
                      loading: admin.isActing,
                      onPressed: () async {
                        final success = await context.read<AdminProvider>().updateUser(
                              id: user.id,
                              fullName: nameCtrl.text.trim(),
                              phone: phoneCtrl.text.trim(),
                              role: role,
                              isActive: isActive,
                            );
                        if (success && ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          side: const BorderSide(color: AppColors.dangerSoft),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await _confirmDelete(user.id, user.fullName);
                        },
                        child: Text(s.adminDeleteAccount, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _confirmDelete(int id, String name) async {
    final s = S.read(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.adminConfirmDeleteUserTitle),
        content: Text(s.adminConfirmDeleteUserBody(name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(s.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(s.delete, style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<AdminProvider>().deleteUser(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminProvider>();
    final s = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: s.adminUsersTitle, showBack: true),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue,
        onPressed: _openCreateSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
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
                  hintText: s.adminSearchUser,
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
                          PrimaryButton(
                            label: s.retry,
                            color: AppColors.blue,
                            onPressed: () => context.read<AdminProvider>().fetchUsers(),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (provider.users.isEmpty) {
                  return Center(child: Text(s.adminNoUsers, style: AppTextStyles.bodyMuted));
                }

                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 90),
                  itemCount: provider.users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final user = provider.users[index];
                    final initials = user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?';

                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _openEditSheet(user),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.line),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.blueSoft,
                              child: Text(initials, style: const TextStyle(color: AppColors.blueDark, fontWeight: FontWeight.w700, fontSize: 13)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.fullName, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(user.email, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
                                  if (!user.isActive) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      s.adminAccountDisabled,
                                      style: const TextStyle(fontSize: 10.5, color: AppColors.danger, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            RoleBadge(role: user.role),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right, size: 18, color: AppColors.muted),
                          ],
                        ),
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

class _RoleChoice extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RoleChoice({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.blue : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppColors.blue : AppColors.line),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.text),
        ),
      ),
    );
  }
}