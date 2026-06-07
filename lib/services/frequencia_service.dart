import 'package:fluire/modelos/frequencia.dart';
import 'package:fluire/services/api_client.dart';

class FrequenciaService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Frequencia>> listar() async {
    final response = await _api.get('/frequencias');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar frequências: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    return jsonData
        .whereType<Map<String, dynamic>>()
        .map((json) => Frequencia.fromJson(json))
        .toList();
  }

  Future<List<Frequencia>> listarPorAula(int aulaId) async {
    final response = await _api.get('/frequencias/aulas/$aulaId');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar frequências da aula: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    return jsonData
        .whereType<Map<String, dynamic>>()
        .map((json) => Frequencia.fromJson(json))
        .toList();
  }

  Future<Frequencia> registrar({
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

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is Map<String, dynamic> && (jsonData.containsKey('aula_id') || jsonData.containsKey('id'))) {
      return Frequencia.fromJson(jsonData);
    }
    return Frequencia(
      aulaId: aulaId,
      alunoId: alunoId,
      presente: presente,
      dataPresenca: dataPresenca,
    );
  }
}
