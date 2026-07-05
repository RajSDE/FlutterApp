import 'package:dio/dio.dart';
import 'package:flutter_app/config/environment/app_environment.dart';
import 'package:flutter_app/core/error/app_exception.dart';

class NetworkService {
  NetworkService({
    required Dio dio,
    required AppEnvironment environment,
    required Iterable<Interceptor> interceptors,
  }) : _dio = dio {
    _dio.options = BaseOptions(
      baseUrl: environment.baseUrl,
      connectTimeout: Duration(milliseconds: environment.connectTimeoutInMs),
      receiveTimeout: Duration(milliseconds: environment.receiveTimeoutInMs),
      headers: const <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Tenant-Id': 'DEFAULT',
      },
    );
    _dio.interceptors.clear();
    _dio.interceptors.addAll(interceptors);
  }

  final Dio _dio;

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        options: headers == null ? null : Options(headers: headers),
      );
      return response.data ?? <String, dynamic>{};
    } on DioException catch (exception) {
      throw AppException(_extractErrorMessage(exception));
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: headers == null ? null : Options(headers: headers),
      );
      return response.data ?? <String, dynamic>{};
    } on DioException catch (exception) {
      throw AppException(_extractErrorMessage(exception));
    }
  }

  String _extractErrorMessage(DioException exception) {
    final data = exception.response?.data;

    if (data is Map<String, dynamic>) {
      if (data['error'] is Map<String, dynamic>) {
        final error = data['error'] as Map<String, dynamic>;
        final message = error['message'] as String?;
        if (message != null && message.isNotEmpty) {
          return message;
        }
      }

      final message = data['message'] as String?;
      if (message != null && message.isNotEmpty) {
        return message;
      }

      final messageKey = data['messageKey'] as String?;
      if (messageKey != null && messageKey.isNotEmpty) {
        return messageKey;
      }
    }

    return exception.message ?? 'Unexpected network error.';
  }
}
