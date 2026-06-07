import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

import 'package:fluire/models/aula.dart';

import 'package:fluire/models/professor.dart';

import 'package:fluire/providers/provedor_alunos.dart';

import 'package:fluire/providers/provedor_aulas.dart';

import 'package:fluire/widgets/input_padrao/input_padrao.dart';

import 'package:fluire/widgets/modal_padrao/modal_padrao.dart';

import 'package:fluire/widgets/botao/botao.dart';

import 'package:fluire/theme/tema.dart';



class ModalFormularioAulas {

  static const _frequencias = [

    'Diária',

    'Semanal',

    'Segunda, Quarta e Sexta',

    'Terça e Quinta',

    'Sábado',

  ];



  static Future<void> abrir({

    required BuildContext context,

    Aula? aula,

  }) async {

    final aulaProv = context.read<ProvedorAulas>();

    final alunoProv = context.read<ProvedorAlunos>();



    await Future.wait([

      aulaProv.carregarProfessores(),

      if (alunoProv.alunos.isEmpty) alunoProv.carregar(),

    ]);



    if (!context.mounted) return;



    final criando = aula == null;

    final nomeCtrl = TextEditingController(text: aula?.nome ?? '');

    final inicioCtrl = TextEditingController(text: aula?.horarioInicio ?? '08:00');

    final fimCtrl = TextEditingController(text: aula?.horarioFim ?? '09:00');

    var professorId = aula?.usuarioId.isNotEmpty == true

        ? aula!.usuarioId

        : (aula?.professorId ?? '');

    var frequencia = aula?.frequencia ?? _frequencias[1];

    var diaSemana = aula?.diaSemana ?? 'segunda-feira';

    var status = aula?.status ?? StatusAula.proxima;

    var alunoIds = List<String>.from(aula?.alunoIds ?? []);

    var salvando = false;



    return ModalPadrao.mostrar(

      context: context,

      titulo: criando ? 'Nova aula' : 'Editar aula',

      conteudo: StatefulBuilder(

        builder: (ctx, setModalState) {

          final aulaProvWatch = context.watch<ProvedorAulas>();

          final alunoProvWatch = context.watch<ProvedorAlunos>();

          final professores = aulaProvWatch.professores;



          if (professorId.isEmpty && professores.isNotEmpty) {

            professorId = professores.first.id;

          }



          final professorDropdown = _buildProfessorDropdown(

            carregando: aulaProvWatch.carregandoProfessores,

            professores: professores,

            professorId: professorId,

            erro: aulaProvWatch.mensagemErroProfessores,

            onChanged: (v) => setModalState(() => professorId = v ?? ''),

          );



          return Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [

              InputPadrao(label: 'Nome da aula', hint: 'Ex: Mat Pilates', controller: nomeCtrl, icone: Icons.class_outlined),

              AppSpacing.gapLg,

              Text('Professor', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.w600)),

              AppSpacing.gapSm,

              professorDropdown,

              AppSpacing.gapLg,

              Row(

                children: [

                  Expanded(child: InputPadrao(label: 'Início', controller: inicioCtrl, icone: Icons.schedule)),

                  AppSpacing.gapMdHorizontal,

                  Expanded(child: InputPadrao(label: 'Fim', controller: fimCtrl, icone: Icons.schedule_outlined)),

                ],

              ),

              AppSpacing.gapLg,

              Text('Frequência', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.w600)),

              AppSpacing.gapSm,

              DropdownButtonFormField<String>(

                initialValue: frequencia,

                decoration: InputDecoration(

                  filled: true,

                  fillColor: AppColors.fundoCard,

                  border: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),

                ),

                items: _frequencias.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),

                onChanged: (v) => setModalState(() => frequencia = v ?? frequencia),

              ),

              AppSpacing.gapLg,

              Text('Dia da semana', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.w600)),

              AppSpacing.gapSm,

              DropdownButtonFormField<String>(

                initialValue: diaSemana,

                decoration: InputDecoration(

                  filled: true,

                  fillColor: AppColors.fundoCard,

                  border: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),

                ),

