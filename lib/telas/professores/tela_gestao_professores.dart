import 'package:flutter/material.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/rotas.dart';

class TelaProfessores extends StatefulWidget {
  const TelaProfessores({super.key});

  @override
  State<TelaProfessores> createState() => _TelaProfessoresState();
}

class _TelaProfessoresState extends State<TelaProfessores> {
  final TextEditingController _searchController = TextEditingController();

  int selectedIndex = -1;
  String search = '';

  final List<Map<String, dynamic>> professores = [
    {
      "name": "Ana Silva",
      "specialties": "Mat Pilates, Pilates Solo",
      "phone": "(11) 99888-1111",
      "lessons": 3,
      "active": true,
    },
    {
      "name": "Carlos Lima",
      "specialties": "Reformer, Pilates Funcional",
      "phone": "(11) 99888-2222",
      "lessons": 2,
      "active": true,
    },
    {
      "name": "Mariana Costa",
      "specialties": "Pilates Funcional, Duet",
      "phone": "(11) 99888-3333",
      "lessons": 1,
      "active": true,
    },
    {
      "name": "Rafael Mendes",
      "specialties": "Mat Pilates, Reformer",
      "phone": "(11) 99888-4444",
      "lessons": 0,
      "active": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final activeTeachers =
        professores.where((e) => e['active'] == true).length;

    final totalLessons = professores.fold<int>(
      0,
      (sum, item) => sum + (item['lessons'] as int),
    );

    final filteredList = professores.where((teacher) {
      return teacher['name']
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _circleButton(
                    icon: Icons.menu_rounded,
                    onTap: () {},
                  ),
                  const Spacer(),
                  Text(
                    'Professores',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textoPrimario,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      _circleButton(
                        icon: Icons.notifications_none_rounded,
                        onTap: () {},
                      ),
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
            ),

            const SizedBox(height: 26),

            /// STATS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: professores.length.toString(),
                      label: 'Total',
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _StatCard(
                      value: activeTeachers.toString(),
                      label: 'Ativos',
                      color: AppColors.sucesso,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _StatCard(
                      value: totalLessons.toString(),
                      label: 'Aulas Hoje',
                      color: AppColors.popUp,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.fundoCard,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                  style: TextStyle(
                    color: AppColors.textoPrimario,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar professor...',
                    hintStyle: TextStyle(
                      color: AppColors.textoSecundario,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.textoSecundario,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// LISTA
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final professor = filteredList[index];

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: AppColors.fundoCard,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: selectedIndex == index
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.sombra,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () {
                        setState(() {
                          selectedIndex =
                              selectedIndex == index ? -1 : index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                      AppColors.primaryColor,
                                  child: Text(
                                    professor['name'][0],
                                    style: const TextStyle(
                                      color: AppColors.textoClaro,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        professor['name'],
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              AppColors.textoPrimario,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        professor['specialties'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: AppColors
                                              .textoSecundario,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        professor['phone'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: AppColors
                                              .textoSecundario,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: professor['active']
                                            ? AppColors.sucesso
                                            : AppColors.erro,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      professor['active']
                                          ? 'Ativo'
                                          : 'Inativo',
                                      style: TextStyle(
                                        color: professor['active']
                                            ? AppColors.sucesso
                                            : AppColors.erro,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                _ActionChip(
                                  icon:
                                      Icons.calendar_today_rounded,
                                  label:
                                      '${professor['lessons']} aulas hoje',
                                  onTap: () {},
                                ),
                                const SizedBox(width: 12),
                                _ActionChip(
                                  label: 'Ver agenda',
                                  icon:
                                      Icons.arrow_forward_ios_rounded,
                                  reverse: true,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// BOTÃO
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Cadastrar Professor'),
                      ),
                    );
                  },
                  icon:
                      const Icon(Icons.person_add_alt_1_rounded),
                  label: const Text(
                    'Cadastrar Professor',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryColor,
                    foregroundColor:
                        AppColors.textoClaro,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.fundoCard,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 54,
          height: 54,
          child: Icon(
            icon,
            color: AppColors.textoPrimario,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textoSecundario,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool reverse;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.reverse = false,
  });

  @override
  State<_ActionChip> createState() => _ActionChipState();
}

class _ActionChipState extends State<_ActionChip> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => pressed = true);
      },
      onTapUp: (_) {
        setState(() => pressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => pressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: pressed
              ? AppColors.primariaClara
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.reverse
              ? [
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: AppColors.textoPrimario,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    widget.icon,
                    size: 16,
                    color: AppColors.textoSecundario,
                  ),
                ]
              : [
                  Icon(
                    widget.icon,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: AppColors.textoPrimario,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}