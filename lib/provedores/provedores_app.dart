import 'package:provider/provider.dart';
import 'package:fluire/provedores/provedor_auth.dart';
import 'package:fluire/provedores/provedor_alunos.dart';
import 'package:fluire/provedores/provedor_aulas.dart';
import 'package:fluire/services/auth_service.dart';
import 'package:fluire/services/alunos_service.dart';
import 'package:fluire/services/aulas_service.dart';

class ProvedoresApp {
  static List<ChangeNotifierProvider> get providers {
    return [
      ChangeNotifierProvider<ProvedorAuth>(
        create: (_) => ProvedorAuth(AuthService()),
      ),
      ChangeNotifierProvider<ProvedorAlunos>(
        create: (_) => ProvedorAlunos(AlunosService()),
      ),
      ChangeNotifierProvider<ProvedorAulas>(
        create: (_) => ProvedorAulas(AulasService()),
      ),
    ];
  }
}
