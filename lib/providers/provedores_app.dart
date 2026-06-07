import 'package:provider/provider.dart';
import 'package:fluire/providers/provedor_auth.dart';
import 'package:fluire/providers/provedor_alunos.dart';
import 'package:fluire/providers/provedor_aulas.dart';
import 'package:fluire/providers/provedor_dashboard.dart';
import 'package:fluire/services/auth_service.dart';
import 'package:fluire/services/alunos_service.dart';
import 'package:fluire/services/aulas_service.dart';
import 'package:fluire/services/usuarios_service.dart';
import 'package:fluire/services/dashboard_service.dart';

class ProvedoresApp {
  static List<ChangeNotifierProvider> providers({AuthService? authService}) {
    final auth = authService ?? AuthService();
    return [
      ChangeNotifierProvider<ProvedorAuth>(
        create: (_) => ProvedorAuth(auth, usuarioInicial: auth.usuarioAtual),
      ),
      ChangeNotifierProvider<ProvedorAlunos>(
        create: (_) => ProvedorAlunos(AlunosService()),
      ),
      ChangeNotifierProvider<ProvedorAulas>(
        create: (_) => ProvedorAulas(AulasService(), UsuariosService()),
      ),
      ChangeNotifierProvider<ProvedorDashboard>(
        create: (_) => ProvedorDashboard(DashboardService(), AulasService()),
      ),
    ];
  }
}
