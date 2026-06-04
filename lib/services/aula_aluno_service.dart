import 'package:fluire/modelos/aula_aluno.dart';
import 'package:fluire/services/api_client.dart';

class AulaAlunoService {
  final ApiClient _api = ApiClient.instance;

  Future<List<AulaAluno>> listar() async {
    final response = await _api.get('/aula-alunos');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar associações: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    return jsonData
        .whereType<Map<String, dynamic>>()
        .map((json) => AulaAluno.fromJson(json))
        .toList();
  }

  Future<AulaAluno?> buscarPorId(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.get('/aula-alunos/$idInt');

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar associação: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is Map<String, dynamic>) {
      return AulaAluno.fromJson(jsonData);
    }
    return null;
  }

  Future<AulaAluno> associar(int aulaId, int alunoId) async {
    final response = await _api.post('/aula-alunos', body: {
      'aula_id': aulaId,
      'aluno_id': alunoId,
    });

    if (response.statusCode != 201) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao associar aluno à aula'));
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    return AulaAluno.fromJson(jsonData as Map<String, dynamic>);
  }

  Future<void> remover(int aulaId, int alunoId) async {
    final response = await _api.delete('/aula-alunos', body: {
      'aula_id': aulaId,
      'aluno_id': alunoId,
    });

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao remover associação'));
    }
  }

  Future<List<Map<String, dynamic>>> obterAlunosDeUmaAula(int aulaId) async {
    final response = await _api.get('/aulas/$aulaId/alunos');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar alunos da aula: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    return jsonData.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> obterAulasDeUmAluno(int alunoId) async {
    final response = await _api.get('/alunos/$alunoId/aulas');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar aulas do aluno: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    return jsonData.cast<Map<String, dynamic>>();
  }
}
