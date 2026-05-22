import 'package:fluire/dados/mock_dados.dart';
import 'package:fluire/models/aluno.dart';
import 'package:fluire/repositories/aluno_repository.dart';

class MockAlunoRepository implements AlunoRepository {
  final List<Aluno> _alunos = List.from(MockDados.alunos);

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 400));

  @override
  Future<List<Aluno>> listar() async {
    await _delay();
    return List.unmodifiable(_alunos);
  }

  @override
  Future<Aluno?> buscarPorId(String id) async {
    await _delay();
    try {
      return _alunos.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Aluno> criar(Aluno aluno) async {
    await _delay();
    _alunos.add(aluno);
    return aluno;
  }

  @override
  Future<Aluno> atualizar(Aluno aluno) async {
    await _delay();
    final i = _alunos.indexWhere((a) => a.id == aluno.id);
    if (i >= 0) _alunos[i] = aluno;
    return aluno;
  }

  @override
  Future<void> remover(String id) async {
    await _delay();
    _alunos.removeWhere((a) => a.id == id);
  }
}
