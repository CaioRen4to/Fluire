import 'package:flutter/material.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/core/responsivo.dart';
import 'package:fluire/widgets/menu_lateral.dart';
import 'package:fluire/componentes/cabecalho/cabecalho_tela.dart';

class LayoutTela extends StatelessWidget {
  final String titulo;
  final Widget child;
  final String? rotaAtual;
  final bool mostrarMenu;
  final Widget? acaoFlutuante;
  final bool centralizarConteudo;
  final PreferredSizeWidget? appBarCustom;

  const LayoutTela({
    super.key,
    required this.titulo,
    required this.child,
    this.rotaAtual,
    this.mostrarMenu = true,
    this.acaoFlutuante,
    this.centralizarConteudo = true,
    this.appBarCustom,
  });

  @override
  Widget build(BuildContext context) {
    final padding = Responsivo.paddingTela(context);
    final conteudo = centralizarConteudo
        ? Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsivo.larguraConteudo(context) + 80),
              child: child,
            ),
          )
        : child;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: mostrarMenu && rotaAtual != null
          ? MenuLateral(rotaAtual: rotaAtual)
          : null,
      floatingActionButton: acaoFlutuante,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (appBarCustom != null)
              appBarCustom!
            else
              CabecalhoTela(
                titulo: titulo,
                mostrarMenu: mostrarMenu,
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: padding.left,
                  right: padding.right,
                  bottom: padding.bottom,
                ),
                child: conteudo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
