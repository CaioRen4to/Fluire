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
}