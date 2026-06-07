import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/utils/utils.dart';
import 'package:fluire/providers/providers.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/widgets/input_padrao/input_padrao.dart';
import 'package:fluire/widgets/botao/botao.dart';
import 'package:fluire/widgets/auth_layout.dart';

class TelaRecuperarSenha extends StatefulWidget {
  const TelaRecuperarSenha({super.key});

  @override
  State<TelaRecuperarSenha> createState() => _TelaRecuperarSenhaState();
}

class _TelaRecuperarSenhaState extends State<TelaRecuperarSenha> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _recuperar() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<ProvedorAuth>();
    final ok = await auth.recuperarSenha(_emailCtrl.text);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código de recuperação enviado para seu e-mail'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushNamed(
        context,
        AppRoutes.validarCodigoSenha,
        arguments: _emailCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<ProvedorAuth>();
    final carregando = auth.estado == EstadoCarregamento.carregando;

    return AuthLayout(
      titulo: 'Recuperar senha',
      subtitulo: 'Digite seu e-mail para receber o código',
      rodape: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Lembrou sua senha? ',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            children: const [
              TextSpan(
                text: 'Voltar ao login',
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
            if (auth.mensagemErro != null) ...[
              AppSpacing.gapMd,
              Text(
                auth.mensagemErro!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],
            AppSpacing.gapXl,
            BotaoPrimario(
              texto: 'Enviar código',
              carregando: carregando,
              onPressed: carregando ? null : _recuperar,
            ),
          ],
        ),
      ),
    );
  }
}
