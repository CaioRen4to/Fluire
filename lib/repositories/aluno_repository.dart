import 'package:fluire/models/aluno.dart';

abstract class AlunoRepository {
  Future<List<Aluno>> listar();
  Future<Aluno?> buscarPorId(String id);
  Future<Aluno> criar(Aluno aluno);
  Future<Aluno> atualizar(Aluno aluno);
  Future<void> remover(String id);
}
