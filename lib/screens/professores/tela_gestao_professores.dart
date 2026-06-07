import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/providers/providers.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/widgets/layout_tela.dart';
import 'package:fluire/models/models.dart';
import 'package:fluire/screens/professores/tela_aulas_professor.dart';

class TelaProfessores extends StatefulWidget {
  const TelaProfessores({super.key});

  @override
  State<TelaProfessores> createState() => _TelaProfessoresState();
}

class _TelaProfessoresState extends State<TelaProfessores> {
  final TextEditingController _searchController = TextEditingController();
  int selectedIndex = -1;
  String search = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProvedorAulas>().carregar();
    });
  }

  String _converterDiaSemanaInt(int dia) {
    switch (dia) {
      case 1:
        return 'segunda-feira';
      case 2:
        return 'terça-feira';
      case 3:
        return 'quarta-feira';
      case 4:
        return 'quinta-feira';
      case 5:
        return 'sexta-feira';
      case 6:
        return 'sábado';
      case 7:
        return 'domingo';
      default:
        return '';
    }
  }

  List<Map<String, dynamic>> _professoresFromProvider(ProvedorAulas provider) {
    final hojeSemana = _converterDiaSemanaInt(DateTime.now().weekday);
    return provider.professores.map((p) {
      final aulasDoProfessor = provider.aulas.where((a) => a.usuarioId == p.id).toList();
      return {
        'id': p.id,
        'name': p.nome,
        'email': p.email.isNotEmpty ? p.email : '—',
        'lessons': aulasDoProfessor
            .where((a) => a.diaSemana.toLowerCase().trim() == hojeSemana)
            .length,
        'active': aulasDoProfessor.isNotEmpty,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProvedorAulas>();
    final professores = _professoresFromProvider(provider);
    final activeTeachers = professores.where((e) => e['active'] == true).length;

    final hojeSemana = _converterDiaSemanaInt(DateTime.now().weekday);
    final totalLessons = provider.aulas
        .where((a) => a.diaSemana.toLowerCase().trim() == hojeSemana)
        .length;

    final filteredList = professores.where((teacher) {
      return teacher['name'].toString().toLowerCase().contains(
        search.toLowerCase(),
      );
    }).toList();

    return LayoutTela(
      titulo: 'Professores',
      rotaAtual: AppRoutes.professores,
      centralizarConteudo: false,
      appBarCustom: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textoPrimario,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
            }
          },
        ),
        title: Text(
          'Professores',
          style: TextStyle(
            color: AppColors.textoPrimario,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final colunas = constraints.maxWidth < 450 ? 1 : 3;
                if (colunas == 1) {
                  return Column(
                    children: [
                      _StatCardRow(
                        value: professores.length.toString(),
                        label: 'Total de Professores',
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(height: 10),
                      _StatCardRow(
                        value: activeTeachers.toString(),
                        label: 'Professores Ativos',
                        color: AppColors.sucesso,
                      ),
                      const SizedBox(height: 10),
                      _StatCardRow(
                        value: totalLessons.toString(),
                        label: 'Aulas Ministradas Hoje',
                        color: AppColors.popUp,
                      ),
                    ],
                  );
                }
                return Row(
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
                );
              }
            ),
          ),
          const SizedBox(height: 24),
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
                style: TextStyle(color: AppColors.textoPrimario),
                decoration: InputDecoration(
                  hintText: 'Buscar professor...',
                  hintStyle: TextStyle(color: AppColors.textoSecundario),
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
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 18),
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
                        selectedIndex = selectedIndex == index ? -1 : index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: AppColors.primaryColor,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      professor['name'],
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textoPrimario,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      professor['email'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: AppColors.textoSecundario,
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
                                    professor['active'] ? 'Ativo' : 'Inativo',
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
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              _ActionChip(
                                icon: Icons.calendar_today_rounded,
                                label: '${professor['lessons']} aulas hoje',
                                onTap: () {},
                              ),
                              _ActionChip(
                                label: 'Ver aulas',
                                icon: Icons.arrow_forward_ios_rounded,
                                reverse: true,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TelaAulasProfessor(
                                        professor: Professor(
                                          id: professor['id'],
                                          nome: professor['name'],
                                          email: professor['email'] == '—' ? '' : professor['email'],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 62,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cadastrar Professor')),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text(
                  'Cadastrar Professor',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.textoClaro,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _StatCardRow extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCardRow({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textoSecundario,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: pressed ? AppColors.primariaClara : Colors.white,
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
                  Icon(widget.icon, size: 16, color: AppColors.textoSecundario),
                ]
              : [
                  Icon(widget.icon, size: 16, color: AppColors.primaryColor),
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
