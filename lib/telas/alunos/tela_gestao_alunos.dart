import 'package:flutter/material.dart';
import 'package:fluire/rotas.dart';
import '../../tema/app_cores.dart';

class TelaGestaoAlunos extends StatelessWidget {
  TelaGestaoAlunos({super.key});

  final List<Map<String, dynamic>> alunos = [
    {'nome': 'Julia Ferreira', 'inicial': 'J', 'telefone': '(11) 99999-1111', 'modalidade': 'Mat Pilates', 'presencas': 32, 'status': true},
    {'nome': 'Carla Santos', 'inicial': 'C', 'telefone': '(11) 99999-2222', 'modalidade': 'Reformer', 'presencas': 28, 'status': true},
    {'nome': 'Amanda Souza', 'inicial': 'A', 'telefone': '(11) 99999-3333', 'modalidade': 'Pilates Funcional', 'presencas': 12, 'status': false},
    {'nome': 'Fernanda Costa', 'inicial': 'F', 'telefone': '(11) 99999-4444', 'modalidade': 'Duet Reformer', 'presencas': 45, 'status': true},
  ];

  static const _pad = EdgeInsets.symmetric(horizontal: 16);

  @override
  Widget build(BuildContext context) {
    final ativos = alunos.where((a) => a['status'] == true).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicionar aluno')),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _icone(Icons.menu),
                  Text('Alunos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textoPrimario)),
                  _icone(Icons.notifications_outlined),
                ],
              ),
            ),
            Padding(
              padding: _pad,
              child: Row(
                children: [
                  _resumo('${alunos.length}', 'Total', AppColors.primaryColor),
                  const SizedBox(width: 10),
                  _resumo('$ativos', 'Ativos', AppColors.sucesso),
                  const SizedBox(width: 10),
                  _resumo('${alunos.length - ativos}', 'Inativos', AppColors.erro),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: _pad,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar aluno...',
                  prefixIcon: Icon(Icons.search, color: AppColors.popUp),
                  filled: true,
                  fillColor: AppColors.fundoCard,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.separated(
                padding: _pad,
                itemCount: alunos.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final a = alunos[i];
                  final ativo = a['status'] == true;
                  final corStatus = ativo ? AppColors.sucesso : AppColors.erro;

                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => Navigator.pushNamed(
                      context,
                      Rotas.detalheAluno,
                      arguments: a,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.fundoCard,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: AppColors.primaryColor,
                            child: Text(a['inicial'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['nome'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textoPrimario)),
                                const SizedBox(height: 4),
                                Text(a['modalidade'], style: TextStyle(fontSize: 12, color: AppColors.textoSecundario)),
                                const SizedBox(height: 4),
                                Text('${a['presencas']} presenças', style: TextStyle(fontSize: 11, color: AppColors.textoSecundario)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: corStatus)),
                              const SizedBox(height: 6),
                              Text(ativo ? 'Ativo' : 'Inativo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: corStatus)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resumo(String valor, String titulo, Color cor) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: AppColors.fundoCard, borderRadius: BorderRadius.circular(18)),
          child: Column(
            children: [
              Text(valor, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cor)),
              const SizedBox(height: 4),
              Text(titulo, style: TextStyle(fontSize: 12, color: AppColors.textoSecundario)),
            ],
          ),
        ),
      );

  Widget _icone(IconData icon) => Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(color: AppColors.fundoCard, shape: BoxShape.circle),
        child: Icon(icon, size: 22, color: AppColors.textoPrimario),
      );
}
