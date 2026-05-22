import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/core/animacoes.dart';
import 'package:fluire/providers/aluno_provider.dart';
import 'package:fluire/providers/aula_provider.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/tema/app_sombras.dart';
import 'package:fluire/widgets/layout_tela.dart';
import 'package:fluire/componentes/card_padrao.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedDayIndex = 3;

  final List<Map<String, dynamic>> weeklyFrequency = [
    {'day': 'Seg', 'value': 40},
    {'day': 'Ter', 'value': 55},
    {'day': 'Qua', 'value': 35},
    {'day': 'Qui', 'value': 70},
    {'day': 'Sex', 'value': 50},
    {'day': 'Sáb', 'value': 25},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlunoProvider>().carregar();
      context.read<AulaProvider>().carregar();
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alunos = context.watch<AlunoProvider>();
    final aulas = context.watch<AulaProvider>();
    final hoje = aulas.aulas.take(3).toList();

    return LayoutTela(
      titulo: 'Painel',
      rotaAtual: Rotas.painel,
      centralizarConteudo: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Animacoes.fadeSlide(
              child: Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      title: 'Total de alunos',
                      value: '${alunos.total}',
                      icon: Icons.people_outline,
                      iconColor: AppColors.primaryColor,
                    ),
                  ),
                  AppSpacing.gapMdHorizontal,
                  Expanded(
                    child: _infoCard(
                      title: 'Aulas cadastradas',
                      value: '${aulas.aulas.length}',
                      icon: Icons.calendar_today_outlined,
                      iconColor: AppColors.sucesso,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapMd,
            Animacoes.fadeSlide(
              delay: const Duration(milliseconds: 50),
              child: Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      title: 'Alunos ativos',
                      value: '${alunos.ativos}',
                      icon: Icons.check_circle_outline,
                      iconColor: AppColors.sucesso,
                    ),
                  ),
                  AppSpacing.gapMdHorizontal,
                  Expanded(
                    child: _infoCard(
                      title: 'Freq. média',
                      value: '87%',
                      icon: Icons.trending_up,
                      iconColor: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapXl,
            CardPadrao(
              padding: AppSpacing.cardPaddingLarge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Frequência semanal',
                        style: TextStyle(
                          fontSize: AppTypography.fontSizeH4,
                          fontWeight: AppTypography.fontWeightBold,
                          color: AppColors.textoPrimario,
                        ),
                      ),
                      Text('Mai 2026', style: TextStyle(color: AppColors.textoSecundario)),
                    ],
                  ),
                  AppSpacing.gapXxl,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(weeklyFrequency.length, (index) {
                      final item = weeklyFrequency[index];
                      final isSelected = index == selectedDayIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedDayIndex = index);
                          _showMessage('Frequência de ${item['day']}');
                        },
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 40,
                              height: (item['value'] as num).toDouble(),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryColor : AppColors.primariaClara,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            AppSpacing.gapSm,
                            Text(item['day'] as String, style: const TextStyle(color: AppColors.textoSecundario)),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            AppSpacing.gapXxl,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Próximas aulas', style: AppTypography.displaySmall),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, Rotas.agenda),
                  child: const Text('Ver todas', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            AppSpacing.gapMd,
            ...hoje.map((aula) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _classCard(context, aula),
                )),
            AppSpacing.gapXl,
            Text('Ações rápidas', style: AppTypography.displaySmall),
            AppSpacing.gapLg,
            Row(
              children: [
                Expanded(child: _quickAction(context, 'Frequência', Icons.analytics_rounded, Rotas.frequenciaTotem, push: true)),
                const SizedBox(width: 14),
                Expanded(child: _quickAction(context, 'Alunos', Icons.groups_rounded, Rotas.alunos)),
                const SizedBox(width: 14),
                Expanded(child: _quickAction(context, 'Agenda', Icons.event_note_rounded, Rotas.agenda)),
              ],
            ),
            AppSpacing.gapXxl,
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return CardPadrao(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textoSecundario)),
                AppSpacing.gapMd,
                Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor),
          ),
        ],
      ),
    );
  }

  Widget _classCard(BuildContext context, dynamic aula) {
    return CardPadrao(
      onTap: () => Navigator.pushNamed(context, Rotas.frequenciaTotem, arguments: aula),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time_rounded, color: AppColors.primaryColor),
          ),
          AppSpacing.gapMdHorizontal,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(aula.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${aula.professorNome} · ${aula.horarioInicio}', style: const TextStyle(color: AppColors.textoSecundario)),
              ],
            ),
          ),
          Text('${aula.alunoIds.length} alunos', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _quickAction(BuildContext context, String title, IconData icon, String rota, {bool push = false}) {
    return InkWell(
      borderRadius: AppBorders.radiusXLarge,
      onTap: () {
        if (push) {
          Navigator.pushNamed(context, rota);
        } else {
          Navigator.pushReplacementNamed(context, rota);
        }
      },
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: AppColors.fundoCard,
          borderRadius: AppBorders.radiusXLarge,
          boxShadow: AppShadows.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(color: AppColors.primariaClara, shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primaryColor),
            ),
            AppSpacing.gapSm,
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
