import 'package:fluire/models/aula.dart';
import 'package:fluire/repositories/aula_repository.dart';

class AulaService {
  final AulaRepository _repository;

  AulaService(this._repository);

  Future<List<Aula>> listar() => _repository.listar();

  Future<Aula?> buscarPorId(String id) => _repository.buscarPorId(id);

  Future<Aula> salvar(Aula aula, {bool criando = false}) {
    if (aula.nome.trim().isEmpty) {
      throw Exception('Informe o nome da aula.');
    }
    if (aula.professorId.isEmpty) {
      throw Exception('Selecione um professor.');
    }
    return criando ? _repository.criar(aula) : _repository.atualizar(aula);
  }

  Future<void> remover(String id) => _repository.remover(id);
}
