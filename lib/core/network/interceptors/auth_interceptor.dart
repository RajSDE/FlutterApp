import 'package:dio/dio.dart';
import 'package:flutter_app/core/constants/storage_keys.dart';
import 'package:flutter_app/core/security/secure_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required Dio dio,
    required SecureStorageService secureStorageService,
    required Iterable<Interceptor> refreshInterceptors,
  })  : _dio = dio,
        _secureStorageService = secureStorageService,
        _refreshInterceptors = refreshInterceptors;

  final Dio _dio;
  final SecureStorageService _secureStorageService;
  final Iterable<Interceptor> _refreshInterceptors;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorageService.read(StorageKeys.authToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 ||
        err.requestOptions.extra['retried'] == true) {
      handler.next(err);
      return;
    }

    final refreshToken =
        await _secureStorageService.read(StorageKeys.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      handler.next(err);
      return;
    }

    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          connectTimeout: _dio.options.connectTimeout,
          receiveTimeout: _dio.options.receiveTimeout,
          headers: _dio.options.headers,
        ),
      )..interceptors.addAll(_refreshInterceptors);

      final refreshResponse = await refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh-token',
        data: <String, dynamic>{'refreshToken': refreshToken},
      );

      final newToken = refreshResponse.data?['token'] as String?;
      final newRefreshToken = refreshResponse.data?['refreshToken'] as String?;

      if (newToken == null || newRefreshToken == null) {
        handler.next(err);
        return;
      }

      await _secureStorageService.write(
        key: StorageKeys.authToken,
        value: newToken,
      );
      await _secureStorageService.write(
        key: StorageKeys.refreshToken,
        value: newRefreshToken,
      );

      final requestOptions = err.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer $newToken';
      requestOptions.extra['retried'] = true;
      final response = await _dio.fetch<Map<String, dynamic>>(requestOptions);
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }
}
