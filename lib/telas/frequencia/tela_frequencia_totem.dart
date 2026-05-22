import 'package:flutter/material.dart';
import '../../tema/app_cores.dart';
import '../../tema/app_tipografia.dart';
import '../../tema/app_espacamento.dart';
import '../../tema/app_bordas.dart';
import '../../tema/app_sombras.dart';

class TelaFrequenciaTotem extends StatefulWidget {
  const TelaFrequenciaTotem({super.key});

  @override
  State<TelaFrequenciaTotem> createState() => _TelaFrequenciaTotemState();
}

class _TelaFrequenciaTotemState extends State<TelaFrequenciaTotem> {
  final _aula = {'nome': 'Mat Pilates', 'professor': 'Ana Silva', 'horario': '08:00'};
  final _hora = '08:00:00';

  final List<Map<String, dynamic>> _alunos = [
    {'nome': 'Julia Ferreira', 'inicial': 'J', 'status': 'pending'},
    {'nome': 'Carla Santos', 'inicial': 'C', 'status': 'pending'},
    {'nome': 'Beatriz Lima', 'inicial': 'B', 'status': 'present'},
    {'nome': 'Fernanda Costa', 'inicial': 'F', 'status': 'absent'},
    {'nome': 'Priscila Alves', 'inicial': 'P', 'status': 'pending'},
  ];

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
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: AppSpacing.screenPadding,
              child: Row(
                children: [
                  CircleAvatar(radius: 23, backgroundColor: AppColors.primaryColor, child: const Icon(Icons.waves, color: Colors.white)),
                  AppSpacing.gapMdHorizontal,
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
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppBorders.radiusMedium,
                      boxShadow: AppShadows.cardShadowSmall,
                    ),
                    child: Text(_hora, style: TextStyle(fontSize: AppTypography.fontSizeLg, fontWeight: AppTypography.fontWeightBold, letterSpacing: 1.2)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppSpacing.screenPaddingHorizontal,
              child: Container(
                padding: AppSpacing.cardPaddingLarge,
                decoration: BoxDecoration(
                  borderRadius: AppBorders.radiusXLarge,
                  gradient: const LinearGradient(colors: [Color(0xFFD4A847), Color(0xFF7A7A2A)]),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AULA EM ANDAMENTO', style: TextStyle(fontSize: AppTypography.fontSizeXs, color: Color(0xFFFFE5A0), fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                          AppSpacing.gapSm,
                          Text(_aula['nome']!, style: TextStyle(fontSize: AppTypography.fontSizeH2, fontWeight: AppTypography.fontWeightBold, color: Colors.white)),
                          AppSpacing.gapXs,
                          Text('${_aula['professor']} · ${_aula['horario']}', style: TextStyle(fontSize: AppTypography.fontSizeSm, color: Color(0xFFFFE5A0))),
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
            AppSpacing.gapMd,
            Padding(
              padding: AppSpacing.screenPaddingHorizontal,
              child: Row(
                children: [
                  _resumo(AppColors.sucesso, 'Presentes', '$presentes'),
                  AppSpacing.gapSmHorizontal,
                  _resumo(AppColors.erro, 'Faltas', '$faltas'),
                  AppSpacing.gapSmHorizontal,
                  _resumo(const Color(0xFF9E9E9E), 'Aguard.', '$aguardando'),
                ],
              ),
            ),
            AppSpacing.gapLg,
            Expanded(
              child: ListView.separated(
                padding: AppSpacing.screenPaddingHorizontal.copyWith(top: AppSpacing.xs),
                itemCount: _alunos.length,
                separatorBuilder: (_, _) => AppSpacing.gapSm,
                itemBuilder: (_, i) {
                  final a = _alunos[i];
                  final presente = a['status'] == 'present';
                  final ausente = a['status'] == 'absent';

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: AppBorders.radiusLarge,
                      color: presente ? const Color(0xFFEDF7ED) : ausente ? const Color(0xFFFDEDED) : Colors.white,
                      boxShadow: AppShadows.cardShadowSmall,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryColor,
                        child: Text(a['inicial'], style: TextStyle(fontSize: AppTypography.fontSizeLg, fontWeight: AppTypography.fontWeightBold, color: Colors.white)),
                      ),
                      title: Text(a['nome'], style: TextStyle(fontSize: AppTypography.fontSizeMd, fontWeight: AppTypography.fontWeightSemiBold, color: const Color(0xFF2A1A00))),
                      subtitle: Text(
                        presente ? 'Presente ✓' : ausente ? 'Ausente ✗' : 'Aguardando confirmação',
                        style: TextStyle(
                          fontSize: AppTypography.fontSizeSm,
                          fontWeight: AppTypography.fontWeightMedium,
                          color: presente ? AppColors.sucesso : ausente ? AppColors.erro : const Color(0xFF9E8050),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _acao(Icons.check_rounded, AppColors.botaoPresente, !presente, () => _setStatus(i, 'present')),
                          AppSpacing.gapXsHorizontal,
                          _acao(Icons.close_rounded, AppColors.botaoFalta, !ausente, () => _setStatus(i, 'absent')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: AppSpacing.screenPadding.copyWith(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: AppShadows.elevatedShadow,
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
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: AppBorders.radiusMedium),
                      ),
                    ),
                  ),
                  AppSpacing.gapSmHorizontal,
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _marcarTodos('pending'),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Resetar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF9E8050),
                        side: const BorderSide(color: Color(0xFFD4B87A)),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        shape: RoundedRectangleBorder(borderRadius: AppBorders.radiusMedium),
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
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppBorders.radiusMedium,
            boxShadow: AppShadows.cardShadowSmall,
          ),
          child: Column(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
              AppSpacing.gapSm,
              Text(valor, style: TextStyle(fontSize: AppTypography.fontSizeLg, fontWeight: AppTypography.fontWeightBold, color: cor)),
              AppSpacing.gapXs,
              Text(label, style: TextStyle(fontSize: AppTypography.fontSizeXs, color: const Color(0xFF9E8050))),
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
            borderRadius: AppBorders.radiusMedium,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      );
}
