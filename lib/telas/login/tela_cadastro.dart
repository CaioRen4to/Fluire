import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/util/estado_carregamento.dart';
import 'package:fluire/provedores/provedor_auth.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/tema/tema.dart';
import 'package:fluire/componentes/input_padrao/input_padrao.dart';
import 'package:fluire/componentes/botao/botao.dart';
import 'package:fluire/componentes/auth_layout.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final auth = context.read<ProvedorAuth>();
    try {
      final ok = await auth.cadastrar(_nomeCtrl.text, _emailCtrl.text, _senhaCtrl.text);
      if (!mounted) return;
      if (ok) {
        Navigator.pushReplacementNamed(context, AppRoutes.agenda);
      }
    } catch (e) {
      if (e is UnimplementedError) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Integração com backend necessária. Implemente a API de cadastro.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<ProvedorAuth>();
    final carregando = auth.estado == EstadoCarregamento.carregando;

    return AuthLayout(
      titulo: 'Criar sua conta',
      subtitulo: 'Preencha os dados para começar',
      rodape: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Já tem conta? ',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            children: const [
              TextSpan(
                text: 'Entrar',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF302C1D)),
              ),
            ],
          ),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            InputPadrao(
              label: 'Nome completo',
              controller: _nomeCtrl,
              icone: Icons.person_outline,
            ),
            AppSpacing.gapLg,
            InputPadrao(
              label: 'E-mail',
              controller: _emailCtrl,
              icone: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),
            AppSpacing.gapLg,
            InputPadrao(
              label: 'Senha',
              controller: _senhaCtrl,
              icone: Icons.lock_outline,
              obscureText: true,
            ),
            AppSpacing.gapLg,
            InputPadrao(
              label: 'Confirmar senha',
              controller: _confirmCtrl,
              icone: Icons.lock_outline,
              obscureText: true,
            ),
            if (auth.mensagemErro != null) ...[
              AppSpacing.gapMd,
              Text(auth.mensagemErro!, style: const TextStyle(color: Colors.red, fontSize: 13)),
            ],
            AppSpacing.gapXl,
            BotaoPrimario(
              texto: 'Criar conta',
              carregando: carregando,
              onPressed: carregando ? null : _cadastrar,
            ),
          ],
        ),
      ),
    );
  }
}
