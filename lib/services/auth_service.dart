import 'dart:convert';

import 'package:fluire/modelos/usuario.dart';
import 'package:fluire/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService();

  final ApiClient _api = ApiClient.instance;
  Usuario? _usuario;

  static const String _usuarioKey = 'api_usuario';

  Usuario? get usuarioAtual => _usuario;

  Future<void> carregarSessao() async {
    await _api.carregarSessao();
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString(_usuarioKey);
    if (usuarioJson != null) {
      try {
        _usuario = Usuario.fromJson(json.decode(usuarioJson) as Map<String, dynamic>);
      } catch (_) {
        _usuario = null;
      }
    }
  }

  Future<Usuario> login(String email, String senha) async {
    final response = await _api.post('/login', body: {
      'email': email.trim(),
      'senha': senha,
    });

    final jsonData = ApiClient.decodificarCorpo(response);

    if (response.statusCode != 200) {
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Email ou senha incorretos'));
    }

    final usuarioJson = jsonData['usuario'] as Map<String, dynamic>?;
    final token = jsonData['token']?.toString();

    if (usuarioJson == null || token == null) {
      throw Exception('Resposta de login inválida');
    }

    final usuario = Usuario.fromJson(usuarioJson);
    await _api.definirSessao(token: token, userId: int.parse(usuario.id));
    _usuario = usuario;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usuarioKey, json.encode(usuarioJson));

    return usuario;
  }

  Future<Usuario> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final response = await _api.post('/usuarios', body: {
      'nome': nome.trim(),
      'email': email.trim(),
      'senha': senha,
    });

    final jsonData = ApiClient.decodificarCorpo(response);

    if (response.statusCode != 201) {
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao criar conta'));
    }

    return login(email, senha);
  }

  Future<void> recuperarSenha(String email) async {
    final response = await _api.post('/recuperar-senha', body: {
      'email': email.trim(),
    });

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao recuperar senha'));
    }
  }

  Future<void> logout() async {
    await _api.limparSessao();
    _usuario = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usuarioKey);
  }
}