                items: const [
                  DropdownMenuItem(value: 'segunda-feira', child: Text('Segunda')),
                  DropdownMenuItem(value: 'terça-feira', child: Text('Terça')),
                  DropdownMenuItem(value: 'quarta-feira', child: Text('Quarta')),
                  DropdownMenuItem(value: 'quinta-feira', child: Text('Quinta')),
                  DropdownMenuItem(value: 'sexta-feira', child: Text('Sexta')),
                  DropdownMenuItem(value: 'sábado', child: Text('Sábado')),
                  DropdownMenuItem(value: 'domingo', child: Text('Domingo')),
                ],

                onChanged: (v) => setModalState(() => diaSemana = v ?? diaSemana),

              ),

              AppSpacing.gapLg,

              Text('Alunos participantes', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.w600)),

              AppSpacing.gapSm,

              ...alunoProvWatch.alunos.map((aluno) {

                final selecionado = alunoIds.contains(aluno.id);

                return Material(

                  color: Colors.transparent,

                  child: CheckboxListTile(

                    value: selecionado,

                    onChanged: (v) {

                      setModalState(() {

                        if (v == true) {

                          alunoIds.add(aluno.id);

                        } else {

                          alunoIds.remove(aluno.id);

                        }

                      });

                    },

                    title: Text(aluno.nome, style: const TextStyle(fontSize: 14)),

                    dense: true,

                    controlAffinity: ListTileControlAffinity.leading,

                  ),

                );

              }),

              AppSpacing.gapXl,

              BotaoPrimario(

                texto: criando ? 'Criar aula' : 'Salvar',

                carregando: salvando,

                onPressed: salvando || professores.isEmpty

                    ? null

                    : () async {

                        setModalState(() => salvando = true);

                        Professor? prof;

                        try {

                          prof = professores.firstWhere((p) => p.id == professorId);

                        } catch (_) {

                          prof = professores.first;

                        }

                        final nova = Aula(

                          id: aula?.id ?? const Uuid().v4(),

                          nome: nomeCtrl.text.trim(),

                          usuarioId: prof.id,

                          professorId: prof.id,

                          professorNome: prof.nome,

                          horarioInicio: inicioCtrl.text.trim(),

                          horarioFim: fimCtrl.text.trim(),

                          frequencia: frequencia,

                          alunoIds: alunoIds,

                          status: status,

                          diaSemana: diaSemana,

                        );

                        final ok = await aulaProvWatch.salvar(nova, criando: criando);

                        if (ctx.mounted) {

                          setModalState(() => salvando = false);

                          if (ok) {

                            Navigator.pop(ctx);

                            ScaffoldMessenger.of(context).showSnackBar(

                              SnackBar(content: Text(criando ? 'Aula criada!' : 'Aula atualizada!')),

                            );

                          } else if (aulaProvWatch.mensagemErro != null) {

                            ScaffoldMessenger.of(context).showSnackBar(

                              SnackBar(content: Text(aulaProvWatch.mensagemErro!)),

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



  static Widget _buildProfessorDropdown({

    required bool carregando,

    required List<Professor> professores,

    required String professorId,

    required String? erro,

    required ValueChanged<String?> onChanged,

  }) {

    final decoration = InputDecoration(

      filled: true,

      fillColor: AppColors.fundoCard,

      border: OutlineInputBorder(

        borderRadius: AppBorders.radiusSmall,

        borderSide: BorderSide(color: AppColors.divisor),

      ),

    );



    if (carregando) {

      return InputDecorator(

        decoration: decoration,

        child: Row(

          children: [

            SizedBox(

              width: 20,

              height: 20,

              child: CircularProgressIndicator(

                strokeWidth: 2,

                color: AppColors.primaryColor,

              ),

            ),

            AppSpacing.gapMdHorizontal,

            Text('Carregando professores...', style: TextStyle(color: AppColors.textoSecundario)),

          ],

        ),

      );

    }



    if (professores.isEmpty) {

      return InputDecorator(

        decoration: decoration.copyWith(

          errorText: erro ?? 'Nenhum professor cadastrado em /usuarios',

        ),

        child: Text(

          'Cadastre usuários no sistema para vincular à aula',

          style: TextStyle(color: AppColors.textoSecundario, fontSize: 14),

        ),

      );

    }



    final valorValido = professores.any((p) => p.id == professorId) ? professorId : null;



    return DropdownButtonFormField<String>(

      value: valorValido,

      decoration: decoration,

      hint: const Text('Selecione o professor'),

      items: professores

          .map((p) => DropdownMenuItem(value: p.id, child: Text(p.nome)))

          .toList(),

      onChanged: onChanged,

    );

  }

}


