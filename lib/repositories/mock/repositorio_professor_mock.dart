import 'package:fluire/models/professor.dart';
import 'package:fluire/repositories/professor_repository.dart';
import 'package:fluire/repositories/mock/professores_mock.dart';

class RepositorioProfessorMock implements ProfessorRepository {
  @override
  Future<List<Professor>> listar() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(ProfessoresMock.lista);
  }
}
