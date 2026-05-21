import 'package:flutter/material.dart';
import '../../tema/app_cores.dart';

class TelaDetalheAluno extends StatelessWidget {
  final Map<String, dynamic> aluno;

  const TelaDetalheAluno({super.key, required this.aluno});

  static const _historico = [
    {'aula': 'Mat Pilates', 'data': '20/05/2026', 'presente': true},
    {'aula': 'Reformer', 'data': '18/05/2026', 'presente': true},
    {'aula': 'Pilates Funcional', 'data': '15/05/2026', 'presente': false},
    {'aula': 'Duet Reformer', 'data': '10/05/2026', 'presente': true},
  ];

  @override
  Widget build(BuildContext context) {
    final ativo = aluno['status'] == true;
    final corStatus = ativo ? AppColors.sucesso : AppColors.erro;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presença marcada')),
        ),
        icon: const Icon(Icons.check, color: Colors.white),
        label: const Text('Marcar presença', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _btnHeader(Icons.arrow_back, () => Navigator.pop(context)),
                  Text('Detalhes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textoPrimario)),
                  _btnHeader(Icons.edit_outlined, () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Editar aluno')),
                      )),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(colors: [AppColors.primaryColor, AppColors.primaryColor.withValues(alpha: 0.7)]),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            child: Text('${aluno['inicial']}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                          const SizedBox(height: 12),
                          Text('${aluno['nome']}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('${aluno['modalidade']}', style: TextStyle(fontSize: 13, color: AppColors.primariaClara)),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: corStatus)),
                                const SizedBox(width: 6),
                                Text(ativo ? 'Ativo' : 'Inativo', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(child: _stat('${aluno['presencas']}', 'Presenças', AppColors.sucesso)),
                        const SizedBox(width: 10),
                        Expanded(child: _stat('4', 'Faltas', AppColors.erro)),
                        const SizedBox(width: 10),
                        Expanded(child: _stat('89%', 'Frequência', AppColors.primaryColor)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _bloco(
                      'Informações',
                      Column(
                        children: [
                          _info(Icons.phone, 'Telefone', '${aluno['telefone']}'),
                          Divider(color: AppColors.divisor),
                          _info(Icons.fitness_center, 'Modalidade', '${aluno['modalidade']}'),
                          Divider(color: AppColors.divisor),
                          _info(Icons.calendar_month, 'Última aula', '20/05/2026'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _bloco(
                      'Histórico recente',
                      Column(
                        children: List.generate(_historico.length, (i) {
                          final h = _historico[i];
                          final ok = h['presente'] == true;
                          final cor = ok ? AppColors.sucesso : AppColors.erro;
                          return Column(
                            children: [
                              if (i > 0) Divider(color: AppColors.divisor),
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(color: cor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                                    child: Icon(ok ? Icons.check : Icons.close, color: cor),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${h['aula']}', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textoPrimario)),
                                        Text('${h['data']}', style: TextStyle(fontSize: 12, color: AppColors.textoSecundario)),
                                      ],
                                    ),
                                  ),
                                  Text(ok ? 'Presente' : 'Falta', style: TextStyle(fontWeight: FontWeight.w600, color: cor)),
                                ],
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnHeader(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(color: AppColors.fundoCard, shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.textoPrimario),
        ),
      );

  Widget _stat(String valor, String titulo, Color cor) => Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(color: AppColors.fundoCard, borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: [
            Text(valor, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cor)),
            const SizedBox(height: 4),
            Text(titulo, style: TextStyle(fontSize: 12, color: AppColors.textoSecundario)),
          ],
        ),
      );

  Widget _bloco(String titulo, Widget conteudo) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.fundoCard, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textoPrimario)),
            const SizedBox(height: 14),
            conteudo,
          ],
        ),
      );

  Widget _info(IconData icon, String titulo, String valor) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryColor),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: TextStyle(fontSize: 12, color: AppColors.textoSecundario)),
                Text(valor, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textoPrimario)),
              ],
            ),
          ],
        ),
      );
}
