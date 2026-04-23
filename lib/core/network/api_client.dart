import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app/core/utils/constants.dart';

class ApiClient {
  ApiClient(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );
  }

  final Dio _dio;

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    // This starter keeps the app runnable before a real backend is connected.
    await Future<void>.delayed(const Duration(seconds: 1));

    if (path == AppConstants.loginEndpoint) {
      final email = data?['email'] as String? ?? '';
      final password = data?['password'] as String? ?? '';

      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required.');
      }

      return <String, dynamic>{
        'id': 1,
        'name': 'Demo User',
        'email': email,
        'token': 'demo_token_123',
      };
    }

    throw Exception('Endpoint not implemented: $path');
  }
}
