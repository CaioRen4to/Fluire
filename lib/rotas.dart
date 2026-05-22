import 'package:flutter/material.dart';
import 'package:fluire/telas/login/tela_login.dart';
import 'package:fluire/telas/login/tela_cadastro.dart';
import 'package:fluire/telas/painel/tela_painel.dart';
import 'package:fluire/telas/alunos/tela_gestao_alunos.dart';
import 'package:fluire/telas/alunos/tela_detalhe_aluno.dart';
import 'package:fluire/telas/frequencia/tela_frequencia_totem.dart';
import 'package:fluire/telas/agenda/tela_agenda.dart';
import 'package:fluire/telas/historico/tela_historico_frequencia.dart';
import 'package:fluire/telas/professores/tela_gestao_professores.dart';

class Rotas {
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String painel = '/painel';
  static const String alunos = '/alunos';
  static const String agenda = '/agenda';
  static const String detalheAluno = '/detalhe_aluno';
  static const String frequenciaTotem = '/frequencia_totem';
  static const String historico = '/historico';
  static const String professores = '/professores';

  static Map<String, WidgetBuilder> get rotas => {
        login: (_) => const TelaLogin(),
        cadastro: (_) => const TelaCadastro(),
        painel: (_) => const DashboardScreen(),
        alunos: (_) => TelaGestaoAlunos(),
        agenda: (_) => const TelaAgenda(),
        historico: (_) => const TelaHistoricoFrequencia(),
        professores: (_) => const TelaProfessores(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings s) {
    switch (s.name) {
      case detalheAluno:
        final aluno = s.arguments;
        return MaterialPageRoute(
          builder: (_) => aluno is Map<String, dynamic>
              ? TelaDetalheAluno(aluno: aluno)
              : TelaGestaoAlunos(),
        );
      case frequenciaTotem:
        final aula = s.arguments;
        return MaterialPageRoute(
          builder: (_) => TelaFrequenciaTotem(
            aula: aula is Map<String, dynamic> ? aula : null,
          ),
        );
      default:
        return null;
    }
  }
}
