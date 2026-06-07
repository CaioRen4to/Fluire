import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/utils/utils.dart';
import 'package:fluire/providers/providers.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/widgets/layout_tela.dart';
import 'package:fluire/widgets/cards/card_aula.dart';
import 'package:fluire/widgets/estado_visual/estado_visual.dart';
import 'package:fluire/widgets/botao/botao.dart';
import 'package:fluire/screens/aulas/modal_formulario_aulas.dart';

class TelaAulas extends StatefulWidget {
  const TelaAulas({super.key});

  @override
  State<TelaAulas> createState() => _TelaAulasState();
}

class _TelaAulasState extends State<TelaAulas> {
  List<Map<String, String>> get _dias {
    const dias = [
      {'dia': 'Seg', 'nome': 'segunda-feira'},
      {'dia': 'Ter', 'nome': 'terça-feira'},
      {'dia': 'Qua', 'nome': 'quarta-feira'},
      {'dia': 'Qui', 'nome': 'quinta-feira'},
      {'dia': 'Sex', 'nome': 'sexta-feira'},
      {'dia': 'Sáb', 'nome': 'sábado'},
      {'dia': 'Dom', 'nome': 'domingo'},
    ];
    final hoje = DateTime.now();
    final inicio = hoje.subtract(Duration(days: hoje.weekday - 1));
    return List.generate(7, (i) {
      final data = inicio.add(Duration(days: i));
      return {
        'dia': dias[i]['dia']!,
        'nome': dias[i]['nome']!,
        'numero': data.day.toString(),
      };
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProvedorAulas>().carregar();
      context.read<ProvedorAlunos>().carregar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProvedorAulas>();

    return LayoutTela(
      titulo: 'Aulas',
      rotaAtual: AppRoutes.aulas,
      mostrarBottomNav: true,
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
                final selecionado = provider.diaSelecionado == item['nome']!;
                return GestureDetector(
                  onTap: () => provider.definirDia(item['nome']!),
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
            onPressed: () => ModalFormularioAulas.abrir(context: context),
          ),
        ],
      ),
    );
  }

  Widget _lista(ProvedorAulas provider) {
    switch (provider.estado) {
      case EstadoCarregamento.carregando:
      case EstadoCarregamento.inicial:
        return const EstadoCarregando(mensagem: 'Carregando aulas...');
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
          onAcao: () => ModalFormularioAulas.abrir(context: context),
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
                  AppRoutes.detalheAula,
                  arguments: aula.id,
                ),
                onFrequencia: () => Navigator.pushNamed(
                  context,
                  AppRoutes.frequenciaTotem,
                  arguments: aula,
                ),
                onEditar: () => ModalFormularioAulas.abrir(context: context, aula: aula),
              ),
            );
          },
        );
    }
  }
}
