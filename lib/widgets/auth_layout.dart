import 'package:flutter/material.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/tema/app_sombras.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/core/responsivo.dart';
import 'package:fluire/core/animacoes.dart';

class AuthLayout extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final Widget child;
  final Widget? rodape;

  const AuthLayout({
    super.key,
    required this.titulo,
    required this.subtitulo,
    this.rodape,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final largura = Responsivo.larguraConteudo(context).clamp(320.0, 420.0);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: Responsivo.paddingTela(context),
          child: Animacoes.fadeSlide(
            child: Container(
              width: largura,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.xxxl,
              ),
              decoration: BoxDecoration(
                color: AppColors.fundoCard,
                borderRadius: AppBorders.radiusLarge,
                boxShadow: AppShadows.elevatedShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.primariaClara,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.waves,
                      color: AppColors.primaryColor,
                      size: 32,
                    ),
                  ),
                  AppSpacing.gapXl,
                  Text(
                    titulo,
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.textoPrimario,
                    ),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    subtitulo,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textoSecundario,
                    ),
                  ),
                  AppSpacing.gapXxl,
                  child,
                  if (rodape != null) ...[
                    AppSpacing.gapLg,
                    rodape!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
