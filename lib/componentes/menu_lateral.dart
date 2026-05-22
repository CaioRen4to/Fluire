import 'package:flutter/material.dart';
import '../../tema/app_cores.dart';
import '../../tema/app_tipografia.dart';
import '../../tema/app_espacamento.dart';
import '../../tema/app_bordas.dart';
import '../../rotas.dart';

class MenuLateral extends StatelessWidget {
  final String rotaAtual;

  const MenuLateral({super.key, required this.rotaAtual});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.fundoCard,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: AppSpacing.screenPadding.copyWith(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.gapXl,
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.textoClaro,
                          borderRadius: AppBorders.radiusLarge,
                        ),
                        child: Icon(Icons.waves, color: AppColors.primaryColor, size: 32),
                      ),
                      AppSpacing.gapMdHorizontal,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fluirê', style: AppTypography.titleLarge.copyWith(color: AppColors.textoClaro)),
                          Text('Sistema de Gestão', style: AppTypography.bodySmall.copyWith(color: AppColors.primariaClara)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,
            _menuItem(Icons.dashboard, 'Painel', Rotas.painel, rotaAtual == Rotas.painel, context),
            _menuItem(Icons.people, 'Alunos', Rotas.alunos, rotaAtual == Rotas.alunos, context),
            _menuItem(Icons.calendar_today, 'Agenda', Rotas.agenda, rotaAtual == Rotas.agenda, context),
            _menuItem(Icons.history, 'Histórico', Rotas.historico, rotaAtual == Rotas.historico, context),
            const Spacer(),
            _menuItem(Icons.logout, 'Sair', Rotas.login, false, context),
            AppSpacing.gapLg,
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, String rota, bool selecionado, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: selecionado ? AppColors.primaryColor : AppColors.textoSecundario),
      title: Text(label, style: AppTypography.bodyLarge.copyWith(color: selecionado ? AppColors.primaryColor : AppColors.textoPrimario, fontWeight: selecionado ? AppTypography.fontWeightBold : AppTypography.fontWeightRegular)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, rota);
      },
      selected: selecionado,
      selectedTileColor: AppColors.primariaClara,
    );
  }
}
