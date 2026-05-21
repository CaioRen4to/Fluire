import 'package:fluire/tema/app_cores.dart';
import 'package:flutter/material.dart';
import 'package:fluire/rotas.dart';

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
      "color": appColors.sucesso,
    },
    {
      "title": "Reformer Avançado",
      "teacher": "Carlos Lima",
      "time": "09:30",
      "students": "5/6",
      "color": appColors.alerta,
    },
    {
      "title": "Pilates Funcional",
      "teacher": "Mariana Costa",
      "time": "11:00",
      "students": "7/8",
      "color": appColors.primaryColor,
    },
  ];

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: appColors.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(Icons.menu),
                  const Text(
                    "Painel",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: appColors.textoPrimario,
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
                            color: appColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // CARDS
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      title: "Alunos Presentes",
                      value: "24",
                      icon: Icons.people_outline,
                      iconColor: appColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _infoCard(
                      title: "Aulas Hoje",
                      value: "6",
                      icon: Icons.calendar_today_outlined,
                      iconColor: appColors.sucesso,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      title: "Em Andamento",
                      value: "2",
                      icon: Icons.play_arrow_rounded,
                      iconColor: appColors.alerta,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _infoCard(
                      title: "Freq. Média",
                      value: "87%",
                      icon: Icons.trending_up,
                      iconColor: appColors.primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // GRAFICO
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: appColors.fundoCard,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: appColors.sombra,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: appColors.textoPrimario,
                          ),
                        ),
                        Text(
                          "Mai 2026",
                          style: TextStyle(
                            color: appColors.textoSecundario,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

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
                                      ? appColors.primaryColor
                                      : appColors.primariaClara,

                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text(
                                item["day"],
                                style: const TextStyle(
                                  color: appColors.textoSecundario,
                                  fontWeight: FontWeight.w500,
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

              const SizedBox(height: 28),

              // AULAS DE HOJE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Aulas de Hoje",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: appColors.textoPrimario,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      _showMessage("Abrindo todas as aulas...");
                    },
                    child: const Text(
                      "Ver todas",
                      style: TextStyle(
                        color: appColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Column(
                children: todayClasses.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _classCard(item),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              const Text(
                "Ações Rápidas",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: appColors.textoPrimario,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _quickAction(
                      title: "Frequência",
                      icon: Icons.analytics_rounded,
                      onTap: () {
                        _showMessage("Abrindo Frequência...");
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _quickAction(
                      title: "Alunos",
                      icon: Icons.groups_rounded,
                      onTap: () {
                        _showMessage("Abrindo Alunos...");
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _quickAction(
                      title: "Agenda",
                      icon: Icons.event_note_rounded,
                      onTap: () {
                        _showMessage("Abrindo Agenda...");
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
        color: appColors.fundoCard,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Icon(icon, color: appColors.textoPrimario),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: appColors.fundoCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: appColors.sombra,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                    color: appColors.textoSecundario,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: appColors.textoPrimario,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),

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
      borderRadius: BorderRadius.circular(24),

      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Abrindo ${item["title"]}"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: appColors.fundoCard,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: appColors.sombra,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: appColors.textoPrimario,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item["teacher"]} • ${item["time"]}",
                    style: const TextStyle(color: appColors.textoSecundario),
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
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: appColors.textoPrimario,
                  ),
                ),

                const SizedBox(height: 6),

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
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        height: 120,

        decoration: BoxDecoration(
          color: appColors.fundoCard,
          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: appColors.sombra,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ÍCONE
            Container(
              width: 52,
              height: 52,

              decoration: BoxDecoration(
                color: appColors.primariaClara,
                shape: BoxShape.circle,
              ),

              child: Icon(icon, color: appColors.primaryColor, size: 26),
            ),

            const SizedBox(height: 12),

            // TEXTO
            Text(
              title,
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: appColors.textoPrimario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}