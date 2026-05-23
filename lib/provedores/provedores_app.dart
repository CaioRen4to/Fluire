import 'package:provider/provider.dart';
import 'package:fluire/provedores/provedor_auth.dart';
import 'package:fluire/provedores/provedor_alunos.dart';
import 'package:fluire/provedores/provedor_aulas.dart';
import 'package:fluire/dados/dados_auth.dart';
import 'package:fluire/dados/dados_alunos.dart';
import 'package:fluire/dados/dados_aulas.dart';
import 'package:fluire/dados/dados_professores.dart';

class ProvedoresApp {
  static List<ChangeNotifierProvider> get providers {
    return [
      ChangeNotifierProvider<ProvedorAuth>(
        create: (_) => ProvedorAuth(DadosAuth()),
      ),
      ChangeNotifierProvider<ProvedorAlunos>(
        create: (_) => ProvedorAlunos(DadosAlunos()),
      ),
      ChangeNotifierProvider<ProvedorAulas>(
        create: (_) => ProvedorAulas(DadosAulas(), DadosProfessores()),
      ),
    ];
  }
}
