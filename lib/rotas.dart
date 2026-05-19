import 'package:flutter/material.dart';
import 'package:fluire/telas/login/tela_login.dart';
import 'package:fluire/telas/login/tela_cadastro.dart';

class Rotas {

  static const String login = '/login';
  static const String home = '/home';
  static const String cadastro = '/cadastro';
  

  static Map<String, WidgetBuilder> get rotas => {
    login: (context) => const TelaLogin(),
    cadastro: (context) => const TelaCadastro()
  };
}