import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/models/models.dart';
import 'package:fluire/providers/providers.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/api/api_services.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/widgets/layout_tela.dart';
import 'package:fluire/utils/utils.dart';

class TelaFrequenciaTotem extends StatefulWidget {
  final Aula? aula;

  const TelaFrequenciaTotem({super.key, this.aula});

  @override
  State<TelaFrequenciaTotem> createState() => _TelaFrequenciaTotemState();
}

class _TelaFrequenciaTotemState extends State<TelaFrequenciaTotem> {
  final _frequenciaService = FrequenciaService();
  late Aula _aula;
  late List<RegistroFrequencia> _registros;
  bool _salvando = false;
  late String _hora;

  @override
  void initState() {
    super.initState();
    final agora = DateTime.now();
    _hora =
        '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}:${agora.second.toString().padLeft(2, '0')}';
    _aula =
        widget.aula ??
        const Aula(
          id: 'default',
          nome: 'Mat Pilates',
          usuarioId: 'u1',
          professorId: 'p1',
          professorNome: 'Ana Silva',
          horarioInicio: '08:00',
          horarioFim: '09:00',
          frequencia: 'Semanal',
        );
    _registros = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<ProvedorAlunos>().alunos.isEmpty) {
        context.read<ProvedorAlunos>().carregar().then(
          (_) => _montarRegistrosComProvider(),
        );
      } else {
        _montarRegistrosComProvider();
      }
    });
  }

  void _montarRegistrosComProvider() {
    if (!mounted) return;
    final alunos = context.read<ProvedorAlunos>().alunos;
    final ids = _aula.alunoIds;
    final participantes = ids.isEmpty
        ? alunos.take(5)
        : alunos.where((a) => ids.contains(a.id));
    setState(() {
      _registros = participantes
          .map(
            (a) => RegistroFrequencia(
              alunoId: a.id,
              alunoNome: a.nome,
              inicial: a.inicial,
              status: StatusPresenca.pendente,
            ),
          )
          .toList();
    });
  }

  int _contar(StatusPresenca s) =>
      _registros.where((r) => r.status == s).length;

  void _setStatus(int i, StatusPresenca status) =>
      setState(() => _registros[i].status = status);

  void _marcarTodos(StatusPresenca status) => setState(() {
    for (final r in _registros) {
      r.status = status;
    }
  });

  Future<void> _salvarFrequencia() async {
    final aulaId = int.tryParse(_aula.id);
    if (aulaId == null) {
      _mostrarMensagem('Selecione uma aula válida para salvar a frequência.');
      return;
    }

    setState(() => _salvando = true);
    final hoje = DateTime.now();
    final data =
        '${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';

    try {
      for (final registro in _registros) {
        if (registro.status == StatusPresenca.pendente) continue;
        final alunoId = int.tryParse(registro.alunoId);
        if (alunoId == null) continue;

        await _frequenciaService.registrar(
          aulaId: aulaId,
          alunoId: alunoId,
          presente: registro.status == StatusPresenca.presente ? 1 : 0,
          dataPresenca: data,
        );
      }

      if (mounted) {
        _mostrarMensagem('Frequência salva com sucesso!');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        _mostrarMensagem(e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  void _mostrarMensagem(String texto) {
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
    final total = _registros.length;
    final presentes = _contar(StatusPresenca.presente);
    final faltas = _contar(StatusPresenca.ausente);
    final aguardando = _contar(StatusPresenca.pendente);

    return LayoutTela(
      titulo: 'Frequência',
      rotaAtual: AppRoutes.frequenciaTotem,
      centralizarConteudo: false,
      appBarCustom: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textoPrimario),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Controle de frequência'),
        centerTitle: true,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Animacoes.fadeSlide(
              child: Container(
                padding: AppSpacing.cardPaddingLarge,
                decoration: BoxDecoration(
                  borderRadius: AppBorders.radiusXLarge,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AULA EM ANDAMENTO',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          AppSpacing.gapSm,
                          Text(
                            _aula.nome,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_aula.professorNome} · ${_aula.horario}',
                            style: TextStyle(
                              color: AppColors.primariaClara,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hora: $_hora',
                            style: TextStyle(
                              color: AppColors.primariaClara,
                              fontSize: 12,
                            ),
                          ),
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
                          Text(
                            '$presentes/$total',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppSpacing.gapMd,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _resumo(AppColors.sucesso, 'Presentes', '$presentes'),
                AppSpacing.gapSmHorizontal,
                _resumo(AppColors.erro, 'Faltas', '$faltas'),
                AppSpacing.gapSmHorizontal,
                _resumo(AppColors.textoSecundario, 'Aguard.', '$aguardando'),
              ],
            ),
          ),
          AppSpacing.gapLg,
          Expanded(
            child: _registros.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _registros.length,
                    separatorBuilder: (_, _) => AppSpacing.gapMd,
                    itemBuilder: (_, i) => _cardAluno(i),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.fundoCard,
              boxShadow: [
                BoxShadow(
                  color: AppColors.sombra,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 450;
                if (isNarrow) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _salvando ? null : _salvarFrequencia,
                              icon: _salvando
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.save_outlined),
                              label: Text(_salvando ? 'Salvando...' : 'Salvar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppBorders.radiusMedium,
                                ),
                              ),
                            ),
                          ),
                          AppSpacing.gapSmHorizontal,
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _marcarTodos(StatusPresenca.presente),
                              icon: const Icon(Icons.check_rounded),
                              label: const Text('Marcar todos'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.sucesso,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppBorders.radiusMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapSm,
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _marcarTodos(StatusPresenca.pendente),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Resetar'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppBorders.radiusMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _salvando ? null : _salvarFrequencia,
                          icon: _salvando
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(_salvando ? 'Salvando...' : 'Salvar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppBorders.radiusMedium,
                            ),
                          ),
                        ),
                      ),
                      AppSpacing.gapMdHorizontal,
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _marcarTodos(StatusPresenca.presente),
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('Marcar todos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.sucesso,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppBorders.radiusMedium,
                            ),
                          ),
                        ),
                      ),
                      AppSpacing.gapMdHorizontal,
                      OutlinedButton.icon(
                        onPressed: () => _marcarTodos(StatusPresenca.pendente),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Resetar'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppBorders.radiusMedium,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardAluno(int i) {
    final r = _registros[i];
    final presente = r.status == StatusPresenca.presente;
    final ausente = r.status == StatusPresenca.ausente;
    final corFundo = presente
        ? AppColors.sucesso.withValues(alpha: 0.08)
        : ausente
        ? AppColors.erro.withValues(alpha: 0.08)
        : AppColors.fundoCard;

    return Animacoes.fadeSlide(
      delay: Duration(milliseconds: 25 * i),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppBorders.radiusLarge,
          color: corFundo,
          boxShadow: [
            BoxShadow(
              color: AppColors.sombra,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              child: Text(
                r.inicial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              r.alunoNome,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              presente
                  ? 'Presente ✓'
                  : ausente
                  ? 'Ausente ✗'
                  : 'Aguardando',
              style: TextStyle(
                color: presente
                    ? AppColors.sucesso
                    : ausente
                    ? AppColors.erro
                    : AppColors.textoSecundario,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _acao(
                  Icons.check_rounded,
                  AppColors.botaoPresente,
                  !presente,
                  () => _setStatus(i, StatusPresenca.presente),
                ),
                AppSpacing.gapSmHorizontal,
                _acao(
                  Icons.close_rounded,
                  AppColors.botaoFalta,
                  !ausente,
                  () => _setStatus(i, StatusPresenca.ausente),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resumo(Color cor, String label, String valor) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        borderRadius: AppBorders.radiusLarge,
      ),
      child: Column(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
          ),
          AppSpacing.gapSm,
          Text(
            valor,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textoSecundario,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _acao(IconData icon, Color cor, bool ativo, VoidCallback onTap) =>
      GestureDetector(
        onTap: ativo ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: ativo ? cor : cor.withValues(alpha: 0.35),
            borderRadius: AppBorders.radiusSmall,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      );
}


enum StatusPresenca { pendente, presente, ausente }

class RegistroFrequencia {
  final String alunoId;
  final String alunoNome;
  final String inicial;
  StatusPresenca status;

  RegistroFrequencia({
    required this.alunoId,
    required this.alunoNome,
    required this.inicial,
    this.status = StatusPresenca.pendente,
  });
}
