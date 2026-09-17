import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_globals.dart';
import 'providers/dashboard_provider.dart';
import 'providers/prevision_provider.dart';
import 'providers/irrigation_provider.dart';
import 'providers/admin_provider.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => PrevisionProvider()),
        ChangeNotifierProvider(create: (_) => IrrigationProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'IrrigaSmart',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.green,
            primary: AppColors.green,
            secondary: AppColors.blue,
            surface: AppColors.surface,
          ),
          fontFamily: 'Roboto',
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (_) => const LoginScreen(),
        },
      ),
    );
  }
}
