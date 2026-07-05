import 'package:flutter_app/core/network/network_service.dart';

class ApiClient {
  const ApiClient(this._networkService);

  final NetworkService _networkService;

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) {
    return _networkService.post(path, data: data, headers: headers);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _networkService.get(
      path,
      queryParameters: queryParameters,
      headers: headers,
    );
  }
}
