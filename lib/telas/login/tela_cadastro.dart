import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/core/estado_carregamento.dart';
import 'package:fluire/providers/auth_provider.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/componentes/input_padrao.dart';
import 'package:fluire/componentes/botao.dart';
import 'package:fluire/widgets/auth_layout.dart';

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
    if (!_formKey.currentState!.validate()) return;
    if (_senhaCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }
    final auth = context.read<AuthProvider>();
    final ok = await auth.cadastrar(_nomeCtrl.text, _emailCtrl.text, _senhaCtrl.text);
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
      titulo: 'Criar sua conta',
      subtitulo: 'Preencha os dados para começar',
      rodape: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, Rotas.login),
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
              validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
            ),
            AppSpacing.gapLg,
            InputPadrao(
              label: 'E-mail',
              controller: _emailCtrl,
              icone: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v == null || v.isEmpty ? 'Informe o e-mail' : null,
            ),
            AppSpacing.gapLg,
            InputPadrao(
              label: 'Senha',
              controller: _senhaCtrl,
              icone: Icons.lock_outline,
              obscureText: true,
              validator: (v) => v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
            ),
            AppSpacing.gapLg,
            InputPadrao(
              label: 'Confirmar senha',
              controller: _confirmCtrl,
              icone: Icons.lock_outline,
              obscureText: true,
              validator: (v) => v == null || v.isEmpty ? 'Confirme a senha' : null,
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
