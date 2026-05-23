import 'package:fluire/modelos/aula.dart';

/// Dados de aulas - Preparado para integração com backend
/// Implementar chamadas de API real nos métodos abaixo
class DadosAulas {
  final List<Aula> _aulas = [];

  Future<void> _aguardar() => Future.delayed(const Duration(milliseconds: 400));

  /// Lista todas as aulas
  /// TODO: Implementar chamada GET para API de aulas
  Future<List<Aula>> listar() async {
    await _aguardar();
    return List.unmodifiable(_aulas);
  }

  /// Busca aula por ID
  /// TODO: Implementar chamada GET para API de aulas/{id}
  Future<Aula?> buscarPorId(String id) async {
    await _aguardar();
    try {
      return _aulas.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Salva aula (cria ou atualiza)
  /// TODO: Implementar chamada POST/PUT para API de aulas
  Future<Aula> salvar(Aula aula, {bool criando = false}) async {
    await _aguardar();
    if (aula.nome.trim().isEmpty) {
      throw Exception('Informe o nome da aula.');
    }
    if (criando) {
      _aulas.add(aula);
    } else {
      final i = _aulas.indexWhere((a) => a.id == aula.id);
      if (i >= 0) _aulas[i] = aula;
    }
    return aula;
  }

  /// Remove aula
  /// TODO: Implementar chamada DELETE para API de aulas/{id}
  Future<void> remover(String id) async {
    await _aguardar();
    _aulas.removeWhere((a) => a.id == id);
  }
}
