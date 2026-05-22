import 'package:fluire/models/aluno.dart';
import 'package:fluire/repositories/aluno_repository.dart';

class AlunoService {
  final AlunoRepository _repository;

  AlunoService(this._repository);

  Future<List<Aluno>> listar() => _repository.listar();

  Future<Aluno?> buscarPorId(String id) => _repository.buscarPorId(id);

  Future<Aluno> salvar(Aluno aluno, {bool criando = false}) {
    if (aluno.nome.trim().isEmpty) {
      throw Exception('Informe o nome do aluno.');
    }
    return criando ? _repository.criar(aluno) : _repository.atualizar(aluno);
  }

  Future<void> remover(String id) => _repository.remover(id);
}
