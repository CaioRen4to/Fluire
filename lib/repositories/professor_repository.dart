import 'package:fluire/models/professor.dart';

abstract class ProfessorRepository {
  Future<List<Professor>> listar();
}
