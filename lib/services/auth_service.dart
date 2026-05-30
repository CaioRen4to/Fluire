import 'package:fluire/modelos/usuario.dart';
import 'package:fluire/services/api_client.dart';

class AuthService {
  final ApiClient _api = ApiClient.instance;

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
    _api.definirSessao(token: token, userId: int.parse(usuario.id));

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
    _api.limparSessao();
  }

  Usuario? get usuarioAtual {
    if (!_api.autenticado) return null;
    return null;
  }
}
