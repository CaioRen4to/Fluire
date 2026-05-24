import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:fluire/modelos/aluno.dart';
import 'package:fluire/provedores/provedor_alunos.dart';
import 'package:fluire/componentes/input_padrao/input_padrao.dart';
import 'package:fluire/componentes/modal_padrao/modal_padrao.dart';
import 'package:fluire/componentes/botao/botao.dart';
import 'package:fluire/tema/tema.dart';

class ModalFormularioAluno {
  static Future<Aluno?> abrir({
    required BuildContext context,
    Aluno? aluno,
  }) {
    final criando = aluno == null;
    final nomeCtrl = TextEditingController(text: aluno?.nome ?? '');
    final telCtrl = TextEditingController(text: aluno?.telefone ?? '');
    final emailCtrl = TextEditingController(text: aluno?.email ?? '');
    final modalCtrl = TextEditingController(text: aluno?.modalidade ?? '');
    var ativo = aluno?.ativo ?? true;
    var salvando = false;

    return ModalPadrao.mostrar(
      context: context,
      titulo: criando ? 'Novo aluno' : 'Editar aluno',
      conteudo: StatefulBuilder(
        builder: (ctx, setModalState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputPadrao(label: 'Nome completo', hint: 'Nome do aluno', controller: nomeCtrl, icone: Icons.person_outline),
              AppSpacing.gapLg,
              InputPadrao(label: 'Telefone', hint: '(11) 99999-0000', controller: telCtrl, icone: Icons.phone_outlined, keyboardType: TextInputType.phone),
              AppSpacing.gapLg,
              InputPadrao(label: 'E-mail', hint: 'email@exemplo.com', controller: emailCtrl, icone: Icons.mail_outline, keyboardType: TextInputType.emailAddress),
              AppSpacing.gapLg,
              InputPadrao(label: 'Modalidade', hint: 'Ex: Mat Pilates', controller: modalCtrl, icone: Icons.fitness_center_outlined),
              AppSpacing.gapLg,
              Material(
                color: Colors.transparent,
                child: SwitchListTile(
                  value: ativo,
                  onChanged: (v) => setModalState(() => ativo = v),
                  title: const Text('Aluno ativo'),
                  activeThumbColor: Colors.white,
                ),
              ),
              AppSpacing.gapXl,
              BotaoPrimario(
                texto: criando ? 'Cadastrar' : 'Salvar',
                carregando: salvando,
                onPressed: salvando
                    ? null
                    : () async {
                        setModalState(() => salvando = true);
                        final provider = context.read<ProvedorAlunos>();
                        final novo = Aluno(
                          id: aluno?.id ?? const Uuid().v4(),
                          nome: nomeCtrl.text.trim(),
                          telefone: telCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          modalidade: modalCtrl.text.trim(),
                          presencas: aluno?.presencas ?? 0,
                          faltas: aluno?.faltas ?? 0,
                          ativo: ativo,
                          ultimaAula: aluno?.ultimaAula,
                        );
                        final ok = criando
                            ? await provider.criar(novo)
                            : await provider.atualizar(novo);
                        if (ctx.mounted) {
                          setModalState(() => salvando = false);
                          if (ok) {
                            Navigator.pop(ctx, criando ? null : novo);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(criando ? 'Aluno cadastrado!' : 'Aluno atualizado!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else if (provider.mensagemErro != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(provider.mensagemErro!)),
                            );
                          }
                        }
                      },
              ),
            ],
          );
        },
      ),
    );
  }
}
