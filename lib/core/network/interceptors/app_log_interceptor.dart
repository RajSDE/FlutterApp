import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppLogInterceptor extends Interceptor {
  AppLogInterceptor({
    required this.enabled,
  });

  final bool enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      debugPrint(
        '[DIO][REQ] ${options.method} ${options.baseUrl}${options.path} data=${options.data}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enabled) {
      debugPrint(
        '[DIO][RES] ${response.statusCode} ${response.requestOptions.path} data=${response.data}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      debugPrint(
        '[DIO][ERR] ${err.response?.statusCode} ${err.requestOptions.path} message=${err.message}',
      );
    }
    handler.next(err);
  }
}
