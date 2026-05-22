import 'package:flutter/material.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_cores.dart';

class MenuLateral extends StatelessWidget {
  final String? rotaAtual;

  const MenuLateral({super.key, this.rotaAtual});

  static void ir(BuildContext context, String rota) {
    final navigator = Navigator.of(context);
    final atual = ModalRoute.of(context)?.settings.name;
    navigator.pop();
    if (atual != rota) {
      navigator.pushReplacementNamed(rota);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.fundoCard,
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoPrimario,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _item(context, Icons.dashboard_outlined, 'Painel', Rotas.painel),
            _item(context, Icons.event_note_outlined, 'Agenda', Rotas.agenda),
            _item(context, Icons.people_outline, 'Alunos', Rotas.alunos),
            _item(context, Icons.fact_check_outlined, 'Frequência', Rotas.frequenciaTotem),
            _item(context, Icons.history, 'Histórico', Rotas.historico),
            _item(context, Icons.school_outlined, 'Professores', Rotas.professores),
            const Spacer(),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.erro),
              title: Text(
                'Sair',
                style: TextStyle(color: AppColors.erro, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(Rotas.login);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String titulo, String rota) {
    final ativo = rotaAtual == rota;
    return ListTile(
      leading: Icon(
        icon,
        color: ativo ? AppColors.primaryColor : AppColors.textoSecundario,
      ),
      title: Text(
        titulo,
        style: TextStyle(
          fontWeight: ativo ? FontWeight.bold : FontWeight.w500,
          color: ativo ? AppColors.primaryColor : AppColors.textoPrimario,
        ),
      ),
      selected: ativo,
      onTap: () => ir(context, rota),
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
