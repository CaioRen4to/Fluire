import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/core/estado_carregamento.dart';
import 'package:fluire/providers/aluno_provider.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/widgets/layout_tela.dart';
import 'package:fluire/componentes/cards/card_aluno.dart';
import 'package:fluire/componentes/estado_visual/estado_visual.dart';
import 'package:fluire/core/animacoes.dart';
import 'package:fluire/telas/alunos/modal_formulario_aluno.dart';

class TelaGestaoAlunos extends StatefulWidget {
  const TelaGestaoAlunos({super.key});

  @override
  State<TelaGestaoAlunos> createState() => _TelaGestaoAlunosState();
}

class _TelaGestaoAlunosState extends State<TelaGestaoAlunos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlunoProvider>().carregar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlunoProvider>();

    return LayoutTela(
      titulo: 'Alunos',
      rotaAtual: Rotas.alunos,
      centralizarConteudo: false,
      acaoFlutuante: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => ModalFormularioAluno.abrir(context: context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _resumo('${provider.total}', 'Total', AppColors.primaryColor),
              AppSpacing.gapSmHorizontal,
              _resumo('${provider.ativos}', 'Ativos', AppColors.sucesso),
              AppSpacing.gapSmHorizontal,
              _resumo('${provider.total - provider.ativos}', 'Inativos', AppColors.erro),
            ],
          ),
          AppSpacing.gapLg,
          TextField(
            onChanged: provider.definirBusca,
            decoration: InputDecoration(
              hintText: 'Buscar aluno...',
              prefixIcon: const Icon(Icons.search, color: AppColors.popUp),
              filled: true,
              fillColor: AppColors.fundoCard,
              border: OutlineInputBorder(borderRadius: AppBorders.radiusLarge, borderSide: BorderSide.none),
            ),
          ),
          AppSpacing.gapLg,
          Expanded(child: _conteudo(provider)),
        ],
      ),
    );
  }

  Widget _conteudo(AlunoProvider provider) {
    switch (provider.estado) {
      case EstadoCarregamento.carregando:
      case EstadoCarregamento.inicial:
        return const EstadoCarregando(mensagem: 'Carregando alunos...');
      case EstadoCarregamento.erro:
        return EstadoErro(
          mensagem: provider.mensagemErro ?? 'Erro ao carregar',
          onTentarNovamente: provider.carregar,
        );
      case EstadoCarregamento.vazio:
        return EstadoVazio(
          titulo: 'Nenhum aluno cadastrado',
          subtitulo: 'Adicione o primeiro aluno pelo botão +',
          onAcao: () => ModalFormularioAluno.abrir(context: context),
          textoAcao: 'Novo aluno',
        );
      case EstadoCarregamento.sucesso:
        final lista = provider.alunosFiltrados;
        if (lista.isEmpty) {
          return const EstadoVazio(
            titulo: 'Nenhum resultado',
            subtitulo: 'Tente outro termo de busca',
            icone: Icons.search_off,
          );
        }
        return ListView.separated(
          itemCount: lista.length,
          separatorBuilder: (_, _) => AppSpacing.gapMd,
          itemBuilder: (_, i) {
            final aluno = lista[i];
            return Animacoes.fadeSlide(
              delay: Duration(milliseconds: 30 * i),
              child: CardAluno(
                aluno: aluno,
                onTap: () => Navigator.pushNamed(
                  context,
                  Rotas.detalheAluno,
                  arguments: aluno,
                ),
              ),
            );
          },
        );
    }
  }

  Widget _resumo(String valor, String titulo, Color cor) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.fundoCard, borderRadius: AppBorders.radiusLarge),
          child: Column(
            children: [
              Text(valor, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cor)),
              AppSpacing.gapXs,
              Text(titulo, style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario)),
            ],
          ),
        ),
      );
}
