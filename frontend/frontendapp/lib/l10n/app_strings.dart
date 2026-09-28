import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

/// Traductions français / anglais en Dart pur (pas de génération de code).
class S {
  final String lang;
  const S(this.lang);

  /// À utiliser dans build() : l'écran se reconstruit quand la langue change.
  static S of(BuildContext context) => S(context.watch<SettingsProvider>().language);

  /// À utiliser dans les callbacks (onPressed, initState...) où watch est interdit.
  static S read(BuildContext context) => S(context.read<SettingsProvider>().language);

  bool get _en => lang == langEn;
  String _t(String fr, String en) => _en ? en : fr;

  // --- Général ---
  String get retry => _t('Réessayer', 'Retry');
  String get cancel => _t('Annuler', 'Cancel');
  String get save => _t('Enregistrer', 'Save');
  String get delete => _t('Supprimer', 'Delete');
  String get add => _t('Ajouter', 'Add');
  String get edit => _t('Modifier', 'Edit');
  String get close => _t('Fermer', 'Close');

  // --- Splash ---
  String get splashTagline => _t(
      'Irrigation intelligente et prévision des besoins en eau',
      'Smart irrigation and water need forecasting');

  // --- Connexion / Inscription ---
  String get loginTitle => _t('Connexion à IrrigaSmart', 'Sign in to IrrigaSmart');
  String get loginSubtitle => _t('Connectez-vous pour surveiller vos parcelles', 'Sign in to monitor your plots');
  String get email => _t('Adresse email', 'Email address');
  String get password => _t('Mot de passe', 'Password');
  String get signIn => _t('Se connecter', 'Sign in');
  String get noAccount => _t("Vous n'avez pas de compte ? ", "Don't have an account? ");
  String get createAccount => _t('Créer un compte', 'Create an account');
  String get registerTitle => _t('Créer un compte IrrigaSmart', 'Create your IrrigaSmart account');
  String get registerSubtitle => _t('Rejoignez IrrigaSmart et gérez vos cultures', 'Join IrrigaSmart and manage your crops');
  String get fullName => _t('Nom complet', 'Full name');
  String get phone => _t('Numéro de téléphone', 'Phone number');
  String get signUp => _t("S'inscrire", 'Sign up');
  String get alreadyAccount => _t('Vous avez déjà un compte ? ', 'Already have an account? ');

  // --- Accueil ---
  String get homeWelcome1 => _t('Bienvenue sur', 'Welcome to');
  String get homeSubtitleItalic => _t('Bienvenue sur votre plateforme de gestion agricole', 'Welcome to your farm management platform');
  String get homeSubtitle => _t('Gérez vos parcelles, vos capteurs et vos actions', 'Manage your plots, sensors and actions');
  String get tileParcelles => _t('Parcelles', 'Plots');
  String get tileParametres => _t('Paramètres', 'Settings');
  String get tileProfil => _t('Profil', 'Profile');
  String get tileHistorique => _t('Historique', 'History');
  String get quickActionsTitle => _t('Actions rapides', 'Quick actions');
  String get quickActionsBody => _t(
      "Surveillez vos parcelles, vérifiez l'état d'irrigation et gérez vos opérations agricoles efficacement.",
      'Monitor your plots, check irrigation status and manage your farm operations efficiently.');
  String get chatComingSoon => _t('Le chat sera disponible prochainement.', 'Chat will be available soon.');

  // --- Parcelles ---
  String get myParcelles => _t('Mes parcelles', 'My plots');
  String get noParcelles => _t('Aucune parcelle pour le moment', 'No plots yet');
  String get addParcelle => _t('Ajouter une parcelle', 'Add a plot');
  String get parcelleName => _t('Nom de la parcelle', 'Plot name');
  String get parcelleSurface => _t('Superficie (ha)', 'Surface (ha)');
  String get parcelleCulture => _t('Culture', 'Crop');
  String parcelleNumber(int id) => _t('Parcelle N°$id', 'Plot #$id');
  String get confirmDeleteParcelleTitle => _t('Supprimer la parcelle', 'Delete plot');
  String confirmDeleteParcelleBody(String nom) => _t(
      'Voulez-vous vraiment supprimer "$nom" ? Cette action est définitive.',
      'Do you really want to delete "$nom"? This cannot be undone.');
  String get surface => _t('Superficie', 'Surface');
  String get notSpecified => _t('Non spécifiée', 'Not specified');
  String get culture => _t('Culture', 'Crop');
  String get location => _t('Localisation', 'Location');
  String get locationUnspecified => _t('Localisation non renseignée', 'Location not set');

