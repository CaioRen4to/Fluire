import 'package:fluire/models/aluno.dart';
import 'package:fluire/repositories/aluno_repository.dart';
import 'package:fluire/repositories/mock/alunos_mock.dart';

class RepositorioAlunoMock implements AlunoRepository {
  final List<Aluno> _alunos = List.from(AlunosMock.lista);

  Future<void> _aguardar() => Future.delayed(const Duration(milliseconds: 400));

  @override
  Future<List<Aluno>> listar() async {
    await _aguardar();
    return List.unmodifiable(_alunos);
  }

  @override
  Future<Aluno?> buscarPorId(String id) async {
    await _aguardar();
    try {
      return _alunos.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Aluno> criar(Aluno aluno) async {
    await _aguardar();
    _alunos.add(aluno);
    return aluno;
  }

  @override
  Future<Aluno> atualizar(Aluno aluno) async {
    await _aguardar();
    final i = _alunos.indexWhere((a) => a.id == aluno.id);
    if (i >= 0) _alunos[i] = aluno;
    return aluno;
  }

  @override
  Future<void> remover(String id) async {
    await _aguardar();
    _alunos.removeWhere((a) => a.id == id);
  }
}
