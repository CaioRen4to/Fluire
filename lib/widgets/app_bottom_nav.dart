import 'package:flutter/material.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/tema/tema.dart';

/// Bottom Navigation Bar compartilhada entre as telas principais.
class AppBottomNav extends StatelessWidget {
  final int indiceAtual;

  const AppBottomNav({
    super.key,
    required this.indiceAtual,
  });

  static const rotasPrincipais = [
    AppRoutes.agenda,
    AppRoutes.alunos,
    AppRoutes.historico,
    AppRoutes.perfil,
  ];

  static int indiceDaRota(String? rota) {
    switch (rota) {
      case AppRoutes.agenda:
        return 0;
      case AppRoutes.alunos:
        return 1;
      case AppRoutes.historico:
        return 2;
      case AppRoutes.perfil:
        return 3;
      default:
        return 0;
    }
  }

  void _navegar(BuildContext context, int indice) {
    if (indice == indiceAtual) return;
    Navigator.pushReplacementNamed(context, rotasPrincipais[indice]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fundoBottomBar,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: indiceAtual.clamp(0, rotasPrincipais.length - 1),
          onTap: (i) => _navegar(context, i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.fundoBottomBar,
          selectedItemColor: AppColors.iconsAtivosColor,
          unselectedItemColor: AppColors.iconsInativosColor,
          selectedLabelStyle: AppTypography.bodySmall.copyWith(
            fontWeight: AppTypography.fontWeightSemiBold,
          ),
          unselectedLabelStyle: AppTypography.bodySmall,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              activeIcon: Icon(Icons.event_note),
              label: 'Agenda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Alunos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              activeIcon: Icon(Icons.history),
              label: 'Histórico',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
