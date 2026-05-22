import 'package:provider/provider.dart';
import 'package:fluire/providers/auth_provider.dart';
import 'package:fluire/providers/aluno_provider.dart';
import 'package:fluire/providers/aula_provider.dart';
import 'package:fluire/repositories/mock/repositorio_auth_mock.dart';
import 'package:fluire/repositories/mock/repositorio_aluno_mock.dart';
import 'package:fluire/repositories/mock/repositorio_aula_mock.dart';
import 'package:fluire/repositories/mock/repositorio_professor_mock.dart';
import 'package:fluire/services/auth_service.dart';
import 'package:fluire/services/aluno_service.dart';
import 'package:fluire/services/aula_service.dart';

class AppProviders {
  static List<ChangeNotifierProvider> get providers {
    final authRepo = RepositorioAuthMock();
    final alunoRepo = RepositorioAlunoMock();
    final aulaRepo = RepositorioAulaMock();
    final profRepo = RepositorioProfessorMock();

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
