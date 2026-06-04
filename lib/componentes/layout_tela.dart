import 'package:flutter/material.dart';
import 'package:fluire/tema/tema.dart';
import 'package:fluire/util/responsivo.dart';
import 'package:fluire/componentes/cabecalho/cabecalho_tela.dart';
import 'package:fluire/componentes/menu_lateral.dart';
import 'package:fluire/widgets/app_bottom_nav.dart';

class LayoutTela extends StatelessWidget {
  final String titulo;
  final Widget child;
  final String? rotaAtual;
  final bool mostrarBottomNav;
  final Widget? acaoFlutuante;
  final bool centralizarConteudo;
  final PreferredSizeWidget? appBarCustom;

  const LayoutTela({
    super.key,
    required this.titulo,
    required this.child,
    this.rotaAtual,
    this.mostrarBottomNav = false,
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

    final indiceBottomNav =
        mostrarBottomNav && rotaAtual != null ? AppBottomNav.indiceDaRota(rotaAtual) : null;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: rotaAtual != null && mostrarBottomNav ? MenuLateral(rotaAtual: rotaAtual) : null,
      floatingActionButton: acaoFlutuante,
      bottomNavigationBar: indiceBottomNav != null
          ? AppBottomNav(indiceAtual: indiceBottomNav)
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (appBarCustom != null)
              appBarCustom!
            else
              CabecalhoTela(
                titulo: titulo,
                mostrarMenu: true,
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
