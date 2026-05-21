import 'package:flutter/material.dart';
import 'package:fluire/telas/login/tela_login.dart';
import 'package:fluire/telas/login/tela_cadastro.dart';
import 'package:fluire/telas/alunos/tela_gestao_alunos.dart';
import 'package:fluire/telas/alunos/tela_detalhe_aluno.dart';
import 'package:fluire/telas/frequencia/tela_frequencia_totem.dart';
import 'package:fluire/telas/agenda/tela_agenda.dart';


class Rotas {
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String alunos = '/alunos';
  static const String agenda = '/agenda';
  static const String detalheAluno = '/detalhe_aluno';
  static const String frequenciaTotem = '/frequencia_totem';
  

  static Map<String, WidgetBuilder> get rotas => {
        login: (_) => const TelaLogin(),
        cadastro: (_) => const TelaCadastro(),
        alunos: (_) => TelaGestaoAlunos(),
        agenda: (_) => const TelaAgenda(),
        frequenciaTotem: (_) => const TelaFrequenciaTotem(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings s) {
    if (s.name != detalheAluno) return null;
    final aluno = s.arguments;
    return MaterialPageRoute(
      builder: (_) => aluno is Map<String, dynamic>
          ? TelaDetalheAluno(aluno: aluno)
          : TelaGestaoAlunos(),
    );
  }
}
