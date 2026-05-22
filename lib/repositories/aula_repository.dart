import 'package:fluire/models/aula.dart';

abstract class AulaRepository {
  Future<List<Aula>> listar();
  Future<Aula?> buscarPorId(String id);
  Future<Aula> criar(Aula aula);
  Future<Aula> atualizar(Aula aula);
  Future<void> remover(String id);
}
