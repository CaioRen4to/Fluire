import 'package:flutter/material.dart';
import 'package:fluire/models/models.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/widgets/botao/botao.dart';
import 'package:fluire/widgets/cards/card_padrao.dart';

class CardAula extends StatelessWidget {
  final Aula aula;
  final int totalAlunos;
  final VoidCallback? onDetalhes;
  final VoidCallback? onFrequencia;
  final VoidCallback? onEditar;

  const CardAula({
    super.key,
    required this.aula,
    this.totalAlunos = 0,
    this.onDetalhes,
    this.onFrequencia,
    this.onEditar,
  });

  Color get _corStatus {
    switch (aula.status) {
      case StatusAula.emAndamento:
        return AppColors.alerta;
      case StatusAula.proxima:
        return AppColors.sucesso;
      case StatusAula.concluida:
        return AppColors.textoSecundario;
      case StatusAula.cancelada:
        return AppColors.erro;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardPadrao(
      padding: AppSpacing.cardPaddingLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  aula.nome,
                  style: AppTypography.displaySmall.copyWith(color: AppColors.textoPrimario),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: _corStatus.withValues(alpha: 0.85),
                  borderRadius: AppBorders.radiusLarge,
                ),
                child: Text(
                  aula.statusLabel,
                  style: TextStyle(
                    color: AppColors.textoClaro,
                    fontWeight: AppTypography.fontWeightBold,
                    fontSize: AppTypography.fontSizeSm,
                  ),
                ),
              ),
              if (onEditar != null) ...[
                AppSpacing.gapSmHorizontal,
                IconButton(
                  onPressed: onEditar,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  color: AppColors.textoSecundario,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ],
          ),
          AppSpacing.gapSm,
          Text(aula.professorNome, style: TextStyle(color: AppColors.textoSecundario)),
          AppSpacing.gapXs,
          Text(aula.frequencia, style: AppTypography.caption.copyWith(color: AppColors.textoSecundario)),
          AppSpacing.gapLg,
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: AppColors.textoSecundario),
              AppSpacing.gapSmHorizontal,
              Text(aula.horario),
              AppSpacing.gapLgHorizontal,
              Icon(Icons.people_outline, size: 18, color: AppColors.textoSecundario),
              AppSpacing.gapSmHorizontal,
              Text('$totalAlunos alunos'),
            ],
          ),
          AppSpacing.gapLg,
          Row(
            children: [
              Expanded(
                child: BotaoSecundario(
                  texto: 'Detalhes',
                  expandido: true,
                  onPressed: onDetalhes,
                ),
              ),
              AppSpacing.gapMdHorizontal,
              Expanded(
                child: BotaoPrimario(
                  texto: 'Frequência',
                  expandido: true,
                  onPressed: onFrequencia,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
