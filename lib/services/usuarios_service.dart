import 'package:fluire/modelos/usuario.dart';
import 'package:fluire/services/api_client.dart';

class UsuariosService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Usuario>> listar() async {
    final response = await _api.get('/usuarios');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar usuários: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    final usuarios = <Usuario>[];
    for (final item in jsonData) {
      if (item is! Map) continue;
      try {
        usuarios.add(Usuario.fromJson(Map<String, dynamic>.from(item)));
      } catch (_) {
        continue;
      }
    }
    return usuarios;
  }

  Future<Usuario?> buscarPorNome(String nome) async {
    final response = await _api.get('/usuarios/$nome');

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar usuário: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is Map<String, dynamic>) {
      return Usuario.fromJson(jsonData);
    }
    return null;
  }

  Future<Usuario> atualizar(Usuario usuario) async {
    final idInt = int.tryParse(usuario.id);
    if (idInt == null) throw Exception('ID inválido: ${usuario.id}');

    final response = await _api.put('/usuarios/$idInt', body: usuario.toJson());

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao atualizar usuário'));
    }

    return usuario;
  }

  Future<void> remover(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.delete('/usuarios/$idInt');

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao remover usuário'));
    }
  }
}
