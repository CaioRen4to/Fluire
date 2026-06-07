import 'package:fluire/models/aula.dart';
import 'package:fluire/services/api_client.dart';

class AulasService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Aula>> listar() async {
    final response = await _api.get('/aulas');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar aulas: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    final aulas = <Aula>[];
    for (final item in jsonData) {
      try {
        aulas.add(Aula.fromJson(item));
      } catch (_) {
        continue;
      }
    }
    return aulas;
  }

  Future<Aula?> buscarPorId(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.get('/aulas/$idInt');

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar aula: ${response.statusCode}');
    }

    return Aula.fromJson(ApiClient.decodificarCorpo(response));
  }

  Future<Aula> criar(Aula aula) async {
    final payload = Map<String, dynamic>.from(aula.toJson());
    if (_api.userId != null) {
      payload['usuario_id'] = _api.userId;
    }

    final response = await _api.post('/aulas', body: payload);

    if (response.statusCode != 201) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao criar aula'));
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    return aula.copyWith(id: jsonData['id'].toString());
  }

  Future<Aula> atualizar(Aula aula) async {
    final idInt = int.tryParse(aula.id);
    if (idInt == null) throw Exception('ID inválido: ${aula.id}');

    final payload = Map<String, dynamic>.from(aula.toJson());
    if (_api.userId != null) {
      payload['usuario_id'] = _api.userId;
    }

    final response = await _api.put('/aulas/$idInt', body: payload);

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao atualizar aula'));
    }

    return aula;
  }

  Future<void> remover(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.delete('/aulas/$idInt');

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao remover aula'));
    }
  }
}
