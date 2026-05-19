import 'package:flutter/material.dart';

class appColors{
  //cores primarias:
  static const Color primaryColor = Color.fromARGB(255, 236, 163, 29);
  //variação mais clara da cor primária — hover, estados selecionados
  static const Color primariaClara = Color.fromARGB(134, 237, 202, 138);

  //fundo principal das telas
  static const Color backgroundColor = Color.fromARGB(255, 244, 220, 180); 
  //fundo de cards ou qualquer parada elevada
  static const Color fundoCard = Color.fromARGB(202, 243, 242, 242);
  //fundo da bottom bar com efeito blur
  static const Color fundoBottomBar = Color.fromARGB(110, 238, 208, 132);
  
  //texto primário — títulos e conteúdo principal
  static const Color textoPrimario = Color.fromARGB(255, 48, 44, 29);
  //texto secundário — subtítulos, labels, descrições
  static const Color textoSecundario = Color.fromARGB(255, 138, 131, 108);
  //texto sobre fundo escuro (branco)
  static const Color textoClaro = Color.fromARGB(255, 248, 248, 248);

  //pop-up destaques, badges, notificações
  static const Color pop_up = Color.fromARGB(255, 170, 163, 101);

  //divisores e bordas sutis
  static const Color divisor = Color.fromARGB(255, 248, 242, 161);
  //sombra suave para elevação
  static const Color sombra = Color.fromARGB(42, 48, 48, 39);
  //icone ativo na bottom
  static const Color iconsAtivosColor = Color.fromARGB(172, 231, 201, 94);
  //icone inativo na bottom, meio intuitivo
  static const Color iconsInativosColor = Color.fromARGB(172, 237, 233, 220);

  //botão de presente (usuario - totem)
  static const Color Botao_presente = Color.fromARGB(219, 131, 185, 5);
  //botao de falta (usuario - totem)
  static const Color Botao_falta = Color.fromARGB(208, 237, 114, 20);

  //sucesso — confirmações, presença marcada
  static const Color sucesso = Color(0xFF6DB89A);
  //alerta — atenção, pendências
  static const Color alerta = Color(0xFFE8C57A);
  //erro — falhas, ausências
  static const Color erro = Color(0xFFE87A7A);
}