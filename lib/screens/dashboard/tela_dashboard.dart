import 'package:fluire/theme/tema.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/providers/provedor_dashboard.dart';
import 'package:fluire/utils/estado_carregamento.dart';
import 'package:fluire/widgets/estado_visual/estado_visual.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/widgets/layout_tela.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedDayIndex = DateTime.now().weekday - 1;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  Color statusColor(String? status) {
    switch (status) {
      case 'ativa':
        return AppColors.sucesso;

      case 'andamento':
        return AppColors.em_andamento;

      case 'lotada':
        return AppColors.lotado;

      default:
        return AppColors.primaryColor;
    }
  }

  String _obterMesAnoAtual() {
    final meses = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    final agora = DateTime.now();
    return '${meses[agora.month - 1]} ${agora.year}';
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProvedorDashboard>().carregar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProvedorDashboard>();

    if (provider.estado == EstadoCarregamento.inicial ||
        provider.estado == EstadoCarregamento.carregando) {
      return LayoutTela(
        titulo: 'Dashboard',
        rotaAtual: AppRoutes.dashboard,
        mostrarBottomNav: true,
        centralizarConteudo: true,
        child: const EstadoCarregando(mensagem: 'Carregando dashboard...'),
      );
    }

    if (provider.estado == EstadoCarregamento.erro) {
      return LayoutTela(
        titulo: 'Dashboard',
        rotaAtual: AppRoutes.dashboard,
        mostrarBottomNav: true,
        centralizarConteudo: true,
        child: EstadoErro(
          mensagem: provider.mensagemErro ?? 'Erro ao carregar Dashboard.',
          onTentarNovamente: () => provider.carregar(),
        ),
      );
    }

    if (provider.estado == EstadoCarregamento.vazio || provider.dashboard == null) {
      return LayoutTela(
        titulo: 'Dashboard',
        rotaAtual: AppRoutes.dashboard,
        mostrarBottomNav: true,
        centralizarConteudo: true,
        child: EstadoVazio(
          titulo: 'Nenhum dado encontrado.',
          subtitulo: 'Tente recarregar o dashboard mais tarde.',
          icone: Icons.dashboard_customize_outlined,
          onAcao: () => provider.carregar(),
          textoAcao: 'Recarregar',
        ),
      );
    }

    final dashboard = provider.dashboard!;
    final frequenciaSemana = provider.frequenciaSemanaCalculada;
    final salaDia = provider.todayClassesReal;

    return LayoutTela(
      titulo: 'Dashboard',
      rotaAtual: AppRoutes.dashboard,
      mostrarBottomNav: true,
      centralizarConteudo: false,
      child: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.gapXl,

            // CARDS
            LayoutBuilder(
              builder: (context, constraints) {
                final largura = constraints.maxWidth;
                int colunas = 2;
                if (largura > 900) {
                  colunas = 4;
                } else if (largura < 450) {
                  colunas = 1;
                }
                
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: colunas,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: colunas == 1 ? 3.0 : (colunas == 4 ? 1.4 : 1.7),
                  children: [
                    _infoCard(
                      title: 'Alunos Presentes',
                      value: provider.alunosPresentesReal.toString(),
                      icon: Icons.people_outline,
                      iconColor: AppColors.primaryColor,
                    ),
                    _infoCard(
                      title: 'Aulas Hoje',
                      value: provider.aulasHojeReal.toString(),
                      icon: Icons.calendar_today_outlined,
                      iconColor: AppColors.sucesso,
                    ),
                    _infoCard(
                      title: 'Em Andamento',
                      value: provider.aulasEmAndamentoCount.toString(),
                      icon: Icons.play_arrow_rounded,
                      iconColor: AppColors.alerta,
                    ),
                    _infoCard(
                      title: 'Freq. Média',
                      value: '${dashboard.frequenciaMedia}%',
                      icon: Icons.trending_up,
                      iconColor: AppColors.primaryColor,
                    ),
                  ],
                );
              }
            ),

            AppSpacing.gapXl,

            // GRAFICO
            Container(
              padding: AppSpacing.cardPaddingLarge,
              decoration: BoxDecoration(
                color: AppColors.fundoCard,
                borderRadius: AppBorders.radiusXXLarge,
                boxShadow: AppShadows.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Frequência Semanal',
                        style: AppTypography.headline.copyWith(
                          color: AppColors.textoPrimario,
                        ),
                      ),
                      Text(
                        _obterMesAnoAtual(),
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textoSecundario,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapXl,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(frequenciaSemana.length, (index) {
                      final item = frequenciaSemana[index];
                      final isSelected = index == selectedDayIndex;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDayIndex = index;
                            });

                            final presencas = item['presencas'] ?? 0;
                            final percentual = item['percentual'] ?? 0;
                            _showMessage('${item['fullName']}: $presencas presenças ($percentual% de frequência)');
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  width: 28,
                                  height: (item['value'] ?? 0).toDouble(),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.primariaClara,
                                    borderRadius: AppBorders.radiusMedium,
                                  ),
                                ),
                              ),
                              AppSpacing.gapSm,
                              Text(
                                item['day'],
                                style: AppTypography.titleSmall.copyWith(
                                  color: AppColors.textoSecundario,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            AppSpacing.gapXxl,

            // AULAS DE HOJE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Aulas de Hoje',
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.textoPrimario,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.aulas);
                  },
                  child: Text(
                    'Ver todas',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            AppSpacing.gapMd,

            Column(
              children: salaDia.map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _classCard(item),
                );
              }).toList(),
            ),

            AppSpacing.gapLg,

            Text(
              'Ações Rápidas',
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.textoPrimario,
              ),
            ),

            AppSpacing.gapLg,

            LayoutBuilder(
              builder: (context, constraints) {
                final largura = constraints.maxWidth;
                int colunas = 3;
                if (largura < 500) {
                  colunas = 1;
                }
                
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: colunas,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: colunas == 1 ? 3.5 : 1.1,
                  children: [
                    _quickAction(
                      title: 'Frequência',
                      icon: Icons.analytics_rounded,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.frequenciaTotem,
                        ).then((_) {
                          provider.carregar();
                        });
                      },
                    ),
                    _quickAction(
                      title: 'Alunos',
                      icon: Icons.groups_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.alunos).then((_) {
                          provider.carregar();
                        });
                      },
                    ),
                    _quickAction(
                      title: 'Aulas',
                      icon: Icons.event_note_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.aulas).then((_) {
                          provider.carregar();
                        });
                      },
                    ),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  // ================= COMPONENTES =================

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        borderRadius: AppBorders.radiusXXLarge,
        boxShadow: AppShadows.cardShadowSmall,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textoSecundario,
                  ),
                ),
                AppSpacing.gapMd,
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppTypography.fontSizeH2,
                    fontWeight: AppTypography.fontWeightBold,
                    color: AppColors.textoPrimario,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
        ],
      ),
    );
  }

  Widget _classCard(Map<String, dynamic> item) {
    return InkWell(
      borderRadius: AppBorders.radiusXXLarge,
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.detalheAula,
          arguments: item['id'],
        ).then((_) {
          if (mounted) {
            context.read<ProvedorDashboard>().carregar();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.fundoCard,
          borderRadius: AppBorders.radiusXXLarge,
          boxShadow: AppShadows.cardShadowSmall,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: statusColor(item["status"]).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.access_time_rounded,
                color: statusColor(item["status"]),
              ),
            ),
            AppSpacing.gapMdHorizontal,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"],
                    style: AppTypography.headline.copyWith(
                      color: AppColors.textoPrimario,
                    ),
                  ),
                  AppSpacing.gapXs,
                  Text(
                    "${item["teacher"]} • ${item["time"]}",
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item["students"],
                  style: AppTypography.headline.copyWith(
                    color: AppColors.textoPrimario,
                  ),
                ),
                AppSpacing.gapSm,
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor(item["status"]),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: AppBorders.radiusXXLarge,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.fundoCard,
          borderRadius: AppBorders.radiusXXLarge,
          boxShadow: AppShadows.cardShadowSmall,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useRow = constraints.maxWidth / constraints.maxHeight > 1.5;

            if (useRow) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.primariaClara,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: AppColors.primaryColor, size: 24),
                    ),
                    AppSpacing.gapMdHorizontal,
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: AppTypography.fontWeightBold,
                          color: AppColors.textoPrimario,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textoSecundario),
                  ],
                ),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: AppColors.primariaClara,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primaryColor, size: 26),
                ),
                AppSpacing.gapMd,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: AppTypography.fontWeightBold,
                    color: AppColors.textoPrimario,
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
