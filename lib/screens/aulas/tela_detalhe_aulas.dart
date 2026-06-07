import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/providers/provedor_alunos.dart';
import 'package:fluire/providers/provedor_aulas.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/widgets/layout_tela.dart';
import 'package:fluire/widgets/botao/botao.dart';
import 'package:fluire/utils/animacoes.dart';
import 'package:fluire/screens/aulas/modal_formulario_aulas.dart';
import 'package:fluire/widgets/menu_lateral.dart';
import 'package:fluire/models/aula.dart';

class TelaDetalheAulas extends StatelessWidget {
  final String aulaId;

  const TelaDetalheAulas({super.key, required this.aulaId});

  PreferredSizeWidget _appBarComVoltar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textoPrimario),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Detalhes da aula',
        style: AppTypography.displaySmall.copyWith(
          color: AppColors.textoPrimario,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: BotaoMenu(),
        ),
      ],
    );
  }

  void _confirmarRemocao(BuildContext context, Aula aula) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir esta aula?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = context.read<ProvedorAulas>();
              final exito = await provider.remover(aula.id);
              if (context.mounted) {
                if (exito) {
                  Navigator.pop(context); // Voltar para a tela anterior
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Aula excluída com sucesso')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(provider.mensagemErro ?? 'Erro ao excluir aula')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.erro),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final aula = context.watch<ProvedorAulas>().buscarLocal(aulaId);
    final alunos = context.watch<ProvedorAlunos>().alunos;

    if (aula == null) {
      return LayoutTela(
        titulo: 'Aula',
        rotaAtual: AppRoutes.aulas,
        mostrarBottomNav: true,
        child: const Center(child: Text('Aula não encontrada')),
      );
    }

    final participantes = alunos.where((a) => aula.alunoIds.contains(a.id)).toList();

    return LayoutTela(
      titulo: 'Detalhes da aula',
      rotaAtual: AppRoutes.aulas,
      mostrarBottomNav: true,
      appBarCustom: _appBarComVoltar(context),
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
              onPressed: () => ModalFormularioAulas.abrir(context: context, aula: aula),
            ),
            AppSpacing.gapMd,
            BotaoSecundario(
              texto: 'Abrir frequência',
              icone: Icons.fact_check_outlined,
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.frequenciaTotem,
                arguments: aula,
              ),
            ),
            AppSpacing.gapMd,
            Container(
              height: 52,
              child: ElevatedButton(
                onPressed: () => _confirmarRemocao(context, aula),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.erro,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: AppBorders.buttonShape,
                  textStyle: AppTypography.titleLarge,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline, size: 20),
                    SizedBox(width: AppSpacing.sm),
                    Text('Remover aula'),
                  ],
                ),
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
                  child: Material(
                    color: Colors.transparent,
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
              ),
            AppSpacing.gapXxl,
          ],
        ),
      ),
    );
  }
}
