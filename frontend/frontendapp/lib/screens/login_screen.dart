import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/primary_button.dart';
import 'register_screen.dart';
import 'farmer/home_menu_screen.dart';
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
      final next = auth.isAdmin ? const AdminShell() : const HomeMenuScreen();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => next), (route) => false);
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
    final s = S.of(context);

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
                colors: [
                  Color.fromRGBO(10, 25, 14, 0.15),
                  Color.fromRGBO(10, 25, 14, 0.35),
                  Color.fromRGBO(6, 18, 10, 0.85),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(padding: EdgeInsets.all(16), child: _LanguagePill()),
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
                          Text(s.loginTitle, style: AppTextStyles.title(size: 22, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(s.loginSubtitle, style: const TextStyle(fontSize: 12.5, color: Colors.white70)),
                          const SizedBox(height: 20),
                          GlassTextField(label: s.email, controller: _email, keyboardType: TextInputType.emailAddress),
                          GlassTextField(label: s.password, controller: _password, obscure: true),
                          if (auth.errorMessage != null) ...[
                            const SizedBox(height: 4),
                            Text(auth.errorMessage!, style: const TextStyle(color: Colors.orangeAccent, fontSize: 12.5)),
                          ],
                          const SizedBox(height: 8),
                          PrimaryButton(label: s.signIn, onPressed: _submit, loading: auth.isLoading),
                          const SizedBox(height: 14),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                context.read<AuthProvider>().clearError();
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                                  children: [
                                    TextSpan(text: s.noAccount),
                                    TextSpan(
                                      text: s.createAccount,
                                      style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w700),
                                    ),
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

/// Pastille de langue : affiche la langue courante, bascule FR/EN au clic.
class _LanguagePill extends StatelessWidget {
  const _LanguagePill();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return GestureDetector(
      onTap: () => context.read<SettingsProvider>().setLanguage(
            settings.language == langFr ? langEn : langFr,
          ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(20)),
        child: Text(
          settings.language.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}