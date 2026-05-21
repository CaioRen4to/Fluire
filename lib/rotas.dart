import 'package:flutter/material.dart';
import 'package:fluire/telas/login/tela_login.dart';
import 'package:fluire/telas/login/tela_cadastro.dart';
import 'package:fluire/telas/painel/tela_painel.dart';

class Rotas {

  static const String login = '/login';
  static const String home = '/home';
  static const String cadastro = '/cadastro';
  static const String painel = '/painel';
  

  static Map<String, WidgetBuilder> get rotas => {
    login: (context) => const TelaLogin(),
    cadastro: (context) => const TelaCadastro(),
    painel: (context) => const DashboardScreen()
  };
}