import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'register_screen.dart';
import 'farmer/farmer_shell.dart';
import 'admin/admin_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.login(email: _email.text.trim(), password: _password.text);
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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset('assets/images/logo.jpeg', fit: BoxFit.contain),
                ),
                Text('Connexion', style: AppTextStyles.title(size: 24)),
                const SizedBox(height: 4),
                const Text(
                  'Connectez-vous pour surveiller vos parcelles',
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'Adresse email',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'vous@domaine.com',
                ),
                AppTextField(
                  label: 'Mot de passe',
                  controller: _password,
                  obscure: true,
                  hint: 'Votre mot de passe',
                ),
                if (auth.errorMessage != null) ...[
                  const SizedBox(height: 4),
                  Text(auth.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 12.5)),
                  const SizedBox(height: 6),
                ],
                const SizedBox(height: 8),
                PrimaryButton(label: 'Se connecter', onPressed: _submit, loading: auth.isLoading),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      context.read<AuthProvider>().clearError();
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: AppTextStyles.bodyMuted,
                        children: [
                          TextSpan(text: "Vous n'avez pas de compte ? "),
                          TextSpan(text: 'Créer un compte', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
