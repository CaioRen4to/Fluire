import 'package:flutter/material.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/widgets/menu_lateral.dart';

class TelaAgenda extends StatefulWidget {
  const TelaAgenda({super.key});

  @override
  State<TelaAgenda> createState() => _TelaAgendaState();
}

class _TelaAgendaState extends State<TelaAgenda> {

  int diaSelecionado = 1;

  final List<Map<String, String>> dias = [
    {"dia": "Seg", "numero": "19"},
    {"dia": "Ter", "numero": "20"},
    {"dia": "Qua", "numero": "21"},
    {"dia": "Qui", "numero": "22"},
    {"dia": "Sex", "numero": "23"},
    {"dia": "Sáb", "numero": "24"},
  ];

  final List<Map<String, String>> aulas = [
    {
      "titulo": "Mat Pilates",
      "professor": "Ana Silva",
      "horario": "08:00",
      "status": "Em andamento",
    },
    {
      "titulo": "Pilates Funcional",
      "professor": "Carlos Lima",
      "horario": "09:30",
      "status": "Próxima",
    },
    {
      "titulo": "Yoga Relax",
      "professor": "Mariana Costa",
      "horario": "11:00",
      "status": "Próxima",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const MenuLateral(rotaAtual: Rotas.agenda),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BotaoMenu(),
                  Text(
                    "Agenda",
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.textoPrimario,
                    ),
                  ),
                  _botaoIcone(
                    Icons.notifications_none,
                  ),
                ],
              ),

              AppSpacing.gapXxl,

                /// DIAS
                SizedBox(

                  height: 84,

                  child: ListView.builder(

                    scrollDirection: Axis.horizontal,

                    itemCount: dias.length,

                    itemBuilder: (context, index) {

                      final item = dias[index];

                      final selecionado =
                          diaSelecionado == index;

                      return GestureDetector(

                        onTap: () {

                          setState(() {
                            diaSelecionado = index;
                          });
                        },

                        child: Container(
                          width: 68,
                          margin: const EdgeInsets.only(right: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: selecionado
                                ? AppColors.primaryColor
                                : AppColors.fundoCard,
                            borderRadius: AppBorders.radiusLarge,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item["dia"]!,
                                style: TextStyle(
                                  color: selecionado
                                      ? AppColors.textoClaro
                                      : AppColors.textoSecundario,
                                ),
                              ),
                              AppSpacing.gapSm,
                              Text(
                                item["numero"]!,
                                style: TextStyle(
                                  fontSize: AppTypography.fontSizeH3,
                                  fontWeight: AppTypography.fontWeightBold,
                                  color: selecionado
                                      ? AppColors.textoClaro
                                      : AppColors.textoPrimario,
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

                /// SEARCH
                TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar aula ou professor",
                    filled: true,
                    fillColor: AppColors.fundoCard,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textoSecundario,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppBorders.radiusLarge,
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                AppSpacing.gapXxl,

                /// LISTA DE AULAS
                Column(
                  children: aulas.map((aula) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      padding: AppSpacing.cardPaddingLarge,
                      decoration: BoxDecoration(
                        color: AppColors.fundoCard,
                        borderRadius: AppBorders.radiusXLarge,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  aula["titulo"]!,
                                  style: AppTypography.displaySmall.copyWith(
                                    color: AppColors.textoPrimario,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.alerta,
                                  borderRadius: AppBorders.radiusLarge,
                                ),
                                child: Text(
                                  aula["status"]!,
                                  style: TextStyle(
                                    color: AppColors.textoClaro,
                                    fontWeight: AppTypography.fontWeightBold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          AppSpacing.gapSm,

                          Text(
                            aula["professor"]!,
                            style: TextStyle(
                              color: AppColors.textoSecundario,
                            ),
                          ),

                          AppSpacing.gapLg,

                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: AppColors.textoSecundario,
                              ),
                              AppSpacing.gapSmHorizontal,
                              Text(
                                aula["horario"]!,
                              ),
                            ],
                          ),

                          AppSpacing.gapLg,

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primariaClara,
                                    foregroundColor: AppColors.textoPrimario,
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    "Detalhes",
                                  ),
                                ),
                              ),
                              AppSpacing.gapMdHorizontal,
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    Rotas.frequenciaTotem,
                                    arguments: {
                                      'nome': aula['titulo'],
                                      'professor': aula['professor'],
                                      'horario': aula['horario'],
                                    },
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: AppColors.textoClaro,
                                    elevation: 0,
                                  ),
                                  child: const Text('Frequência'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                AppSpacing.gapMd,

                /// BOTÃO FINAL
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text(
                      "Nova Aula",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.textoClaro,
                      elevation: 0,
                      shape: AppBorders.buttonShape,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );  
  }


  Widget _botaoIcone(IconData icon) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.textoPrimario,
      ),
    );
  }
}