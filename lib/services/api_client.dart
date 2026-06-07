import 'dart:convert';

import 'package:fluire/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Cliente HTTP compartilhado com token de autenticação.
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  static const String _tokenKey = 'api_token';
  static const String _userIdKey = 'api_user_id';

  String? _token;
  int? _userId;

  String? get token => _token;
  int? get userId => _userId;
  bool get autenticado => _token != null;

  Future<void> definirSessao({required String token, required int userId}) async {
    _token = token;
    _userId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
  }

  Future<void> carregarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userId = prefs.getInt(_userIdKey);
    if (token != null && userId != null) {
      _token = token;
      _userId = userId;
    }
  }

  Future<void> limparSessao() async {
    _token = null;
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
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

  Future<http.Response> put(String path, {Object? body}) async {
    final url = uri(path);
    final hdrs = headers();
    final payload = body == null ? null : jsonEncode(body);

    print("PUT => $url");
    print("Headers => $hdrs");
    print("Payload => $payload");

    final response = await http
        .put(
          url,
          headers: hdrs,
          body: payload,
        )
        .timeout(ApiConfig.timeout);

    print("Status => ${response.statusCode}");
    print("Response => ${response.body}");

    return response;
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
    try {
      return json.decode(response.body);
    } catch (_) {
      final body = response.body.trim();
      if (body.isEmpty) return null;
      if (body.contains('<html') || body.contains('<HTML')) {
        final textoSemTags = body.replaceAll(RegExp(r'<[^>]*>'), '').trim();
        return textoSemTags.isNotEmpty ? textoSemTags : body;
      }
      return body;
    }
  }

  static String extrairErro(dynamic jsonData, {String fallback = 'Erro na requisição'}) {
    if (jsonData is Map) {
      return (jsonData['erro'] ?? jsonData['error'] ?? jsonData['message'] ?? jsonData['mensagem'] ?? fallback)
          .toString();
    }
    if (jsonData is String && jsonData.trim().isNotEmpty) {
      final texto = jsonData.trim();
      if (texto.contains('<html') || texto.contains('<HTML')) {
        final textoSemTags = texto.replaceAll(RegExp(r'<[^>]*>'), '').trim();
        return textoSemTags.isNotEmpty ? textoSemTags : fallback;
      }
      return texto;
    }
    return fallback;
  }
}
