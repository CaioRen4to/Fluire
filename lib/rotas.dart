import 'package:flutter/material.dart';
import 'package:fluire/telas/login/tela_login.dart';
import 'package:fluire/telas/login/tela_cadastro.dart';
import 'package:fluire/telas/painel/tela_painel.dart';
import 'package:fluire/telas/professores/tela_gestao_professores.dart';

class Rotas {

  static const String login = '/login';
  static const String home = '/home';
  static const String cadastro = '/cadastro';
  static const String painel = '/painel';
  static const String professores = '/professores';
  

  static Map<String, WidgetBuilder> get rotas => {
    login: (context) => const TelaLogin(),
    cadastro: (context) => const TelaCadastro(),
    painel: (context) => const DashboardScreen(),
    professores: (conext) => const ProfessoresPage()
  };
}