  // --- Détail parcelle ---
  String get iotConnected => _t('IoT connecté', 'IoT connected');
  String get iotDisconnected => _t('IoT déconnecté', 'IoT disconnected');
  String lastUpdate(String time) => _t('Dernière mise à jour: $time', 'Last update: $time');
  String get temperature => _t('Température', 'Temperature');
  String get airHumidity => _t("Humidité de l'air", 'Air humidity');
  String get soilHumidity => _t('Humidité du sol', 'Soil humidity');
  String get seePrevision => _t('Voir la prévision des besoins en eau', 'View water need forecast');
  String get deviceKeyTitle => _t('Clé du capteur', 'Sensor key');
  String get deviceKeyCopied => _t('Clé copiée. Collez-la dans le firmware du capteur.', 'Key copied. Paste it in the sensor firmware.');
  String get materielsTitle => _t('Matériels', 'Devices');
  String get materielHint => _t('Ajouter un matériel (ex: ESP32)', 'Add a device (e.g. ESP32)');
  String get irrigationTitle => _t('Irrigation', 'Irrigation');
  String get modeAuto => _t('Automatique', 'Automatic');
  String get modeManuel => _t('Manuel', 'Manual');
  String get autoModeExplain => _t(
      "Le système décide seul, à chaque mesure reçue, si la pompe doit tourner, en fonction de l'humidité du sol. Aucune action de votre part.",
      'The system decides on its own, from each sensor reading, whether the pump should run, based on soil humidity. No action needed from you.');
  String get autoStatusOn => _t('Irrigation en cours (décidée automatiquement)', 'Irrigation running (decided automatically)');
  String get autoStatusOff => _t('Arrêtée : humidité du sol satisfaisante', 'Stopped: soil humidity is satisfactory');
  String get startIrrigation => _t("Démarrer l'irrigation", 'Start irrigation');
  String get stopIrrigation => _t("Arrêter l'irrigation", 'Stop irrigation');

  // --- Notification locale ---
  String get notifAutoTitle => _t('Irrigation automatique démarrée', 'Automatic irrigation started');
  String notifAutoBody(String nom) => _t(
      'La parcelle "$nom" est en cours d\'arrosage automatique.',
      'Plot "$nom" is being watered automatically.');

  // --- Prévision ---
  String previsionTitle(String nom) => _t('Prévision : $nom', 'Forecast: $nom');
  String get waterNeeded => _t('Arrosage recommandé', 'Watering recommended');
  String get waterNotNeeded => _t('Aucun arrosage nécessaire', 'No watering needed');
  String get previsionEmpty => _t(
      'La prévision sera disponible dès la réception des premières mesures.',
      'The forecast will be available once the first readings come in.');
  String get whyThisForecast => _t('Pourquoi cette prévision', 'Why this forecast');
  String get expectedEvolution => _t('Évolution attendue', 'Expected evolution');

  // --- Historique ---
  String get historyTitle => _t('Historique', 'History');
  String get historyActionsTitle => _t('Actions déclenchées', 'Triggered actions');
  String get historyNoActions => _t('Aucune action enregistrée', 'No action recorded');
  String get historyMesuresTitle => _t('Évolution des mesures', 'Sensor readings over time');
  String get historyNoMesures => _t('Aucune mesure enregistrée', 'No reading recorded');
  String get historyEmpty => _t('Aucun historique disponible pour cette parcelle', 'No history available for this plot');
  String get irrigationStarted => _t('Irrigation démarrée', 'Irrigation started');
  String get irrigationStopped => _t('Irrigation arrêtée', 'Irrigation stopped');
  String get automaticTag => _t('Automatique', 'Automatic');
  String get manualTag => _t('Manuel', 'Manual');
  String get soilLabel => _t('Sol', 'Soil');
  String get airLabel => _t('Air', 'Air');

  // --- Paramètres ---
  String get settingsTitle => _t('Paramètres', 'Settings');
  String get settingsNotifications => _t('Notifications', 'Notifications');
  String get settingsLanguage => _t('Langue', 'Language');
  String get settingsUnits => _t('Unités de mesure', 'Measurement units');
  String get settingsAbout => _t("À propos d'IrrigaSmart", 'About IrrigaSmart');
  String get notificationsScreenTitle => _t('Notifications', 'Notifications');
  String get notificationsToggleLabel => _t('Notifications locales', 'Local notifications');
  String get notificationsToggleBody => _t(
      "Recevez une notification sur votre téléphone quand l'irrigation automatique démarre.",
      'Get a notification on your phone when automatic irrigation starts.');
  String get languageScreenTitle => _t('Langue', 'Language');
  String get languageFrench => _t('Français', 'French');
  String get languageEnglish => _t('Anglais', 'English');
  String get unitsScreenTitle => _t('Unités de mesure', 'Measurement units');
  String get unitsTempLabel => _t('Température', 'Temperature');
  String get unitsCelsius => _t('Celsius (°C)', 'Celsius (°C)');
  String get unitsKelvin => _t('Kelvin (K)', 'Kelvin (K)');
  String get unitsHumidityNote => _t(
      "L'humidité du sol et de l'air est toujours exprimée en pourcentage (%), il n'y a pas d'autre unité à choisir.",
      'Soil and air humidity are always shown as a percentage (%), there is no other unit to choose.');
  String get aboutScreenTitle => _t('À propos', 'About');
  String get aboutBody => _t(_aboutFr, _aboutEn);

