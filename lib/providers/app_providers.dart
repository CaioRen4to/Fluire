import 'package:provider/provider.dart';
import 'package:fluire/providers/auth_provider.dart';
import 'package:fluire/providers/aluno_provider.dart';
import 'package:fluire/providers/aula_provider.dart';
import 'package:fluire/repositories/mock/mock_auth_repository.dart';
import 'package:fluire/repositories/mock/mock_aluno_repository.dart';
import 'package:fluire/repositories/mock/mock_aula_repository.dart';
import 'package:fluire/repositories/mock/mock_professor_repository.dart';
import 'package:fluire/services/auth_service.dart';
import 'package:fluire/services/aluno_service.dart';
import 'package:fluire/services/aula_service.dart';

class AppProviders {
  static List<ChangeNotifierProvider> get providers {
    final authRepo = MockAuthRepository();
    final alunoRepo = MockAlunoRepository();
    final aulaRepo = MockAulaRepository();
    final profRepo = MockProfessorRepository();

    return [
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(AuthService(authRepo)),
      ),
      ChangeNotifierProvider<AlunoProvider>(
        create: (_) => AlunoProvider(AlunoService(alunoRepo)),
      ),
      ChangeNotifierProvider<AulaProvider>(
        create: (_) => AulaProvider(AulaService(aulaRepo), profRepo),
      ),
    ];
  }
}
