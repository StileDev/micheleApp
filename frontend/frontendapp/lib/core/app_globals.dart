import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';

/// Clé de navigation globale, utilisée pour rediriger vers l'écran de
/// connexion depuis des endroits qui n'ont pas de BuildContext (comme
/// l'intercepteur réseau, lorsqu'une session expire).
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Instance unique du provider d'authentification, partagée par toute
/// l'application.
final AuthProvider authProvider = AuthProvider();
