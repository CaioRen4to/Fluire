import 'package:flutter/material.dart';
import 'package:fluire/models/aluno.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/widgets/cards/card_padrao.dart';

class CardAluno extends StatelessWidget {
  final Aluno aluno;
  final VoidCallback? onTap;

  const CardAluno({super.key, required this.aluno, this.onTap});

  @override
  Widget build(BuildContext context) {
    final ativo = aluno.ativo;
    final corStatus = ativo ? AppColors.sucesso : AppColors.erro;

    return CardPadrao(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primaryColor,
            child: Text(
              aluno.inicial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: AppTypography.fontWeightBold,
                fontSize: 18,
              ),
            ),
          ),
          AppSpacing.gapMdHorizontal,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aluno.nome,
                  style: AppTypography.titleMedium.copyWith(color: AppColors.textoPrimario),
                ),
                AppSpacing.gapXs,
                Text(
                  aluno.modalidade,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario),
                ),
                AppSpacing.gapXs,
                Text(
                  '${aluno.presencas} presenças',
                  style: AppTypography.caption.copyWith(color: AppColors.textoSecundario),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(shape: BoxShape.circle, color: corStatus),
              ),
              AppSpacing.gapXs,
              Text(
                ativo ? 'Ativo' : 'Inativo',
                style: AppTypography.caption.copyWith(
                  fontWeight: AppTypography.fontWeightSemiBold,
                  color: corStatus,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
