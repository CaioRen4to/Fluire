import 'package:flutter/material.dart';
import '../../tema/app_cores.dart';

class TelaFrequenciaTotem extends StatefulWidget {
  final Map<String, dynamic>? aula;

  const TelaFrequenciaTotem({super.key, this.aula});

  @override
  State<TelaFrequenciaTotem> createState() => _TelaFrequenciaTotemState();
}

class _TelaFrequenciaTotemState extends State<TelaFrequenciaTotem> {
  static const _aulaPadrao = {'nome': 'Mat Pilates', 'professor': 'Ana Silva', 'horario': '08:00'};

  static final _alunosPorAula = <String, List<Map<String, dynamic>>>{
    'Mat Pilates': [
      {'nome': 'Julia Ferreira', 'inicial': 'J', 'status': 'pending'},
      {'nome': 'Carla Santos', 'inicial': 'C', 'status': 'pending'},
      {'nome': 'Beatriz Lima', 'inicial': 'B', 'status': 'present'},
      {'nome': 'Fernanda Costa', 'inicial': 'F', 'status': 'absent'},
      {'nome': 'Priscila Alves', 'inicial': 'P', 'status': 'pending'},
    ],
    'Pilates Funcional': [
      {'nome': 'Amanda Souza', 'inicial': 'A', 'status': 'pending'},
      {'nome': 'Renata Oliveira', 'inicial': 'R', 'status': 'present'},
      {'nome': 'Tatiane Souza', 'inicial': 'T', 'status': 'pending'},
      {'nome': 'Camila Rocha', 'inicial': 'C', 'status': 'absent'},
    ],
    'Yoga Relax': [
      {'nome': 'Luciana Mendes', 'inicial': 'L', 'status': 'present'},
      {'nome': 'Patricia Gomes', 'inicial': 'P', 'status': 'pending'},
      {'nome': 'Sandra Melo', 'inicial': 'S', 'status': 'pending'},
    ],
  };

  late Map<String, dynamic> _aula;
  late List<Map<String, dynamic>> _alunos;
  final _hora = '08:00:00';

  @override
  void initState() {
    super.initState();
    _aula = Map<String, dynamic>.from(widget.aula ?? _aulaPadrao);
    if (!_aula.containsKey('nome')) _aula['nome'] = _aulaPadrao['nome'];
    if (!_aula.containsKey('professor')) _aula['professor'] = _aulaPadrao['professor'];
    if (!_aula.containsKey('horario')) _aula['horario'] = _aulaPadrao['horario'];
    final nome = _aula['nome'] as String;
    _alunos = List<Map<String, dynamic>>.from(
      _alunosPorAula[nome] ?? _alunosPorAula['Mat Pilates']!,
    );
  }

  int _contar(String status) => _alunos.where((a) => a['status'] == status).length;

  void _setStatus(int i, String status) => setState(() => _alunos[i]['status'] = status);

  void _marcarTodos(String status) => setState(() {
        for (final a in _alunos) {
          a['status'] = status;
        }
      });

  @override
  Widget build(BuildContext context) {
    final total = _alunos.length;
    final presentes = _contar('present');
    final faltas = _contar('absent');
    final aguardando = _contar('pending');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF3D2B00)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CircleAvatar(radius: 23, backgroundColor: AppColors.primaryColor, child: const Icon(Icons.waves, color: Colors.white)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fluirê', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF3D2B00))),
                        Text('Controle de Frequência', style: TextStyle(fontSize: 12, color: Color(0xFF9E7C2E))),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: AppColors.sombra, blurRadius: 8)],
                    ),
                    child: Text(_hora, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: [Color(0xFFD4A847), Color(0xFF7A7A2A)]),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AULA EM ANDAMENTO', style: TextStyle(fontSize: 10, color: Color(0xFFFFE5A0), fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                          const SizedBox(height: 6),
                          Text('${_aula['nome']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('${_aula['professor']} · ${_aula['horario']}', style: const TextStyle(fontSize: 13, color: Color(0xFFFFE5A0))),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 68,
                      height: 68,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: total == 0 ? 0 : presentes / total,
                            strokeWidth: 6,
                            color: Colors.white,
                            backgroundColor: Colors.white24,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('$presentes/$total', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                              const Text('pres.', style: TextStyle(fontSize: 9, color: Color(0xFFFFE5A0))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _resumo(AppColors.sucesso, 'Presentes', '$presentes'),
                  const SizedBox(width: 10),
                  _resumo(AppColors.erro, 'Faltas', '$faltas'),
                  const SizedBox(width: 10),
                  _resumo(const Color(0xFF9E9E9E), 'Aguard.', '$aguardando'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: _alunos.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final a = _alunos[i];
                  final presente = a['status'] == 'present';
                  final ausente = a['status'] == 'absent';

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: presente ? const Color(0xFFEDF7ED) : ausente ? const Color(0xFFFDEDED) : Colors.white,
                      boxShadow: [BoxShadow(color: AppColors.sombra, blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryColor,
                        child: Text(a['inicial'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      title: Text(a['nome'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF2A1A00))),
                      subtitle: Text(
                        presente ? 'Presente ✓' : ausente ? 'Ausente ✗' : 'Aguardando confirmação',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: presente ? AppColors.sucesso : ausente ? AppColors.erro : const Color(0xFF9E8050),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _acao(Icons.check_rounded, AppColors.botaoPresente, !presente, () => _setStatus(i, 'present')),
                          const SizedBox(width: 8),
                          _acao(Icons.close_rounded, AppColors.botaoFalta, !ausente, () => _setStatus(i, 'absent')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: AppColors.sombra, blurRadius: 10, offset: const Offset(0, -2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _marcarTodos('present'),
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Marcar Todos'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sucesso,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _marcarTodos('pending'),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Resetar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF9E8050),
                        side: const BorderSide(color: Color(0xFFD4B87A)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resumo(Color cor, String label, String valor) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: AppColors.sombra, blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
              const SizedBox(height: 6),
              Text(valor, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cor)),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9E8050))),
            ],
          ),
        ),
      );

  Widget _acao(IconData icon, Color cor, bool ativo, VoidCallback onTap) => GestureDetector(
        onTap: ativo ? onTap : null,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: ativo ? cor : cor.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      );
}