  static const String _aboutFr = '''
IrrigaSmart est une application de gestion agricole pensée pour aider les agriculteurs à surveiller et piloter l'irrigation de leurs parcelles à distance, grâce à des capteurs connectés.

Comment fonctionne l'application

Chaque parcelle est équipée d'un capteur qui mesure en continu trois valeurs : la température, l'humidité de l'air et l'humidité du sol. Ces mesures sont envoyées automatiquement au serveur et s'affichent dans l'application en temps réel, sans avoir besoin de rafraîchir l'écran.

À partir de ces mesures, l'application propose une prévision indiquant si un arrosage est recommandé dans les heures à venir.

Deux façons de gérer l'irrigation

En mode automatique, le système décide lui-même quand démarrer ou arrêter la pompe, en fonction de l'humidité du sol mesurée. Aucune intervention n'est nécessaire, et une notification vous prévient lorsque l'arrosage automatique démarre.

En mode manuel, c'est l'agriculteur qui démarre et arrête l'irrigation lui-même, directement depuis l'application.

Historique et suivi

Chaque parcelle conserve un historique des actions d'irrigation, en distinguant celles décidées automatiquement de celles déclenchées manuellement, ainsi que l'évolution récente des mesures des capteurs.

Gestion des matériels

Les capteurs et équipements associés à une parcelle peuvent être ajoutés et retirés depuis l'écran de détail de chaque parcelle. Chaque parcelle dispose d'une clé de capteur unique, à renseigner dans le microcontrôleur pour qu'il puisse envoyer ses mesures.

Comptes et rôles

L'application distingue deux types de comptes : les agriculteurs, qui gèrent leurs propres parcelles, et les administrateurs, qui supervisent l'ensemble des utilisateurs et des parcelles du système.
''';

  static const String _aboutEn = '''
IrrigaSmart is a farm management application designed to help farmers monitor and control irrigation on their plots remotely, using connected sensors.

How the application works

Each plot is equipped with a sensor that continuously measures three values: temperature, air humidity and soil humidity. These readings are sent automatically to the server and appear in the application in real time, with no need to refresh the screen.

Based on these readings, the application provides a forecast indicating whether watering is recommended in the coming hours.

Two ways to manage irrigation

In automatic mode, the system decides on its own when to start or stop the pump, based on the measured soil humidity. No action is required, and a notification lets you know when automatic watering starts.

In manual mode, the farmer starts and stops irrigation directly from the application.

History and tracking

Each plot keeps a history of irrigation actions, distinguishing those decided automatically from those triggered manually, as well as the recent evolution of sensor readings.

Device management

The sensors and equipment associated with a plot can be added and removed from that plot's detail screen. Each plot has a unique sensor key, to be entered in the microcontroller so it can send its readings.

Accounts and roles

The application distinguishes two types of accounts: farmers, who manage their own plots, and administrators, who oversee all users and plots in the system.
''';

  // --- Profil ---
  String get logout => _t('Se déconnecter', 'Log out');
  String get roleAdmin => _t('Administrateur', 'Administrator');
  String get roleFarmer => _t('Agriculteur', 'Farmer');

  // --- Administration ---
  String get adminTitle => _t('Administration', 'Administration');
  String get adminChooseWhat => _t('Que voulez-vous gérer ?', 'What do you want to manage?');
  String get adminUsersTitle => _t('Utilisateurs', 'Users');
  String get adminParcellesTitle => _t('Parcelles', 'Plots');
  String get adminSearchUser => _t('Rechercher un utilisateur', 'Search a user');
  String get adminSearchParcelle => _t('Rechercher une parcelle ou un propriétaire', 'Search a plot or owner');
  String get adminAddUser => _t('Ajouter un utilisateur', 'Add a user');
  String get adminEditUser => _t("Modifier l'utilisateur", 'Edit user');
  String get adminAccountActive => _t('Compte actif', 'Account active');
  String get adminAccountDisabled => _t('Compte désactivé', 'Account disabled');
  String get adminDeleteAccount => _t('Supprimer le compte', 'Delete account');
  String get adminConfirmDeleteUserTitle => _t('Supprimer ce compte', 'Delete this account');
  String adminConfirmDeleteUserBody(String nom) => _t(
      'Voulez-vous vraiment supprimer définitivement le compte de $nom ? Cette action est irréversible.',
      'Do you really want to permanently delete the account of $nom? This cannot be undone.');
  String get adminConfirmDeleteParcelleTitle => _t('Supprimer la parcelle', 'Delete plot');
  String adminConfirmDeleteParcelleBody(String nom) => _t(
      'Voulez-vous vraiment supprimer "$nom" ? Cette action est définitive et supprimera aussi ses mesures et son historique.',
      'Do you really want to delete "$nom"? This is permanent and will also delete its readings and history.');
  String get adminNoUsers => _t('Aucun utilisateur trouvé', 'No user found');
  String get adminNoParcelles => _t('Aucune parcelle enregistrée', 'No plot registered');
  String get emailShort => 'Email';
  String get phoneShort => _t('Téléphone', 'Phone');
  String get roleLabel => _t('Rôle', 'Role');
  String get create => _t('Créer', 'Create');
}