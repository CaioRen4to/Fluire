import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/utils/estado_carregamento.dart';
import 'package:fluire/providers/provedor_auth.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/widgets/input_padrao/input_padrao.dart';
import 'package:fluire/widgets/botao/botao.dart';
import 'package:fluire/widgets/auth_layout.dart';

class TelaValidarCodigoSenha extends StatefulWidget {
  final String email;
  const TelaValidarCodigoSenha({super.key, required this.email});

  @override
  State<TelaValidarCodigoSenha> createState() => _TelaValidarCodigoSenhaState();
}

class _TelaValidarCodigoSenhaState extends State<TelaValidarCodigoSenha> {
  final _codigoCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _alterarSenha() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_senhaCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final auth = context.read<ProvedorAuth>();
    final ok = await auth.validarCodigoAlterarSenha(
      widget.email,
      _codigoCtrl.text,
      _senhaCtrl.text,
    );
    
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha alterada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<ProvedorAuth>();
    final carregando = auth.estado == EstadoCarregamento.carregando;

    return AuthLayout(
      titulo: 'Alterar senha',
      subtitulo: 'Digite o código e nova senha',
      rodape: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Não recebeu o código? ',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            children: const [
              TextSpan(
                text: 'Solicitar novamente',
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
              label: 'Código de 6 dígitos',
              hint: '123456',
              controller: _codigoCtrl,
              icone: Icons.security,
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty || v.length != 6 ? 'Digite o código de 6 dígitos' : null,
            ),
            AppSpacing.gapLg,
            InputPadrao(
              label: 'Nova senha',
              hint: '••••••••',
              controller: _senhaCtrl,
              icone: Icons.lock_outline,
              obscureText: true,
              validator: (v) => v == null || v.isEmpty ? 'Informe a nova senha' : null,
            ),
            AppSpacing.gapLg,
            InputPadrao(
              label: 'Confirmar senha',
              hint: '••••••••',
              controller: _confirmCtrl,
              icone: Icons.lock_outline,
              obscureText: true,
              validator: (v) => v == null || v.isEmpty ? 'Confirme a nova senha' : null,
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
              texto: 'Alterar senha',
              carregando: carregando,
              onPressed: carregando ? null : _alterarSenha,
            ),
          ],
        ),
      ),
    );
  }
}
