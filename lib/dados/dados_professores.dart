import 'package:fluire/modelos/professor.dart';

/// Dados de professores - Preparado para integração com backend
/// Implementar chamadas de API real nos métodos abaixo
class DadosProfessores {
  final List<Professor> _professores = [];

  Future<void> _aguardar() => Future.delayed(const Duration(milliseconds: 300));

  /// Lista todos os professores
  /// TODO: Implementar chamada GET para API de professores
  Future<List<Professor>> listar() async {
    await _aguardar();
    return List.unmodifiable(_professores);
  }

  /// Busca professor por ID
  /// TODO: Implementar chamada GET para API de professores/{id}
  Future<Professor?> buscarPorId(String id) async {
    await _aguardar();
    try {
      return _professores.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Salva professor (cria ou atualiza)
  /// TODO: Implementar chamada POST/PUT para API de professores
  Future<Professor> salvar(Professor professor, {bool criando = false}) async {
    await _aguardar();
    if (professor.nome.trim().isEmpty) {
      throw Exception('Informe o nome do professor.');
    }
    if (criando) {
      _professores.add(professor);
    } else {
      final i = _professores.indexWhere((p) => p.id == professor.id);
      if (i >= 0) _professores[i] = professor;
    }
    return professor;
  }

  /// Remove professor
  /// TODO: Implementar chamada DELETE para API de professores/{id}
  Future<void> remover(String id) async {
    await _aguardar();
    _professores.removeWhere((p) => p.id == id);
  }
}
