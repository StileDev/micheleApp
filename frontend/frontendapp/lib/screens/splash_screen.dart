import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'login_screen.dart';
import 'farmer/farmer_shell.dart';
import 'admin/admin_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textOpacity;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack)),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.45, 0.85, curve: Curves.easeOut)),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.45, 0.85, curve: Curves.easeOut)),
    );

    _controller.forward();

    final auth = context.read<AuthProvider>();
    Future.wait([
      Future.delayed(const Duration(milliseconds: 2200)),
      auth.checkSession(),
    ]).then((_) => _goNext());
  }

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;

    final auth = context.read<AuthProvider>();
    Widget next;
    if (auth.status == AuthStatus.authenticated) {
      next = auth.isAdmin ? const AdminShell() : const FarmerShell();
    } else {
      next = const LoginScreen();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, animation, __) => FadeTransition(opacity: animation, child: next),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.line),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Image.asset('assets/images/logo.jpeg', fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: Column(
                      children: [
                        Text('IrrigaSmart', style: AppTextStyles.title(size: 24, color: AppColors.greenDark)),
                        const SizedBox(height: 4),
                        const Text(
                          'Irrigation intelligente et prévision des besoins en eau',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.5, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
