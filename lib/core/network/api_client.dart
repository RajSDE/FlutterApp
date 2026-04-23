import 'package:flutter_app/core/network/network_service.dart';

class ApiClient {
  const ApiClient(this._networkService);

  final NetworkService _networkService;

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) {
    return _networkService.post(path, data: data);
  }
}
