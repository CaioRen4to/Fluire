import 'package:flutter/material.dart';
import 'package:fluire/models/registro_auditoria.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/services/historico_service.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/widgets/layout_tela.dart';
import 'package:fluire/widgets/estado_visual/estado_visual.dart';

enum _FiltroHistorico { todos, alunos, aulas, criacao, atualizacao }

class TelaHistoricoFrequencia extends StatefulWidget {
  const TelaHistoricoFrequencia({super.key});

  @override
  State<TelaHistoricoFrequencia> createState() => _TelaHistoricoFrequenciaState();
}

class _TelaHistoricoFrequenciaState extends State<TelaHistoricoFrequencia> {
  final _historicoService = HistoricoService();
  final _buscaController = TextEditingController();

  _FiltroHistorico _filtro = _FiltroHistorico.todos;
  List<RegistroAuditoria> _registros = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _buscaController.addListener(() => setState(() {}));
    _carregar();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final registros = await _historicoService.listarAtividades();
      if (!mounted) return;
      setState(() {
        _registros = registros;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.toString().replaceFirst('Exception: ', '');
        _carregando = false;
      });
    }
  }

  List<RegistroAuditoria> get _registrosFiltrados {
    final termo = _buscaController.text.trim().toLowerCase();
    return _registros.where((r) {
      if (_filtro == _FiltroHistorico.alunos && r.entidade != TipoEntidadeAuditoria.aluno) {
        return false;
      }
      if (_filtro == _FiltroHistorico.aulas && r.entidade != TipoEntidadeAuditoria.aula) {
        return false;
      }
      if (_filtro == _FiltroHistorico.criacao && r.acao != TipoAcaoAuditoria.criacao) {
        return false;
      }
      if (_filtro == _FiltroHistorico.atualizacao && r.acao != TipoAcaoAuditoria.atualizacao) {
        return false;
      }
      if (termo.isEmpty) return true;
      final texto = '${r.titulo} ${r.subtitulo} ${r.rotuloEntidade}'.toLowerCase();
      return texto.contains(termo);
    }).toList();
  }

  int get _totalCriacoes =>
      _registros.where((r) => r.acao == TipoAcaoAuditoria.criacao).length;

  int get _totalAtualizacoes =>
      _registros.where((r) => r.acao == TipoAcaoAuditoria.atualizacao).length;

  @override
  Widget build(BuildContext context) {
    return LayoutTela(
      titulo: 'Histórico',
      rotaAtual: AppRoutes.historico,
      mostrarBottomNav: true,
      centralizarConteudo: false,
      child: _carregando
          ? const EstadoCarregando(mensagem: 'Carregando histórico...')
          : _erro != null
              ? EstadoErro(mensagem: _erro!, onTentarNovamente: _carregar)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _cardResumo('$_totalCriacoes', 'Criações', AppColors.sucesso),
                        AppSpacing.gapSmHorizontal,
                        _cardResumo('$_totalAtualizacoes', 'Atualizações', AppColors.primaryColor),
                        AppSpacing.gapSmHorizontal,
                        _cardResumo('${_registros.length}', 'Total', AppColors.textoPrimario),
                      ],
                    ),
                    AppSpacing.gapLg,
                    TextField(
                      controller: _buscaController,
                      decoration: InputDecoration(
                        hintText: 'Buscar aluno ou aula...',
                        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textoSecundario),
                        prefixIcon: Icon(Icons.search, color: AppColors.popUp),
                        filled: true,
                        fillColor: AppColors.fundoCard,
                        border: OutlineInputBorder(
                          borderRadius: AppBorders.radiusLarge,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    AppSpacing.gapMd,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _chipFiltro('Todos', _FiltroHistorico.todos),
                          AppSpacing.gapSmHorizontal,
                          _chipFiltro('Alunos', _FiltroHistorico.alunos),
                          AppSpacing.gapSmHorizontal,
                          _chipFiltro('Aulas', _FiltroHistorico.aulas),
                          AppSpacing.gapSmHorizontal,
                          _chipFiltro('Criações', _FiltroHistorico.criacao),
                          AppSpacing.gapSmHorizontal,
                          _chipFiltro('Atualizações', _FiltroHistorico.atualizacao),
                        ],
                      ),
                    ),
                    AppSpacing.gapLg,
                    Expanded(
                      child: _registrosFiltrados.isEmpty
                          ? const EstadoVazio(
                              titulo: 'Nenhum registro encontrado',
                              subtitulo: 'As atividades aparecerão aqui conforme alunos e aulas forem criados ou editados.',
                              icone: Icons.history,
                            )
                          : ListView.separated(
                              itemCount: _registrosFiltrados.length,
                              separatorBuilder: (_, __) => AppSpacing.gapMd,
                              itemBuilder: (_, i) => _cardRegistro(_registrosFiltrados[i]),
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _cardResumo(String valor, String titulo, Color cor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.fundoCard,
          borderRadius: AppBorders.radiusLarge,
          boxShadow: AppShadows.cardShadowSmall,
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: TextStyle(
                fontSize: AppTypography.fontSizeH2,
                fontWeight: AppTypography.fontWeightBold,
                color: cor,
              ),
            ),
            AppSpacing.gapXs,
            Text(
              titulo,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipFiltro(String label, _FiltroHistorico tipo) {
    final ativo = _filtro == tipo;
    return GestureDetector(
      onTap: () => setState(() => _filtro = tipo),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: ativo ? AppColors.primaryColor : AppColors.fundoCard,
          borderRadius: AppBorders.radiusXLarge,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: AppTypography.fontWeightSemiBold,
            fontSize: AppTypography.fontSizeMd,
            color: ativo ? AppColors.textoClaro : AppColors.textoPrimario,
          ),
        ),
      ),
    );
  }

  Widget _cardRegistro(RegistroAuditoria registro) {
    final cor = registro.acao == TipoAcaoAuditoria.criacao
        ? AppColors.sucesso
        : AppColors.alerta;

    final isCriacao = registro.acao == TipoAcaoAuditoria.criacao;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        borderRadius: AppBorders.radiusLarge,
        boxShadow: AppShadows.cardShadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  registro.entidade == TipoEntidadeAuditoria.aluno
                      ? Icons.person_outline
                      : Icons.event_note_outlined,
                  color: cor,
                  size: 22,
                ),
              ),
              AppSpacing.gapMdHorizontal,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      registro.titulo,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textoPrimario,
                      ),
                    ),
                    AppSpacing.gapXs,
                    Text(
                      '${registro.rotuloEntidade} · ${registro.subtitulo}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textoSecundario,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                registro.rotuloAcao,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: AppTypography.fontWeightSemiBold,
                  color: cor,
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          _linhaInfo('Criado por', registro.criadoPor ?? 'Não informado'),
          _linhaInfo('Criado em', registro.formatarData(registro.dataCriacao)),
          if (!isCriacao) ...[
            _linhaInfo('Alterado por', registro.atualizadoPor ?? 'Sem alterações'),
            _linhaInfo('Alterado em', registro.dataAtualizacao != null
                ? registro.formatarData(registro.dataAtualizacao)
                : 'Sem alterações'),
          ],
        ],
      ),
    );
  }

  Widget _linhaInfo(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textoPrimario),
            ),
          ),
        ],
      ),
    );
  }
}
