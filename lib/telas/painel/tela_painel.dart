import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/tema/app_sombras.dart';
import 'package:fluire/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedDayIndex = 3;

  final List<Map<String, dynamic>> weeklyFrequency = [
    {"day": "Seg", "value": 40},
    {"day": "Ter", "value": 55},
    {"day": "Qua", "value": 35},
    {"day": "Qui", "value": 70},
    {"day": "Sex", "value": 50},
    {"day": "Sáb", "value": 25},
  ];

  final List<Map<String, dynamic>> todayClasses = [
    {
      "title": "Mat Pilates",
      "teacher": "Ana Silva",
      "time": "08:00",
      "students": "8/10",
      "color": AppColors.sucesso,
    },
    {
      "title": "Reformer Avançado",
      "teacher": "Carlos Lima",
      "time": "09:30",
      "students": "5/6",
      "color": AppColors.alerta,
    },
    {
      "title": "Pilates Funcional",
      "teacher": "Mariana Costa",
      "time": "11:00",
      "students": "7/8",
      "color": AppColors.primaryColor,
    },
  ];

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const MenuLateral(rotaAtual: Rotas.painel),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BotaoMenu(),
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
                      value: "24",
                      icon: Icons.people_outline,
                      iconColor: AppColors.primaryColor,
                    ),
                  ),
                  AppSpacing.gapMdHorizontal,
                  Expanded(
                    child: _infoCard(
                      title: "Aulas Hoje",
                      value: "6",
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
                      value: "2",
                      icon: Icons.play_arrow_rounded,
                      iconColor: AppColors.alerta,
                    ),
                  ),
                  AppSpacing.gapMdHorizontal,
                  Expanded(
                    child: _infoCard(
                      title: "Freq. Média",
                      value: "87%",
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
                      children: const [
                        Text(
                          "Frequência Semanal",
                          style: TextStyle(
                            fontSize: AppTypography.fontSizeH4,
                            fontWeight: AppTypography.fontWeightBold,
                            color: AppColors.textoPrimario,
                          ),
                        ),
                        Text(
                          "Mai 2026",
                          style: TextStyle(
                            color: AppColors.textoSecundario,
                            fontWeight: AppTypography.fontWeightMedium,
                          ),
                        ),
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
                                height: item["value"].toDouble(),

                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.primariaClara,

                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              AppSpacing.gapSm,
                              Text(
                                item["day"],
                                style: const TextStyle(
                                  color: AppColors.textoSecundario,
                                  fontWeight: AppTypography.fontWeightMedium,
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
                    onPressed: () => Navigator.pushReplacementNamed(context, Rotas.agenda),
                    child: const Text(
                      "Ver todas",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: AppTypography.fontWeightSemiBold,
                      ),
                    ),
                  ),
                ],
              ),

              AppSpacing.gapMd,

              Column(
                children: todayClasses.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _classCard(item),
                  );
                }).toList(),
              ),

              AppSpacing.gapXl,

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
                      onTap: () => Navigator.pushNamed(context, Rotas.frequenciaTotem),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _quickAction(
                      title: "Alunos",
                      icon: Icons.groups_rounded,
                      onTap: () => Navigator.pushReplacementNamed(context, Rotas.alunos),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _quickAction(
                      title: "Agenda",
                      icon: Icons.event_note_rounded,
                      onTap: () => Navigator.pushReplacementNamed(context, Rotas.agenda),
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
        borderRadius: AppBorders.radiusMedium,
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
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        borderRadius: AppBorders.radiusXLarge,
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textoSecundario,
                    fontWeight: AppTypography.fontWeightMedium,
                  ),
                ),
                AppSpacing.gapMd,
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 38,
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
              color: iconColor.withOpacity(0.12),
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
      borderRadius: AppBorders.radiusXLarge,
      onTap: () => Navigator.pushNamed(
        context,
        Rotas.frequenciaTotem,
        arguments: {
          'nome': item['title'],
          'professor': item['teacher'],
          'horario': item['time'],
        },
      ),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.fundoCard,
          borderRadius: AppBorders.radiusXLarge,
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: item["color"].withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.access_time_rounded, color: item["color"]),
            ),
            AppSpacing.gapMdHorizontal,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"],
                    style: const TextStyle(
                      fontSize: AppTypography.fontSizeXXXl,
                      fontWeight: AppTypography.fontWeightBold,
                      color: AppColors.textoPrimario,
                    ),
                  ),
                  AppSpacing.gapXs,
                  Text(
                    "${item["teacher"]} • ${item["time"]}",
                    style: const TextStyle(color: AppColors.textoSecundario),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item["students"],
                  style: const TextStyle(
                    fontWeight: AppTypography.fontWeightBold,
                    fontSize: AppTypography.fontSizeXXXl,
                    color: AppColors.textoPrimario,
                  ),
                ),
                AppSpacing.gapSm,
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: item["color"],
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
      borderRadius: AppBorders.radiusXLarge,
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.fundoCard,
          borderRadius: AppBorders.radiusXLarge,
          boxShadow: AppShadows.cardShadow,
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
              style: const TextStyle(
                fontWeight: AppTypography.fontWeightBold,
                fontSize: AppTypography.fontSizeXXl,
                color: AppColors.textoPrimario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}