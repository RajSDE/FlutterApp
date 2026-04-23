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
      },
    );
    _dio.interceptors.clear();
    _dio.interceptors.addAll(interceptors);
  }

  final Dio _dio;

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
      );
      return response.data ?? <String, dynamic>{};
    } on DioException catch (exception) {
      final messageKey = exception.response?.data is Map<String, dynamic>
          ? (exception.response?.data['messageKey'] as String?)
          : null;
      throw AppException(
        messageKey ?? exception.message ?? 'Unexpected network error.',
      );
    }
  }
}
