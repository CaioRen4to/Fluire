import 'package:flutter/material.dart';
import 'package:fluire/tema/tema.dart';
import 'package:fluire/componentes/botao/botao.dart';

class EstadoCarregando extends StatelessWidget {
  final String? mensagem;

  const EstadoCarregando({super.key, this.mensagem});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primaryColor),
          if (mensagem != null) ...[
            AppSpacing.gapLg,
            Text(
              mensagem!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textoSecundario),
            ),
          ],
        ],
      ),
    );
  }
}

class EstadoVazio extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final IconData icone;
  final VoidCallback? onAcao;
  final String? textoAcao;

  const EstadoVazio({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.icone = Icons.inbox_outlined,
    this.onAcao,
    this.textoAcao,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 64, color: AppColors.textoSecundario.withValues(alpha: 0.5)),
            AppSpacing.gapLg,
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: AppTypography.headline.copyWith(color: AppColors.textoPrimario),
            ),
            if (subtitulo != null) ...[
              AppSpacing.gapSm,
              Text(
                subtitulo!,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textoSecundario),
              ),
            ],
            if (onAcao != null && textoAcao != null) ...[
              AppSpacing.gapXl,
              BotaoPrimario(texto: textoAcao!, onPressed: onAcao, expandido: false),
            ],
          ],
        ),
      ),
    );
  }
}

class EstadoErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback? onTentarNovamente;

  const EstadoErro({
    super.key,
    required this.mensagem,
    this.onTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.erro),
            AppSpacing.gapLg,
            Text(
              'Algo deu errado',
              style: AppTypography.headline.copyWith(color: AppColors.textoPrimario),
            ),
            AppSpacing.gapSm,
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textoSecundario),
            ),
            if (onTentarNovamente != null) ...[
              AppSpacing.gapXl,
              BotaoPrimario(
                texto: 'Tentar novamente',
                icone: Icons.refresh,
                onPressed: onTentarNovamente,
                expandido: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
