import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/utils/estado_carregamento.dart';
import 'package:fluire/providers/provedor_auth.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/widgets/input_padrao/input_padrao.dart';
import 'package:fluire/widgets/botao/botao.dart';
import 'package:fluire/widgets/auth_layout.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final auth = context.read<ProvedorAuth>();
    final ok = await auth.login(_emailCtrl.text, _senhaCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<ProvedorAuth>();
    final carregando = auth.estado == EstadoCarregamento.carregando;

    return AuthLayout(
      titulo: 'Bem-vindo ao Fluirê',
      subtitulo: 'Entre para continuar',
      rodape: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRoutes.cadastro),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Não tem conta? ',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            children: const [
              TextSpan(
                text: 'Cadastre-se',
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
              label: 'E-mail',
              hint: 'seu@email.com',
              controller: _emailCtrl,
              icone: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),
            AppSpacing.gapLg,
            InputPadrao(
              label: 'Senha',
              hint: '••••••••',
              controller: _senhaCtrl,
              icone: Icons.lock_outline,
              obscureText: true,
            ),
            AppSpacing.gapSm,
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.recuperarSenha),
                child: Text(
                  'Esqueceu a senha?',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (auth.mensagemErro != null) ...[
              AppSpacing.gapMd,
              Text(
                auth.mensagemErro!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],
            AppSpacing.gapXl,
            BotaoPrimario(
              texto: 'Entrar',
              carregando: carregando,
              onPressed: carregando ? null : _entrar,
            ),
          ],
        ),
      ),
    );
  }
}
