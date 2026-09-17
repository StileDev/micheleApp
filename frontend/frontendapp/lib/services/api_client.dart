import 'package:dio/dio.dart';
import 'storage_service.dart';
import '../core/app_globals.dart';

const String baseUrl = 'http://172.21.227.167:8000';

class ApiClient {
  final StorageService storage = StorageService();
  late final Dio dio;

  static bool _isRedirecting = false;
  static Future<String?>? _refreshFuture;

  ApiClient() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final newAccess = await _refreshAccessToken();

          if (newAccess != null) {
            error.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
            try {
              final cloneReq = await dio.fetch(error.requestOptions);
              return handler.resolve(cloneReq);
            } catch (_) {
              return handler.next(error);
            }
          } else {
            await _forceLogoutAndRedirect();
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<String?> _refreshAccessToken() {
    _refreshFuture ??= _doRefresh().whenComplete(() => _refreshFuture = null);
    return _refreshFuture!;
  }

  Future<String?> _doRefresh() async {
    final refresh = await storage.getRefreshToken();
    if (refresh == null) return null;

    try {
      final resp = await Dio(BaseOptions(baseUrl: baseUrl))
          .post('/api/auth/token/refresh/', data: {'refresh': refresh});

      final newAccess = resp.data['access'] as String;
      final newRefresh = resp.data['refresh'] as String? ?? refresh;

      await storage.saveTokens(access: newAccess, refresh: newRefresh);
      return newAccess;
    } catch (_) {
      return null;
    }
  }

  Future<void> _forceLogoutAndRedirect() async {
    await authProvider.forceLogout();

    if (_isRedirecting) return;
    _isRedirecting = true;

    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);

    Future.delayed(const Duration(seconds: 1), () => _isRedirecting = false);
  }
}
