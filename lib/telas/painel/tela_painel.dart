import 'package:fluire/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/provedores/provedor_alunos.dart';
import 'package:fluire/provedores/provedor_aulas.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/services/painel_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _painelService = PainelService();
  int selectedDayIndex = 3;

  Map<String, dynamic>? dashboard;
  bool loading = true;
  List<dynamic> frequenciaSemana = [];
  List<dynamic> salaDia = [];

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

  @override
  void initState() {
    super.initState();

    buscarPainel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProvedorAlunos>().carregar();
      context.read<ProvedorAulas>().carregar();
    });
  }

  Future<void> buscarPainel() async {
    try {
      final response = await _painelService.buscarPainel();

      setState(() {
        dashboard = response;

        frequenciaSemana = response['weekly_frequency'] ?? [];

        salaDia = response['today_classes'] ?? [];

        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      _showMessage('Erro ao carregar painel');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ProvedorAlunos>();
    context.watch<ProvedorAulas>();

    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.fundoCard,
                    ),
                  ),
                  Text(
                    "Painel",
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.textoPrimario,
                    ),
                  ),
                  Stack(
                    children: [
                      _circleButton(Icons.notifications_none_rounded),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              AppSpacing.gapXl,

              // CARDS
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      title: "Alunos Presentes",
                      value: dashboard?['alunos_presentes']?.toString() ?? '0',
                      icon: Icons.people_outline,
                      iconColor: AppColors.primaryColor,
                    ),
                  ),
                  AppSpacing.gapMdHorizontal,
                  Expanded(
                    child: _infoCard(
                      title: "Aulas Hoje",
                      value: dashboard?['aulas_hoje']?.toString() ?? '0',
                      icon: Icons.calendar_today_outlined,
                      iconColor: AppColors.sucesso,
                    ),
                  ),
                ],
              ),

              AppSpacing.gapMd,

              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      title: "Em Andamento",
                      value: dashboard?['em_andamento']?.toString() ?? '0',
                      icon: Icons.play_arrow_rounded,
                      iconColor: AppColors.alerta,
                    ),
                  ),
                  AppSpacing.gapMdHorizontal,
                  Expanded(
                    child: _infoCard(
                      title: "Freq. Média",
                      value: '${dashboard?['frequencia_media'] ?? 0}%',
                      icon: Icons.trending_up,
                      iconColor: AppColors.primaryColor,
                    ),
                  ),
                ],
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
                          "Frequência Semanal",
                          style: AppTypography.headline.copyWith(
                            color: AppColors.textoPrimario,
                          ),
                        ),
                        Text(
                          "Mai 2026",
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

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDayIndex = index;
                            });

                            _showMessage("Frequência de ${item["day"]}");
                          },
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 40,
                                height: (item["value"] ?? 0).toDouble(),

                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.primariaClara,

                                  borderRadius: AppBorders.radiusMedium,
                                ),
                              ),

                              AppSpacing.gapSm,
                              Text(
                                item["day"],
                                style: AppTypography.titleSmall.copyWith(
                                  color: AppColors.textoSecundario,
                                ),
                              ),
                            ],
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
                    "Aulas de Hoje",
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.textoPrimario,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.agenda);
                    },
                    child: Text(
                      "Ver todas",
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
                "Ações Rápidas",
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.textoPrimario,
                ),
              ),

              AppSpacing.gapLg,

              Row(
                children: [
                  Expanded(
                    child: _quickAction(
                      title: "Frequência",
                      icon: Icons.analytics_rounded,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.frequenciaTotem,
                        ).then((_) {
                          // Recarrega dados após voltar da tela de frequência
                          buscarPainel();
                        });
                      },
                    ),
                  ),
                  AppSpacing.gapMdHorizontal,
                  Expanded(
                    child: _quickAction(
                      title: "Alunos",
                      icon: Icons.groups_rounded,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.alunos,
                        ).then((_) {
                          // Recarrega dados após voltar da tela de alunos
                          buscarPainel();
                        });
                      },
                    ),
                  ),
                  AppSpacing.gapMdHorizontal,
                  Expanded(
                    child: _quickAction(
                      title: "Agenda",
                      icon: Icons.event_note_rounded,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.agenda,
                        ).then((_) {
                          // Recarrega dados após voltar da tela de agenda
                          buscarPainel();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= COMPONENTES =================

  Widget _circleButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        borderRadius: AppBorders.radiusLarge,
      ),
      child: Icon(icon, color: AppColors.textoPrimario),
    );
  }

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Abrindo ${item["title"]}"),
            behavior: SnackBarBehavior.floating,
          ),
        );
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
                color: statusColor(item["status"]).withOpacity(0.12),
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
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.fundoCard,
          borderRadius: AppBorders.radiusXXLarge,
          boxShadow: AppShadows.cardShadowSmall,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
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
        ),
      ),
    );
  }
}
