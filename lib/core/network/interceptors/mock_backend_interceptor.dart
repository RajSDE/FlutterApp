import 'package:dio/dio.dart';
import 'package:flutter_app/core/constants/app_error_keys.dart';

class MockBackendInterceptor extends Interceptor {
  MockBackendInterceptor({
    required this.enabled,
  });

  final bool enabled;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!enabled) {
      handler.next(options);
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 300));

    switch (options.path) {
      case '/auth/signup':
        final email =
            (options.data as Map<String, dynamic>)['email'] as String? ?? '';
        if (!email.contains('@')) {
          handler.reject(_error(options, 400, AppErrorKeys.invalidEmail));
          return;
        }
        handler.resolve(
          _response(
            options,
            <String, dynamic>{
              'id': 101,
              'name': email.split('@').first,
              'email': email,
              'token': 'signup_token_123',
              'refreshToken': 'signup_refresh_123',
            },
          ),
        );
        return;
      case '/auth/request-otp':
        final phone =
            (options.data as Map<String, dynamic>)['phone'] as String? ?? '';
        if (phone.length < 10) {
          handler.reject(_error(options, 400, AppErrorKeys.invalidMobile));
          return;
        }
        handler.resolve(
          _response(
            options,
            <String, dynamic>{
              'success': true,
              'message': 'otp_sent',
            },
          ),
        );
        return;
      case '/auth/verify-otp':
        final data = options.data as Map<String, dynamic>;
        final phone = data['phone'] as String? ?? '';
        final otp = data['otp'] as String? ?? '';
        if (phone.length < 10 || otp.length != 6) {
          handler.reject(_error(options, 400, AppErrorKeys.invalidOtpRequest));
          return;
        }
        handler.resolve(
          _response(
            options,
            <String, dynamic>{
              'id': 100,
              'name': 'Enterprise User',
              'email': 'mobileuser@company.com',
              'token': 'otp_token_123',
              'refreshToken': 'otp_refresh_123',
            },
          ),
        );
        return;
      case '/auth/refresh-token':
        final refreshToken =
            (options.data as Map<String, dynamic>)['refreshToken'] as String? ??
                '';
        if (refreshToken.isEmpty) {
          handler.reject(_error(options, 401, AppErrorKeys.verifyOtpFailed));
          return;
        }
        handler.resolve(
          _response(
            options,
            <String, dynamic>{
              'token': 'refreshed_access_token',
              'refreshToken': 'refreshed_refresh_token',
            },
          ),
        );
        return;
      default:
        handler.next(options);
    }
  }

  Response<Map<String, dynamic>> _response(
    RequestOptions options,
    Map<String, dynamic> data,
  ) {
    return Response<Map<String, dynamic>>(
      requestOptions: options,
      data: data,
      statusCode: 200,
    );
  }

  DioException _error(RequestOptions options, int statusCode, String key) {
    return DioException(
      requestOptions: options,
      response: Response<Map<String, dynamic>>(
        requestOptions: options,
        statusCode: statusCode,
        data: <String, dynamic>{'messageKey': key},
      ),
      type: DioExceptionType.badResponse,
    );
  }
}
