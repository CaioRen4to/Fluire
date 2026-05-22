import 'package:fluire/dados/mock_dados.dart';
import 'package:fluire/repositories/professor_repository.dart';
import 'package:fluire/models/professor.dart';

class MockProfessorRepository implements ProfessorRepository {
  @override
  Future<List<Professor>> listar() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(MockDados.professores);
  }
}
