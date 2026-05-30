import 'package:fluire/services/api_client.dart';

class FrequenciaService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Map<String, dynamic>>> listar() async {
    final response = await _api.get('/frequencias');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar frequências: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    return jsonData.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> listarPorAula(int aulaId) async {
    final response = await _api.get('/frequencias/aula/$aulaId');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar frequências da aula: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    return jsonData.cast<Map<String, dynamic>>();
  }

  Future<void> registrar({
    required int aulaId,
    required int alunoId,
    required int presente,
    required String dataPresenca,
  }) async {
    final response = await _api.post('/frequencias', body: {
      'aula_id': aulaId,
      'aluno_id': alunoId,
      'presente': presente,
      'data_presenca': dataPresenca,
    });

    if (response.statusCode != 201) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao registrar frequência'));
    }
  }
}
