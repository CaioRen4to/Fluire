import 'package:flutter/material.dart';
import 'package:fluire/utils/animacoes.dart';
import 'package:fluire/models/aluno.dart';
import 'package:fluire/models/aula.dart';
import 'package:fluire/screens/login/tela_login.dart';
import 'package:fluire/screens/login/tela_cadastro.dart';
import 'package:fluire/screens/login/tela_recuperar_senha.dart';
import 'package:fluire/screens/login/tela_validar_codigo_senha.dart';
import 'package:fluire/screens/dashboard/tela_dashboard.dart';
import 'package:fluire/screens/alunos/tela_gestao_alunos.dart';
import 'package:fluire/screens/alunos/tela_detalhe_aluno.dart';
import 'package:fluire/screens/frequencia/tela_frequencia_totem.dart';
import 'package:fluire/screens/aulas/tela_aulas.dart';
import 'package:fluire/screens/aulas/tela_detalhe_aulas.dart';
import 'package:fluire/screens/historico/tela_historico_frequencia.dart';
import 'package:fluire/screens/professores/tela_gestao_professores.dart';
import 'package:fluire/screens/perfil/tela_perfil.dart';

/// Rotas nomeadas do aplicativo.
class AppRoutes {
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String recuperarSenha = '/recuperar_senha';
  static const String dashboard = '/dashboard';
  static const String alunos = '/alunos';
  static const String aulas = '/aulas';
  static const String detalheAluno = '/detalhe_aluno';
  static const String detalheAula = '/detalhe_aula';
  static const String frequenciaTotem = '/frequencia_totem';
  static const String historico = '/historico';
  static const String professores = '/professores';
  static const String perfil = '/perfil';
  static const String agenda = '/agenda';
  static const String validarCodigoSenha = '/validar_codigo_senha';

  static const rotasPublicas = {login, cadastro, recuperarSenha, validarCodigoSenha};

  static const rotasComBottomNav = {dashboard, aulas, alunos, historico, perfil};

  static Map<String, WidgetBuilder> get rotas => {
        login: (_) => const TelaLogin(),
        cadastro: (_) => const TelaCadastro(),
        recuperarSenha: (_) => const TelaRecuperarSenha(),
        dashboard: (_) => const DashboardScreen(),
        alunos: (_) => const TelaGestaoAlunos(),
        aulas: (_) => const TelaAulas(),
        historico: (_) => const TelaHistoricoFrequencia(),
        professores: (_) => const TelaProfessores(),
        perfil: (_) => const TelaPerfil(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case detalheAluno:
        final arg = settings.arguments;
        if (arg is Aluno) {
          return rotaComFade(TelaDetalheAluno(aluno: arg));
        }
        return rotaComFade(const TelaGestaoAlunos());
      case detalheAula:
        final id = settings.arguments;
        if (id is String) {
          return rotaComFade(TelaDetalheAulas(aulaId: id));
        }
        return rotaComFade(const TelaDetalheAulas(aulaId: ''));
      case frequenciaTotem:
        final arg = settings.arguments;
        return rotaComFade(
          TelaFrequenciaTotem(
            aula: arg is Aula ? arg : null,
          ),
        );
      case validarCodigoSenha:
        final email = settings.arguments;
        if (email is String) {
          return rotaComFade(TelaValidarCodigoSenha(email: email));
        }
        return rotaComFade(const TelaValidarCodigoSenha(email: ''));
      default:
        return null;
    }
  }

  static Route<dynamic> rotaProtegida(RouteSettings settings, Widget page) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => page,
    );
  }
}
