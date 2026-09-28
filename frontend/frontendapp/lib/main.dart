import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_globals.dart';
import 'providers/parcelle_list_provider.dart';
import 'providers/parcelle_detail_provider.dart';
import 'providers/prevision_provider.dart';
import 'providers/historique_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/admin_parcelle_provider.dart';
import 'providers/settings_provider.dart';
import 'services/notification_service.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

final SettingsProvider settingsProvider = SettingsProvider();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await settingsProvider.load();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => ParcelleListProvider()),
        ChangeNotifierProvider(create: (_) => ParcelleDetailProvider()),
        ChangeNotifierProvider(create: (_) => PrevisionProvider()),
        ChangeNotifierProvider(create: (_) => HistoriqueProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => AdminParcelleProvider()),
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