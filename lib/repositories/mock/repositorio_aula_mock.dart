import 'package:fluire/models/aula.dart';
import 'package:fluire/repositories/aula_repository.dart';
import 'package:fluire/repositories/mock/aulas_mock.dart';

class RepositorioAulaMock implements AulaRepository {
  final List<Aula> _aulas = List.from(AulasMock.lista);

  Future<void> _aguardar() => Future.delayed(const Duration(milliseconds: 400));

  @override
  Future<List<Aula>> listar() async {
    await _aguardar();
    return List.unmodifiable(_aulas);
  }

  @override
  Future<Aula?> buscarPorId(String id) async {
    await _aguardar();
    try {
      return _aulas.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Aula> criar(Aula aula) async {
    await _aguardar();
    _aulas.add(aula);
    return aula;
  }

  @override
  Future<Aula> atualizar(Aula aula) async {
    await _aguardar();
    final i = _aulas.indexWhere((a) => a.id == aula.id);
    if (i >= 0) _aulas[i] = aula;
    return aula;
  }

  @override
  Future<void> remover(String id) async {
    await _aguardar();
    _aulas.removeWhere((a) => a.id == id);
  }
}
