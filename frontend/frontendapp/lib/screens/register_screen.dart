import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/primary_button.dart';
import 'farmer/home_menu_screen.dart';
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
      final next = auth.isAdmin ? const AdminShell() : const HomeMenuScreen();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => next), (route) => false);
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/auth_bg.jpg', fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromRGBO(10, 25, 14, 0.15), Color.fromRGBO(10, 25, 14, 0.35), Color.fromRGBO(6, 18, 10, 0.85)],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        context.read<AuthProvider>().clearError();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Créer un compte IrrigaSmart', style: AppTextStyles.title(size: 21, color: Colors.white)),
                          const SizedBox(height: 4),
                          const Text('Rejoignez IrrigaSmart et gérez vos cultures', style: TextStyle(fontSize: 12.5, color: Colors.white70)),
                          const SizedBox(height: 20),
                          GlassTextField(label: 'Nom complet', controller: _name),
                          GlassTextField(label: 'Email', controller: _email, keyboardType: TextInputType.emailAddress),
                          GlassTextField(label: 'Numéro de téléphone', controller: _phone, keyboardType: TextInputType.phone),
                          GlassTextField(label: 'Mot de passe', controller: _password, obscure: true),
                          if (auth.errorMessage != null) ...[
                            const SizedBox(height: 4),
                            Text(auth.errorMessage!, style: const TextStyle(color: Colors.orangeAccent, fontSize: 12.5)),
                          ],
                          const SizedBox(height: 8),
                          PrimaryButton(label: "S'inscrire", onPressed: _submit, loading: auth.isLoading),
                          const SizedBox(height: 14),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                context.read<AuthProvider>().clearError();
                                Navigator.pop(context);
                              },
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontSize: 13, color: Colors.white70),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
