import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/core/estado_carregamento.dart';
import 'package:fluire/providers/auth_provider.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/componentes/input_padrao/input_padrao.dart';
import 'package:fluire/componentes/botao/botao.dart';
import 'package:fluire/widgets/auth_layout.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _emailCtrl = TextEditingController(text: 'admin@fluire.com');
  final _senhaCtrl = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailCtrl.text, _senhaCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacementNamed(context, Rotas.painel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final carregando = auth.estado == EstadoCarregamento.carregando;

    return AuthLayout(
      titulo: 'Bem-vindo ao Fluirê',
      subtitulo: 'Entre para continuar',
      rodape: GestureDetector(
        onTap: () => Navigator.pushNamed(context, Rotas.cadastro),
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
              validator: (v) => v == null || v.isEmpty ? 'Informe o e-mail' : null,
            ),
            AppSpacing.gapLg,
            InputPadrao(
              label: 'Senha',
              hint: '••••••••',
              controller: _senhaCtrl,
              icone: Icons.lock_outline,
              obscureText: true,
              validator: (v) => v == null || v.isEmpty ? 'Informe a senha' : null,
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
