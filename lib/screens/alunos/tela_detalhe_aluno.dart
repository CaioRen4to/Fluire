import 'package:flutter/material.dart';
import 'package:fluire/models/models.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/widgets/layout_tela.dart';
import 'package:fluire/widgets/botao/botao.dart';
import 'package:fluire/utils/utils.dart';
import 'package:fluire/screens/alunos/modal_formulario_aluno.dart';
import 'package:provider/provider.dart';
import 'package:fluire/providers/providers.dart';

class TelaDetalheAluno extends StatefulWidget {
  final Aluno aluno;

  const TelaDetalheAluno({super.key, required this.aluno});

  @override
  State<TelaDetalheAluno> createState() => _TelaDetalheAlunoState();
}

class _TelaDetalheAlunoState extends State<TelaDetalheAluno> {
  late Aluno _alunoAtual;
  bool _alterado = false;

  @override
  void initState() {
    super.initState();
    _alunoAtual = widget.aluno;
  }

  // Cria um AppBar customizado com botão de voltar
  PreferredSizeWidget _appBarComVoltar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textoPrimario),
        onPressed: () => Navigator.pop(context, _alterado),
      ),
      title: Text(
        'Detalhes',
        style: AppTypography.displaySmall.copyWith(color: AppColors.textoPrimario),
      ),
      centerTitle: true,
    );
  }

  static const _historico = [
    {'aula': 'Mat Pilates', 'data': '20/05/2026', 'presente': true},
    {'aula': 'Reformer', 'data': '18/05/2026', 'presente': true},
    {'aula': 'Pilates Funcional', 'data': '15/05/2026', 'presente': false},
    {'aula': 'Duet Reformer', 'data': '10/05/2026', 'presente': true},
  ];

  @override
  Widget build(BuildContext context) {
    final ativo = _alunoAtual.ativo;
    final corStatus = ativo ? AppColors.sucesso : AppColors.erro;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _alterado);
        return false;
      },
      child: LayoutTela(
        titulo: 'Detalhes',
        rotaAtual: AppRoutes.alunos,
        appBarCustom: _appBarComVoltar(context),
        centralizarConteudo: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Animacoes.fadeSlide(
                child: Container(
                width: double.infinity,
                padding: AppSpacing.cardPaddingLarge,
                decoration: BoxDecoration(
                  borderRadius: AppBorders.radiusXXLarge,
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.primaryColor.withValues(alpha: 0.7)],
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(_alunoAtual.inicial, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    AppSpacing.gapLg,
                    Text(_alunoAtual.nome, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    AppSpacing.gapXs,
                    Text(_alunoAtual.modalidade, style: TextStyle(color: AppColors.primariaClara)),
                    AppSpacing.gapLg,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: AppBorders.radiusLarge,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: corStatus)),
                          AppSpacing.gapSmHorizontal,
                          Text(ativo ? 'Ativo' : 'Inativo', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.gapLg,
            LayoutBuilder(
              builder: (context, constraints) {
                final colunas = constraints.maxWidth < 450 ? 1 : 3;
                if (colunas == 1) {
                  return Column(
                    children: [
                      _statRow('${_alunoAtual.presencas}', 'Presenças', AppColors.sucesso),
                      AppSpacing.gapSm,
                      _statRow('${_alunoAtual.faltas}', 'Faltas', AppColors.erro),
                      AppSpacing.gapSm,
                      _statRow('${_alunoAtual.frequenciaPercentual}%', 'Frequência', AppColors.primaryColor),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: _stat('${_alunoAtual.presencas}', 'Presenças', AppColors.sucesso)),
                    AppSpacing.gapSmHorizontal,
                    Expanded(child: _stat('${_alunoAtual.faltas}', 'Faltas', AppColors.erro)),
                    AppSpacing.gapSmHorizontal,
                    Expanded(child: _stat('${_alunoAtual.frequenciaPercentual}%', 'Frequência', AppColors.primaryColor)),
                  ],
                );
              }
            ),
            AppSpacing.gapLg,
            BotaoPrimario(
              texto: 'Editar aluno',
              icone: Icons.edit_outlined,
              onPressed: () async {
                final currentContext = context;
                if (!currentContext.mounted) return;
                final resultado = await ModalFormularioAluno.abrir(context: currentContext, aluno: _alunoAtual);
                if (!currentContext.mounted) return;
                if (resultado != null) {
                  _alterado = true;
                  if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                }
              },
            ),
            AppSpacing.gapMd,
            Container(
              height: 52,
              child: ElevatedButton(
                onPressed: () => _confirmarRemocao(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.erro,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: AppBorders.buttonShape,
                  textStyle: AppTypography.titleLarge,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline, size: 20),
                    SizedBox(width: AppSpacing.sm),
                    Text('Remover aluno'),
                  ],
                ),
              ),
            ),
            AppSpacing.gapLg,
            _bloco(
              'Informações',
              Column(
                children: [
                  _info(Icons.phone, 'Telefone', _alunoAtual.telefone),
                  Divider(color: AppColors.divisor),
                  _info(Icons.mail_outline, 'E-mail', _alunoAtual.email),
                  Divider(color: AppColors.divisor),
                  _info(Icons.fitness_center, 'Modalidade', _alunoAtual.modalidade),
                  if (_alunoAtual.ultimaAula != null) ...[
                    Divider(color: AppColors.divisor),
                    _info(Icons.calendar_month, 'Última aula', _alunoAtual.ultimaAula!),
                  ],
                ],
              ),
            ),
            AppSpacing.gapLg,
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
                            decoration: BoxDecoration(color: cor.withValues(alpha: 0.12), borderRadius: AppBorders.radiusMedium),
                            child: Icon(ok ? Icons.check : Icons.close, color: cor),
                          ),
                          AppSpacing.gapMdHorizontal,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${h['aula']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                Text('${h['data']}', style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario)),
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
            AppSpacing.gapXxl,
          ],
        ),
      ),
    ),
  );
  }

  // Mostra diálogo de confirmação antes de remover
  void _confirmarRemocao(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar remoção'),
        content: Text('Deseja realmente remover o aluno ${_alunoAtual.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<ProvedorAlunos>();
              await provider.remover(_alunoAtual.id);
              if (context.mounted) {
                Navigator.pop(context, true); // Retorna true para indicar que houve alteração
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Aluno removido com sucesso')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.erro),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  Widget _stat(String valor, String titulo, Color cor) => Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(color: AppColors.fundoCard, borderRadius: AppBorders.radiusLarge),
        child: Column(
          children: [
            Text(valor, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cor)),
            AppSpacing.gapXs,
            Text(titulo, style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario)),
          ],
        ),
      );

  Widget _statRow(String valor, String titulo, Color cor) => Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(color: AppColors.fundoCard, borderRadius: AppBorders.radiusLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titulo, style: AppTypography.bodyMedium.copyWith(color: AppColors.textoSecundario, fontWeight: FontWeight.w600)),
            Text(valor, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cor)),
          ],
        ),
      );

  Widget _bloco(String titulo, Widget conteudo) => Container(
        width: double.infinity,
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(color: AppColors.fundoCard, borderRadius: AppBorders.radiusLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: AppTypography.headline),
            AppSpacing.gapLg,
            conteudo,
          ],
        ),
      );

  Widget _info(IconData icon, String titulo, String valor) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryColor),
            AppSpacing.gapMdHorizontal,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario)),
                Text(valor, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      );
}
