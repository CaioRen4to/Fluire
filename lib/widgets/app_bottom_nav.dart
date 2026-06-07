import 'package:flutter/material.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/theme/tema.dart';

/// Bottom Navigation Bar compartilhada entre as telas principais.
class AppBottomNav extends StatelessWidget {
  final int indiceAtual;

  const AppBottomNav({super.key, required this.indiceAtual});

  static const rotasPrincipais = [
    AppRoutes.dashboard,
    AppRoutes.alunos,
    AppRoutes.aulas,
    AppRoutes.historico,
    AppRoutes.perfil,
  ];

  static int indiceDaRota(String? rota) {
    switch (rota) {
      case AppRoutes.dashboard:
        return 0;
      case AppRoutes.alunos:
        return 1;
      case AppRoutes.aulas:
        return 2;
      case AppRoutes.historico:
        return 3;
      case AppRoutes.perfil:
        return 4;
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
        border: Border(
          top: BorderSide(
            color: AppColors.divisor.withValues(alpha: 230),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
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
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.textoSecundario,
          selectedIconTheme: const IconThemeData(size: 24),
          unselectedIconTheme: const IconThemeData(size: 22),
          selectedLabelStyle: AppTypography.bodySmall.copyWith(
            fontWeight: AppTypography.fontWeightSemiBold,
          ),
          unselectedLabelStyle: AppTypography.bodySmall,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Alunos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              activeIcon: Icon(Icons.event_note),
              label: 'Aulas',
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
