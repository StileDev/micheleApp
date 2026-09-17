import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'farmer/farmer_shell.dart';
import 'admin/admin_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      fullName: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      password: _password.text,
    );
    if (success && mounted) {
      final next = auth.isAdmin ? const AdminShell() : const FarmerShell();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => next),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.text,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<AuthProvider>().clearError();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Créer un compte', style: AppTextStyles.title(size: 24)),
              const SizedBox(height: 4),
              const Text(
                'Rejoignez IrrigaSmart et gérez vos cultures',
                style: AppTextStyles.bodyMuted,
              ),
              const SizedBox(height: 24),
              AppTextField(label: 'Nom complet', controller: _name, hint: 'Votre nom et prénom'),
              AppTextField(
                label: 'Email',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                hint: 'vous@domaine.com',
              ),
              AppTextField(
                label: 'Numéro de téléphone',
                controller: _phone,
                keyboardType: TextInputType.phone,
                hint: '+237 6 XX XX XX XX',
              ),
              AppTextField(
                label: 'Mot de passe',
                controller: _password,
                obscure: true,
                hint: 'Choisissez un mot de passe',
              ),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 4),
                Text(auth.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 12.5)),
                const SizedBox(height: 6),
              ],
              const SizedBox(height: 8),
              PrimaryButton(label: "S'inscrire", onPressed: _submit, loading: auth.isLoading),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () {
                    context.read<AuthProvider>().clearError();
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: AppTextStyles.bodyMuted,
                      children: [
                        TextSpan(text: 'Vous avez déjà un compte ? '),
                        TextSpan(text: 'Se connecter', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
