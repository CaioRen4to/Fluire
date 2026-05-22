import 'package:flutter/material.dart';
import 'package:fluire/models/aluno.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/widgets/layout_tela.dart';
import 'package:fluire/componentes/botao/botao.dart';
import 'package:fluire/core/animacoes.dart';
import 'package:fluire/telas/alunos/modal_formulario_aluno.dart';

class TelaDetalheAluno extends StatelessWidget {
  final Aluno aluno;

  const TelaDetalheAluno({super.key, required this.aluno});

  static const _historico = [
    {'aula': 'Mat Pilates', 'data': '20/05/2026', 'presente': true},
    {'aula': 'Reformer', 'data': '18/05/2026', 'presente': true},
    {'aula': 'Pilates Funcional', 'data': '15/05/2026', 'presente': false},
    {'aula': 'Duet Reformer', 'data': '10/05/2026', 'presente': true},
  ];

  @override
  Widget build(BuildContext context) {
    final ativo = aluno.ativo;
    final corStatus = ativo ? AppColors.sucesso : AppColors.erro;

    return LayoutTela(
      titulo: 'Detalhes',
      rotaAtual: Rotas.alunos,
      centralizarConteudo: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Animacoes.fadeSlide(
              child: Container(
                width: double.infinity,
                padding: AppSpacing.cardPaddingLarge,
                decoration: BoxDecoration(
                  borderRadius: AppBorders.radiusXXLarge,
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.primaryColor.withValues(alpha: 0.7)],
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(aluno.inicial, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    AppSpacing.gapLg,
                    Text(aluno.nome, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    AppSpacing.gapXs,
                    Text(aluno.modalidade, style: TextStyle(color: AppColors.primariaClara)),
                    AppSpacing.gapLg,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: AppBorders.radiusLarge,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: corStatus)),
                          AppSpacing.gapSmHorizontal,
                          Text(ativo ? 'Ativo' : 'Inativo', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.gapLg,
            Row(
              children: [
                Expanded(child: _stat('${aluno.presencas}', 'Presenças', AppColors.sucesso)),
                AppSpacing.gapSmHorizontal,
                Expanded(child: _stat('${aluno.faltas}', 'Faltas', AppColors.erro)),
                AppSpacing.gapSmHorizontal,
                Expanded(child: _stat('${aluno.frequenciaPercentual}%', 'Frequência', AppColors.primaryColor)),
              ],
            ),
            AppSpacing.gapLg,
            BotaoPrimario(
              texto: 'Editar aluno',
              icone: Icons.edit_outlined,
              onPressed: () => ModalFormularioAluno.abrir(context: context, aluno: aluno),
            ),
            AppSpacing.gapLg,
            _bloco(
              'Informações',
              Column(
                children: [
                  _info(Icons.phone, 'Telefone', aluno.telefone),
                  Divider(color: AppColors.divisor),
                  _info(Icons.mail_outline, 'E-mail', aluno.email),
                  Divider(color: AppColors.divisor),
                  _info(Icons.fitness_center, 'Modalidade', aluno.modalidade),
                  if (aluno.ultimaAula != null) ...[
                    Divider(color: AppColors.divisor),
                    _info(Icons.calendar_month, 'Última aula', aluno.ultimaAula!),
                  ],
                ],
              ),
            ),
            AppSpacing.gapLg,
            _bloco(
              'Histórico recente',
              Column(
                children: List.generate(_historico.length, (i) {
                  final h = _historico[i];
                  final ok = h['presente'] == true;
                  final cor = ok ? AppColors.sucesso : AppColors.erro;
                  return Column(
                    children: [
                      if (i > 0) Divider(color: AppColors.divisor),
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(color: cor.withValues(alpha: 0.12), borderRadius: AppBorders.radiusMedium),
                            child: Icon(ok ? Icons.check : Icons.close, color: cor),
                          ),
                          AppSpacing.gapMdHorizontal,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${h['aula']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                Text('${h['data']}', style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario)),
                              ],
                            ),
                          ),
                          Text(ok ? 'Presente' : 'Falta', style: TextStyle(fontWeight: FontWeight.w600, color: cor)),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
            AppSpacing.gapXxl,
          ],
        ),
      ),
    );
  }

  Widget _stat(String valor, String titulo, Color cor) => Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(color: AppColors.fundoCard, borderRadius: AppBorders.radiusLarge),
        child: Column(
          children: [
            Text(valor, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cor)),
            AppSpacing.gapXs,
            Text(titulo, style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario)),
          ],
        ),
      );

  Widget _bloco(String titulo, Widget conteudo) => Container(
        width: double.infinity,
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(color: AppColors.fundoCard, borderRadius: AppBorders.radiusLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: AppTypography.headline),
            AppSpacing.gapLg,
            conteudo,
          ],
        ),
      );

  Widget _info(IconData icon, String titulo, String valor) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryColor),
            AppSpacing.gapMdHorizontal,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario)),
                Text(valor, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      );
}
