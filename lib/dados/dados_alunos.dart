import 'package:fluire/modelos/aluno.dart';

/// Dados de alunos - Preparado para integração com backend
/// Implementar chamadas de API real nos métodos abaixo
class DadosAlunos {
  final List<Aluno> _alunos = [];

  Future<void> _aguardar() => Future.delayed(const Duration(milliseconds: 400));

  /// Lista todos os alunos
  /// TODO: Implementar chamada GET para API de alunos
  Future<List<Aluno>> listar() async {
    await _aguardar();
    return List.unmodifiable(_alunos);
  }

  /// Busca aluno por ID
  /// TODO: Implementar chamada GET para API de alunos/{id}
  Future<Aluno?> buscarPorId(String id) async {
    await _aguardar();
    try {
      return _alunos.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Salva aluno (cria ou atualiza)
  /// TODO: Implementar chamada POST/PUT para API de alunos
  Future<Aluno> salvar(Aluno aluno, {bool criando = false}) async {
    await _aguardar();
    if (aluno.nome.trim().isEmpty) {
      throw Exception('Informe o nome do aluno.');
    }
    if (criando) {
      _alunos.add(aluno);
    } else {
      final i = _alunos.indexWhere((a) => a.id == aluno.id);
      if (i >= 0) _alunos[i] = aluno;
    }
    return aluno;
  }

  /// Remove aluno
  /// TODO: Implementar chamada DELETE para API de alunos/{id}
  Future<void> remover(String id) async {
    await _aguardar();
    _alunos.removeWhere((a) => a.id == id);
  }
}
