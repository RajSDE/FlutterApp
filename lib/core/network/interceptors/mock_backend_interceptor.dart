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

    if (options.method == 'GET' && options.path.startsWith('/v1/user/')) {
      final profileId = options.path.split('/').last;
      handler.resolve(
        _response(
          options,
          <String, dynamic>{
            'traceId': 'trace-12345',
            'status': 'SUCCESS',
            'message': 'User profile details retrieved successfully',
            'userProfileId': profileId,
            'firstName': 'Raj',
            'lastName': 'Kumar',
            'fullName': 'Raj Kumar',
            'email': 'raj@gmail.com',
            'mobileNumber': '9631341874',
            'gender': 'MALE',
            'preferredLanguage': 'en',
            'mobileNumberVerified': 'Y',
            'emailVerified': 'Y',
            'tenantId': 'DEFAULT'
          },
        ),
      );
      return;
    }

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
      case '/auth/dummy-login':
        final dummyUserId =
            (options.data as Map<String, dynamic>)['dummyUserId'] as String? ??
                '';
        if (dummyUserId.trim().isEmpty) {
          handler.reject(_error(options, 400, AppErrorKeys.invalidDummyId));
          return;
        }
        handler.resolve(
          _response(
            options,
            <String, dynamic>{
              'id': 999,
              'name': 'Demo Shopper',
              'email': '$dummyUserId@demo.quickcommerce',
              'token': 'dummy_access_token_123',
              'refreshToken': 'dummy_refresh_token_123',
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
      case '/v1/user/register':
        final data = options.data as Map<String, dynamic>;
        final email = data['email'] as String? ?? '';
        final username = data['username'] as String? ?? 'user';
        handler.resolve(
          _response(
            options,
            <String, dynamic>{
              'traceId': 'trace-12345',
              'status': 'SUCCESS',
              'message': 'Registration successful',
              'userProfileId': 'profile-999',
              'username': username,
              'email': email,
            },
          ),
        );
        return;
      case '/v1/user/login':
        final data = options.data as Map<String, dynamic>;
        final mobileNumber = data['mobileNumber'] as String? ?? '';
        final password = data['password'] as String? ?? '';
        if (mobileNumber.isEmpty || password.isEmpty) {
          handler.reject(_error(options, 400, 'errorInvalidCredentials'));
          return;
        }
        handler.resolve(
          _response(
            options,
            <String, dynamic>{
              'id': 100,
              'name': 'John Doe',
              'email': 'john.doe@example.com',
              'token': 'mock_session_token_123',
              'refreshToken': 'mock_session_refresh_123',
            },
          ),
        );
        return;
      case '/v1/user/identifier-verification':
        final data = options.data as Map<String, dynamic>;
        final identifierType = data['identifierType'] as String? ?? '';
        final identifierValue = data['identifierValue'] as String? ?? '';
        if (identifierType != 'MOBILE' && identifierType != 'EMAIL') {
          handler.reject(_error(options, 400, 'errorInvalidIdentifierType'));
          return;
        }
        if (identifierValue.isEmpty) {
          handler.reject(_error(options, 400, 'errorInvalidIdentifierValue'));
          return;
        }
        handler.resolve(
          _response(
            options,
            <String, dynamic>{
              'traceId': 'mock-trace-verification',
              'status': 'SUCCESS',
              'message': 'Verification code sent successfully',
              'uniqueId':
                  'mock-unique-id-${DateTime.now().millisecondsSinceEpoch}',
            },
          ),
        );
        return;
      case '/v1/user/validate-otp':
        final data = options.data as Map<String, dynamic>;
        final uniqueId = data['uniqueId'] as String? ?? '';
        final otp = data['otp'] as String? ?? '';
        if (uniqueId.isEmpty || otp.length != 6) {
          handler.reject(_error(options, 400, 'errorInvalidOtpRequest'));
          return;
        }
        handler.resolve(
          _response(
            options,
            <String, dynamic>{
              'traceId': 'mock-trace-validate-otp',
              'status': 'SUCCESS',
              'message': 'OTP verified successfully',
              'error': null,
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
