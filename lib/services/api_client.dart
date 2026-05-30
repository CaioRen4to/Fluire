import 'dart:convert';

import 'package:fluire/config/api_config.dart';
import 'package:http/http.dart' as http;

/// Cliente HTTP compartilhado com token de autenticação.
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  String? _token;
  int? _userId;

  String? get token => _token;
  int? get userId => _userId;
  bool get autenticado => _token != null;

  void definirSessao({required String token, required int userId}) {
    _token = token;
    _userId = userId;
  }

  void limparSessao() {
    _token = null;
    _userId = null;
  }

  Map<String, String> headers({bool json = true}) {
    final map = <String, String>{'Accept': 'application/json'};
    if (json) {
      map['Content-Type'] = 'application/json';
    }
    if (_token != null) {
      map['Authorization'] = 'Bearer $_token';
    }
    return map;
  }

  Uri uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<http.Response> get(String path) {
    return http
        .get(uri(path), headers: headers())
        .timeout(ApiConfig.timeout);
  }

  Future<http.Response> post(String path, {Object? body}) {
    return http
        .post(
          uri(path),
          headers: headers(),
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(ApiConfig.timeout);
  }

  Future<http.Response> put(String path, {Object? body}) {
    return http
        .put(
          uri(path),
          headers: headers(),
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(ApiConfig.timeout);
  }

  Future<http.Response> delete(String path, {Object? body}) {
    return http
        .delete(
          uri(path),
          headers: headers(),
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(ApiConfig.timeout);
  }

  static dynamic decodificarCorpo(http.Response response) {
    if (response.body.isEmpty) return null;
    return json.decode(response.body);
  }

  static String extrairErro(dynamic jsonData, {String fallback = 'Erro na requisição'}) {
    if (jsonData is Map) {
      return (jsonData['erro'] ?? jsonData['message'] ?? jsonData['mensagem'] ?? fallback)
          .toString();
    }
    return fallback;
  }
}
