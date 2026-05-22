import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:fluire/models/aula.dart';
import 'package:fluire/models/professor.dart';
import 'package:fluire/providers/aluno_provider.dart';
import 'package:fluire/providers/aula_provider.dart';
import 'package:fluire/componentes/input_padrao.dart';
import 'package:fluire/componentes/modal_padrao.dart';
import 'package:fluire/componentes/botao.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';

class ModalFormularioAula {
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
  }) {
    final criando = aula == null;
    final nomeCtrl = TextEditingController(text: aula?.nome ?? '');
    final inicioCtrl = TextEditingController(text: aula?.horarioInicio ?? '08:00');
    final fimCtrl = TextEditingController(text: aula?.horarioFim ?? '09:00');
    var professorId = aula?.professorId ?? '';
    var frequencia = aula?.frequencia ?? _frequencias[1];
    var diaSemana = aula?.diaSemana ?? 1;
    var status = aula?.status ?? StatusAula.proxima;
    var alunoIds = List<String>.from(aula?.alunoIds ?? []);
    var salvando = false;

    return ModalPadrao.mostrar(
      context: context,
      titulo: criando ? 'Nova aula' : 'Editar aula',
      conteudo: StatefulBuilder(
        builder: (ctx, setModalState) {
          final aulaProv = context.watch<AulaProvider>();
          final alunoProv = context.watch<AlunoProvider>();
          final professores = aulaProv.professores;
          if (professorId.isEmpty && professores.isNotEmpty) {
            professorId = professores.first.id;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputPadrao(label: 'Nome da aula', hint: 'Ex: Mat Pilates', controller: nomeCtrl, icone: Icons.class_outlined),
              AppSpacing.gapLg,
              Text('Professor', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.w600)),
              AppSpacing.gapSm,
              DropdownButtonFormField<String>(
                value: professorId.isEmpty ? null : professorId,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.fundoCard,
                  border: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),
                ),
                items: professores
                    .map((p) => DropdownMenuItem(value: p.id, child: Text(p.nome)))
                    .toList(),
                onChanged: (v) => setModalState(() => professorId = v ?? ''),
              ),
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
                value: frequencia,
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
              DropdownButtonFormField<int>(
                value: diaSemana,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.fundoCard,
                  border: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Segunda')),
                  DropdownMenuItem(value: 2, child: Text('Terça')),
                  DropdownMenuItem(value: 3, child: Text('Quarta')),
                  DropdownMenuItem(value: 4, child: Text('Quinta')),
                  DropdownMenuItem(value: 5, child: Text('Sexta')),
                  DropdownMenuItem(value: 6, child: Text('Sábado')),
                ],
                onChanged: (v) => setModalState(() => diaSemana = v ?? diaSemana),
              ),
              AppSpacing.gapLg,
              Text('Alunos participantes', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.w600)),
              AppSpacing.gapSm,
              ...alunoProv.alunos.map((aluno) {
                final selecionado = alunoIds.contains(aluno.id);
                return CheckboxListTile(
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
                );
              }),
              AppSpacing.gapXl,
              BotaoPrimario(
                texto: criando ? 'Criar aula' : 'Salvar',
                carregando: salvando,
                onPressed: salvando
                    ? null
                    : () async {
                        setModalState(() => salvando = true);
                        Professor? prof;
                        try {
                          prof = professores.firstWhere((p) => p.id == professorId);
                        } catch (_) {
                          prof = professores.isNotEmpty ? professores.first : null;
                        }
                        if (prof == null) {
                          setModalState(() => salvando = false);
                          return;
                        }
                        final nova = Aula(
                          id: aula?.id ?? const Uuid().v4(),
                          nome: nomeCtrl.text.trim(),
                          professorId: prof.id,
                          professorNome: prof.nome,
                          horarioInicio: inicioCtrl.text.trim(),
                          horarioFim: fimCtrl.text.trim(),
                          frequencia: frequencia,
                          alunoIds: alunoIds,
                          status: status,
                          diaSemana: diaSemana,
                        );
                        final ok = await aulaProv.salvar(nova, criando: criando);
                        if (ctx.mounted) {
                          setModalState(() => salvando = false);
                          if (ok) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(criando ? 'Aula criada!' : 'Aula atualizada!')),
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
