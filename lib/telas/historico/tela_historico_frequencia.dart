import 'package:flutter/material.dart';
import 'package:fluire/tema/app_cores.dart';

enum _FiltroHistorico { todos, presente, falta }

class TelaHistoricoFrequencia extends StatefulWidget {
  const TelaHistoricoFrequencia({super.key});

  @override
  State<TelaHistoricoFrequencia> createState() => _TelaHistoricoFrequenciaState();
}

class _TelaHistoricoFrequenciaState extends State<TelaHistoricoFrequencia> {
  static const _pad = EdgeInsets.symmetric(horizontal: 16);

  _FiltroHistorico _filtro = _FiltroHistorico.todos;
  final _buscaController = TextEditingController();

  final List<Map<String, dynamic>> _registros = [
    {
      'nome': 'Julia Ferreira',
      'aula': 'Mat Pilates',
      'professor': 'Ana Silva',
      'presente': true,
      'data': '20/05',
    },
    {
      'nome': 'Carla Santos',
      'aula': 'Reformer',
      'professor': 'Carlos Lima',
      'presente': true,
      'data': '20/05',
    },
    {
      'nome': 'Beatriz Lima',
      'aula': 'Mat Pilates',
      'professor': 'Ana Silva',
      'presente': false,
      'data': '20/05',
    },
    {
      'nome': 'Fernanda Costa',
      'aula': 'Duet Reformer',
      'professor': 'Mariana Costa',
      'presente': true,
      'data': '19/05',
    },
    {
      'nome': 'Priscila Alves',
      'aula': 'Pilates Funcional',
      'professor': 'Mariana Costa',
      'presente': true,
      'data': '19/05',
    },
    {
      'nome': 'Renata Oliveira',
      'aula': 'Reformer',
      'professor': 'Carlos Lima',
      'presente': false,
      'data': '18/05',
    },
    {
      'nome': 'Tatiane Souza',
      'aula': 'Mat Pilates',
      'professor': 'Ana Silva',
      'presente': true,
      'data': '18/05',
    },
    {
      'nome': 'Camila Rocha',
      'aula': 'Pilates Solo',
      'professor': 'Carlos Lima',
      'presente': true,
      'data': '17/05',
    },
  ];

  final List<Map<String, int>> _frequenciaSemanal = [
    {'presencas': 4, 'faltas': 1},
    {'presencas': 3, 'faltas': 0},
    {'presencas': 5, 'faltas': 2},
    {'presencas': 8, 'faltas': 1},
    {'presencas': 6, 'faltas': 2},
    {'presencas': 2, 'faltas': 1},
  ];

  static const _diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

  @override
  void initState() {
    super.initState();
    _buscaController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _registrosFiltrados {
    final termo = _buscaController.text.trim().toLowerCase();
    return _registros.where((r) {
      final presente = r['presente'] == true;
      if (_filtro == _FiltroHistorico.presente && !presente) return false;
      if (_filtro == _FiltroHistorico.falta && presente) return false;
      if (termo.isEmpty) return true;
      final texto =
          '${r['nome']} ${r['aula']} ${r['professor']}'.toLowerCase();
      return texto.contains(termo);
    }).toList();
  }

  int get _totalPresencas =>
      _registros.where((r) => r['presente'] == true).length;

  int get _totalFaltas => _registros.length - _totalPresencas;

  int get _taxaPercentual {
    if (_registros.isEmpty) return 0;
    return ((_totalPresencas / _registros.length) * 100).round();
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconeHeader(Icons.menu, () => _mensagem('Menu em breve')),
                  Text(
                    'Histórico',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoPrimario,
                    ),
                  ),
                  _iconeHeader(
                    Icons.notifications_outlined,
                    () => _mensagem('Notificações em breve'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: _pad,
              child: Row(
                children: [
                  _cardResumo('$_totalPresencas', 'Presenças', AppColors.sucesso),
                  const SizedBox(width: 10),
                  _cardResumo('$_totalFaltas', 'Faltas', AppColors.erro),
                  const SizedBox(width: 10),
                  _cardResumo(
                    '$_taxaPercentual%',
                    'Taxa',
                    AppColors.primaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: _pad,
              child: _graficoSemanal(),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: _pad,
              child: TextField(
                controller: _buscaController,
                decoration: InputDecoration(
                  hintText: 'Buscar aluno ou aula...',
                  hintStyle: TextStyle(color: AppColors.textoSecundario),
                  prefixIcon: Icon(Icons.search, color: AppColors.popUp),
                  filled: true,
                  fillColor: AppColors.fundoCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: _pad,
              child: Row(
                children: [
                  _chipFiltro('Todos', _FiltroHistorico.todos),
                  const SizedBox(width: 8),
                  _chipFiltro('Presente', _FiltroHistorico.presente),
                  const SizedBox(width: 8),
                  _chipFiltro('Falta', _FiltroHistorico.falta),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ..._registrosFiltrados.map(_cardRegistro),
            if (_registrosFiltrados.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Nenhum registro encontrado.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textoSecundario),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _iconeHeader(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: AppColors.fundoCard,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: AppColors.textoPrimario),
      ),
    );
  }

  Widget _cardResumo(String valor, String titulo, Color cor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.fundoCard,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.sombra,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: TextStyle(fontSize: 12, color: AppColors.textoSecundario),
            ),
          ],
        ),
      ),
    );
  }

  Widget _graficoSemanal() {
    final maxValor = _frequenciaSemanal
        .map((d) => d['presencas']! + d['faltas']!)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.sombra,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequência Semanal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textoPrimario,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_diasSemana.length, (i) {
                final dia = _frequenciaSemanal[i];
                final pres = dia['presencas']!;
                final fal = dia['faltas']!;
                const alturaMax = 72.0;

                double alturaBarra(int valor) =>
                    maxValor == 0 ? 0 : (valor / maxValor) * alturaMax;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _barra(alturaBarra(pres), AppColors.sucesso),
                          const SizedBox(width: 3),
                          _barra(alturaBarra(fal), AppColors.erro),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _diasSemana[i],
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textoSecundario,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _barra(double altura, Color cor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 10,
      height: altura < 4 ? 4 : altura,
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _chipFiltro(String label, _FiltroHistorico tipo) {
    final ativo = _filtro == tipo;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _filtro = tipo),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: ativo ? AppColors.primaryColor : AppColors.fundoCard,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: ativo ? AppColors.textoClaro : AppColors.textoPrimario,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardRegistro(Map<String, dynamic> registro) {
    final presente = registro['presente'] == true;
    final corStatus = presente ? AppColors.sucesso : AppColors.erro;

    return Padding(
      padding: _pad.copyWith(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _mensagem(
          '${registro['nome']} — ${presente ? 'presente' : 'falta'} em ${registro['data']}',
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.fundoCard,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: corStatus.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  presente ? Icons.check_rounded : Icons.close_rounded,
                  color: corStatus,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      registro['nome'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textoPrimario,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${registro['aula']} · ${registro['professor']}',
                      style: TextStyle(
                        fontSize: 12,
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
                    presente ? 'presente' : 'falta',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: corStatus,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    registro['data'],
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textoSecundario,
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
}
