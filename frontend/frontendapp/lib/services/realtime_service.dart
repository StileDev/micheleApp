import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'api_client.dart';
import 'storage_service.dart';

/// Convertit l'URL HTTP du backend en URL WebSocket (http -> ws, https -> wss).
String _wsBaseUrl() {
  if (baseUrl.startsWith('https://')) return 'wss://${baseUrl.substring('https://'.length)}';
  if (baseUrl.startsWith('http://')) return 'ws://${baseUrl.substring('http://'.length)}';
  return baseUrl;
}

class RealtimeService {
  final StorageService _storage = StorageService();
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  /// Ouvre la connexion et appelle [onMessage] avec le JSON décodé à
  /// chaque mesure reçue. Le token JWT est passé en paramètre de requête
  /// puisqu'un WebSocket ne peut pas envoyer d'en-tête Authorization.
  Future<void> connect(int parcelleId, void Function(Map<String, dynamic>) onMessage) async {
    final token = await _storage.getAccessToken();
    if (token == null) return;

    final uri = Uri.parse('${_wsBaseUrl()}/ws/parcelles/$parcelleId/?token=$token');

    try {
      _channel = WebSocketChannel.connect(uri);
      _subscription = _channel!.stream.listen(
        (event) {
          try {
            final data = jsonDecode(event as String) as Map<String, dynamic>;
            onMessage(data);
          } catch (_) {
            // Message non JSON ou inattendu : on l'ignore silencieusement,
            // ça ne doit jamais faire planter l'écran.
          }
        },
        onError: (_) {},
        cancelOnError: false,
      );
    } catch (_) {
      // Pas de connexion possible (backend WebSocket pas encore configuré,
      // réseau coupé...) : l'app continue de fonctionner avec les données
      // chargées via l'API REST classique, juste sans le temps réel.
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
    _subscription = null;
  }
}
