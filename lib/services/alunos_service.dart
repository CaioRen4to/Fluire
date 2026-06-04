import 'package:fluire/modelos/aluno.dart';
import 'package:fluire/services/api_client.dart';

class AlunosService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Aluno>> listar() async {
    final response = await _api.get('/alunos');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar alunos: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    final alunos = <Aluno>[];
    for (final item in jsonData) {
      try {
        alunos.add(Aluno.fromJson(item));
      } catch (_) {
        continue;
      }
    }
    return alunos;
  }

  Future<Aluno?> buscarPorId(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.get('/alunos/$idInt');

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar aluno: ${response.statusCode}');
    }

    return Aluno.fromJson(ApiClient.decodificarCorpo(response));
  }

  Future<Aluno> criar(Aluno aluno) async {
    final body = {
      'nome': aluno.nome,
      'email': aluno.email,
      'telefone': aluno.telefone,
      if (_api.userId != null) 'usuario_logado_id': _api.userId,
    };

    final response = await _api.post('/alunos', body: body);

    if (response.statusCode != 201) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao criar aluno'));
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    final alunoId = jsonData['id']?.toString() ?? aluno.id;
    return aluno.copyWith(id: alunoId);
  }

  Future<Aluno> atualizar(Aluno aluno) async {
    final idInt = int.tryParse(aluno.id);
    if (idInt == null) throw Exception('ID inválido: ${aluno.id}');

    final body = {
      'nome': aluno.nome,
      'email': aluno.email,
      'telefone': aluno.telefone,
    };

    final response = await _api.put('/alunos/$idInt', body: body);

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao atualizar aluno'));
    }

    return aluno;
  }

  Future<void> remover(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.delete('/alunos/$idInt');

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao remover aluno'));
    }
  }

  Future<List<Aluno>> buscarPorNome(String nome) async {
    final response = await _api.get('/alunos/nome/$nome');

    if (response.statusCode == 404) return [];
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar alunos: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    return jsonData.map((json) => Aluno.fromJson(json)).toList();
  }
}
