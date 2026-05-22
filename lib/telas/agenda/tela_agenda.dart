import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/core/estado_carregamento.dart';
import 'package:fluire/providers/aluno_provider.dart';
import 'package:fluire/providers/aula_provider.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/widgets/layout_tela.dart';
import 'package:fluire/componentes/card_aula.dart';
import 'package:fluire/componentes/estado_visual.dart';
import 'package:fluire/componentes/botao.dart';
import 'package:fluire/core/animacoes.dart';
import 'package:fluire/telas/agenda/modal_formulario_aula.dart';

class TelaAgenda extends StatefulWidget {
  const TelaAgenda({super.key});

  @override
  State<TelaAgenda> createState() => _TelaAgendaState();
}

class _TelaAgendaState extends State<TelaAgenda> {
  final List<Map<String, String>> _dias = [
    {'dia': 'Seg', 'numero': '19', 'idx': '1'},
    {'dia': 'Ter', 'numero': '20', 'idx': '2'},
    {'dia': 'Qua', 'numero': '21', 'idx': '3'},
    {'dia': 'Qui', 'numero': '22', 'idx': '4'},
    {'dia': 'Sex', 'numero': '23', 'idx': '5'},
    {'dia': 'Sáb', 'numero': '24', 'idx': '6'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AulaProvider>().carregar();
      context.read<AlunoProvider>().carregar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AulaProvider>();

    return LayoutTela(
      titulo: 'Agenda',
      rotaAtual: Rotas.agenda,
      centralizarConteudo: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 84,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dias.length,
              itemBuilder: (context, index) {
                final item = _dias[index];
                final diaIdx = int.parse(item['idx']!);
                final selecionado = provider.diaSelecionado == diaIdx;
                return GestureDetector(
                  onTap: () => provider.definirDia(diaIdx),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 68,
                    margin: const EdgeInsets.only(right: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: selecionado ? AppColors.primaryColor : AppColors.fundoCard,
                      borderRadius: AppBorders.radiusLarge,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['dia']!,
                          style: TextStyle(
                            color: selecionado ? AppColors.textoClaro : AppColors.textoSecundario,
                          ),
                        ),
                        AppSpacing.gapSm,
                        Text(
                          item['numero']!,
                          style: TextStyle(
                            fontSize: AppTypography.fontSizeH3,
                            fontWeight: FontWeight.bold,
                            color: selecionado ? AppColors.textoClaro : AppColors.textoPrimario,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          AppSpacing.gapLg,
          TextField(
            onChanged: provider.definirBusca,
            decoration: InputDecoration(
              hintText: 'Buscar aula ou professor',
              filled: true,
              fillColor: AppColors.fundoCard,
              prefixIcon: const Icon(Icons.search, color: AppColors.textoSecundario),
              border: OutlineInputBorder(borderRadius: AppBorders.radiusLarge, borderSide: BorderSide.none),
            ),
          ),
          AppSpacing.gapLg,
          Expanded(child: _lista(provider)),
          AppSpacing.gapMd,
          BotaoPrimario(
            texto: 'Nova aula',
            icone: Icons.add,
            onPressed: () => ModalFormularioAula.abrir(context: context),
          ),
        ],
      ),
    );
  }

  Widget _lista(AulaProvider provider) {
    switch (provider.estado) {
      case EstadoCarregamento.carregando:
      case EstadoCarregamento.inicial:
        return const EstadoCarregando(mensagem: 'Carregando agenda...');
      case EstadoCarregamento.erro:
        return EstadoErro(
          mensagem: provider.mensagemErro ?? 'Erro',
          onTentarNovamente: provider.carregar,
        );
      case EstadoCarregamento.vazio:
        return EstadoVazio(
          titulo: 'Nenhuma aula neste dia',
          subtitulo: 'Crie uma nova aula para começar',
          icone: Icons.event_busy,
          onAcao: () => ModalFormularioAula.abrir(context: context),
          textoAcao: 'Nova aula',
        );
      case EstadoCarregamento.sucesso:
        final lista = provider.aulasFiltradas;
        if (lista.isEmpty) {
          return const EstadoVazio(
            titulo: 'Sem aulas para este dia',
            subtitulo: 'Selecione outro dia ou crie uma aula',
            icone: Icons.event_note_outlined,
          );
        }
        return ListView.separated(
          itemCount: lista.length,
          separatorBuilder: (_, _) => AppSpacing.gapLg,
          itemBuilder: (_, i) {
            final aula = lista[i];
            return Animacoes.fadeSlide(
              delay: Duration(milliseconds: 40 * i),
              child: CardAula(
                aula: aula,
                totalAlunos: aula.alunoIds.length,
                onDetalhes: () => Navigator.pushNamed(
                  context,
                  Rotas.detalheAula,
                  arguments: aula.id,
                ),
                onFrequencia: () => Navigator.pushNamed(
                  context,
                  Rotas.frequenciaTotem,
                  arguments: aula,
                ),
                onEditar: () => ModalFormularioAula.abrir(context: context, aula: aula),
              ),
            );
          },
        );
    }
  }
}
