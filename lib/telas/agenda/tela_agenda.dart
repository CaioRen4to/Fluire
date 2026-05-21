import 'package:flutter/material.dart';
import 'package:fluire/tema/app_cores.dart';

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

      backgroundColor: appColors.backgroundColor,

      body: Center(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(24),

          child: Container(

            width: 430,

            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(

              color: appColors.backgroundColor,

              borderRadius: BorderRadius.circular(24),

              boxShadow: [

                BoxShadow(
                  color: appColors.sombra,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                /// HEADER
                Row(

                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    _botaoIcone(Icons.menu),

                    Text(
                      "Agenda",

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: appColors.textoPrimario,
                      ),
                    ),

                    _botaoIcone(
                      Icons.notifications_none,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

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

                          margin: const EdgeInsets.only(
                            right: 12,
                          ),

                          decoration: BoxDecoration(

                            color: selecionado
                                ? appColors.primaryColor
                                : appColors.fundoCard,

                            borderRadius:
                                BorderRadius.circular(22),
                          ),

                          child: Column(

                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              Text(

                                item["dia"]!,

                                style: TextStyle(

                                  color: selecionado
                                      ? appColors.textoClaro
                                      : appColors
                                          .textoSecundario,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(

                                item["numero"]!,

                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.bold,

                                  color: selecionado
                                      ? appColors.textoClaro
                                      : appColors
                                          .textoPrimario,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 22),

                /// SEARCH
                TextField(

                  decoration: InputDecoration(

                    hintText:
                        "Buscar aula ou professor",

                    filled: true,

                    fillColor: appColors.fundoCard,

                    prefixIcon: Icon(
                      Icons.search,
                      color: appColors.textoSecundario,
                    ),

                    border: OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(18),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                /// LISTA DE AULAS
                Column(

                  children: aulas.map((aula) {

                    return Container(

                      margin: const EdgeInsets.only(
                        bottom: 18,
                      ),

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(

                        color: appColors.fundoCard,

                        borderRadius:
                            BorderRadius.circular(24),
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Row(

                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [

                              Expanded(

                                child: Text(

                                  aula["titulo"]!,

                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        appColors.textoPrimario,
                                  ),
                                ),
                              ),

                              Container(

                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),

                                decoration: BoxDecoration(

                                  color: appColors.alerta,

                                  borderRadius:
                                      BorderRadius.circular(
                                    20,
                                  ),
                                ),

                                child: Text(

                                  aula["status"]!,

                                  style: TextStyle(
                                    color:
                                        appColors.textoClaro,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(

                            aula["professor"]!,

                            style: TextStyle(
                              color:
                                  appColors.textoSecundario,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(

                            children: [

                              Icon(
                                Icons.access_time,
                                size: 18,
                                color:
                                    appColors.textoSecundario,
                              ),

                              const SizedBox(width: 6),

                              Text(
                                aula["horario"]!,
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          Row(

                            children: [

                              Expanded(

                                child: ElevatedButton(

                                  onPressed: () {},

                                  style:
                                      ElevatedButton.styleFrom(

                                    backgroundColor:
                                        appColors
                                            .primariaClara,

                                    foregroundColor:
                                        appColors
                                            .textoPrimario,

                                    elevation: 0,
                                  ),

                                  child: const Text(
                                    "Detalhes",
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(

                                child:
                                    ElevatedButton(

                                  onPressed: () {},

                                  style:
                                      ElevatedButton.styleFrom(

                                    backgroundColor:
                                        appColors
                                            .primaryColor,

                                    foregroundColor:
                                        appColors
                                            .textoClaro,

                                    elevation: 0,
                                  ),

                                  child: const Text(
                                    "Frequência",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                /// BOTÃO FINAL
                SizedBox(

                  width: double.infinity,
                  height: 56,

                  child: ElevatedButton.icon(

                    onPressed: () {},

                    icon: const Icon(Icons.add),

                    label: const Text(
                      "Nova Aula",
                    ),

                    style: ElevatedButton.styleFrom(

                      backgroundColor:
                          appColors.primaryColor,

                      foregroundColor:
                          appColors.textoClaro,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

        color: appColors.fundoCard,

        shape: BoxShape.circle,
      ),

      child: Icon(
        icon,
        color: appColors.textoPrimario,
      ),
    );
  }
}