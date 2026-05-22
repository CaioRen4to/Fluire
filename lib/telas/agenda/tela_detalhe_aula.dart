import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/providers/aluno_provider.dart';
import 'package:fluire/providers/aula_provider.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/widgets/layout_tela.dart';
import 'package:fluire/componentes/botao/botao.dart';
import 'package:fluire/core/animacoes.dart';
import 'package:fluire/telas/agenda/modal_formulario_aula.dart';

class TelaDetalheAula extends StatelessWidget {
  final String aulaId;

  const TelaDetalheAula({super.key, required this.aulaId});

  @override
  Widget build(BuildContext context) {
    final aula = context.watch<AulaProvider>().buscarLocal(aulaId);
    final alunos = context.watch<AlunoProvider>().alunos;

    if (aula == null) {
      return LayoutTela(
        titulo: 'Aula',
        rotaAtual: Rotas.agenda,
        child: const Center(child: Text('Aula não encontrada')),
      );
    }

    final participantes = alunos.where((a) => aula.alunoIds.contains(a.id)).toList();

    return LayoutTela(
      titulo: 'Detalhes da aula',
      rotaAtual: Rotas.agenda,
      centralizarConteudo: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Animacoes.fadeSlide(
              child: Container(
                padding: AppSpacing.cardPaddingLarge,
                decoration: BoxDecoration(
                  borderRadius: AppBorders.radiusXXLarge,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withValues(alpha: 0.75),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aula.nome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    AppSpacing.gapSm,
                    Text(
                      '${aula.professorNome} · ${aula.horario}',
                      style: TextStyle(color: AppColors.primariaClara),
                    ),
                    AppSpacing.gapMd,
                    Text(aula.frequencia, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    AppSpacing.gapSm,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: AppBorders.radiusLarge,
                      ),
                      child: Text(aula.statusLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.gapXl,
            BotaoPrimario(
              texto: 'Editar aula',
              icone: Icons.edit_outlined,
              onPressed: () => ModalFormularioAula.abrir(context: context, aula: aula),
            ),
            AppSpacing.gapMd,
            BotaoSecundario(
              texto: 'Abrir frequência',
              icone: Icons.fact_check_outlined,
              onPressed: () => Navigator.pushNamed(
                context,
                Rotas.frequenciaTotem,
                arguments: aula,
              ),
            ),
            AppSpacing.gapXl,
            Text('Participantes (${participantes.length})', style: AppTypography.headline),
            AppSpacing.gapMd,
            if (participantes.isEmpty)
              Text('Nenhum aluno vinculado.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textoSecundario))
            else
              ...participantes.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    tileColor: AppColors.fundoCard,
                    shape: RoundedRectangleBorder(borderRadius: AppBorders.radiusLarge),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      child: Text(a.inicial, style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(a.nome),
                    subtitle: Text(a.modalidade),
                  ),
                ),
              ),
            AppSpacing.gapXxl,
          ],
        ),
      ),
    );
  }
}
