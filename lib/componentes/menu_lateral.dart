import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/provedores/provedor_auth.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/tema/tema.dart';

class MenuLateral extends StatelessWidget {
  final String? rotaAtual;
  final bool permanente;

  const MenuLateral({super.key, this.rotaAtual, this.permanente = false});

  static void ir(BuildContext context, String rota, {bool permanente = false}) {
    final navigator = Navigator.of(context);
    final atual = ModalRoute.of(context)?.settings.name;
    if (!permanente) {
      navigator.pop();
    }
    if (atual != rota) {
      navigator.pushReplacementNamed(rota);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.fundoCard,
      elevation: permanente ? 0 : null,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: const Icon(Icons.waves, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Fluirê',
                    style: AppTypography.displaySmall.copyWith(color: AppColors.textoPrimario),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _item(context, Icons.dashboard_outlined, 'Painel', Rotas.painel),
            _item(context, Icons.people_outline, 'Alunos', Rotas.alunos),
            _item(context, Icons.event_note_outlined, 'Aulas', Rotas.aulas),
            _item(context, Icons.history, 'Histórico', Rotas.historico),
            _item(context, Icons.person_outline, 'Perfil', Rotas.perfil),
            const Spacer(),
            const Divider(height: 1),
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.logout, color: AppColors.erro),
                title: Text(
                  'Sair',
                  style: TextStyle(color: AppColors.erro, fontWeight: AppTypography.fontWeightSemiBold),
                ),
                onTap: () async {
                  await context.read<ProvedorAuth>().logout();
                  if (context.mounted) {
                    if (!permanente) {
                      Navigator.of(context).pop();
                    }
                    Navigator.of(context).pushReplacementNamed(Rotas.login);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String titulo, String rota, {bool push = false}) {
    final ativo = rotaAtual == rota;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: ativo ? AppColors.primaryColor : AppColors.textoSecundario),
        title: Text(
          titulo,
          style: TextStyle(
            fontWeight: ativo ? FontWeight.bold : FontWeight.w500,
            color: ativo ? AppColors.primaryColor : AppColors.textoPrimario,
          ),
        ),
        selected: ativo,
        onTap: () {
          if (!permanente) {
            Navigator.pop(context);
          }
          if (push) {
            Navigator.pushNamed(context, rota);
          } else {
            if (ModalRoute.of(context)?.settings.name != rota) {
              Navigator.pushReplacementNamed(context, rota);
            }
          }
        },
      ),
    );
  }
}

class BotaoMenu extends StatelessWidget {
  const BotaoMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {
        return Material(
          color: AppColors.fundoCard,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              final scaffold = Scaffold.maybeOf(ctx);
              if (scaffold != null && scaffold.hasDrawer) {
                scaffold.openDrawer();
              }
            },
            child: const SizedBox(
              width: 48,
              height: 48,
              child: Icon(Icons.menu, color: AppColors.textoPrimario),
            ),
          ),
        );
      },
    );
  }
}
