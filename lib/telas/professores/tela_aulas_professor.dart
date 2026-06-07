import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/modelos/professor.dart';
import 'package:fluire/provedores/provedor_aulas.dart';
import 'package:fluire/tema/tema.dart';
import 'package:fluire/componentes/layout_tela.dart';
import 'package:fluire/componentes/cards/card_aula.dart';
import 'package:fluire/componentes/estado_visual/estado_visual.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/util/animacoes.dart';

class TelaAulasProfessor extends StatelessWidget {
  final Professor professor;

  const TelaAulasProfessor({
    super.key,
    required this.professor,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProvedorAulas>();
    final aulasDoProfessor = provider.aulas.where((a) => a.usuarioId == professor.id).toList();

    return LayoutTela(
      titulo: 'Aulas de ${professor.nome}',
      rotaAtual: AppRoutes.professores,
      centralizarConteudo: false,
      appBarCustom: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textoPrimario,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Aulas do Professor',
          style: TextStyle(
            color: AppColors.textoPrimario,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.fundoCard,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sombra,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryColor,
                    child: Text(
                      professor.nome.isNotEmpty ? professor.nome[0] : 'P',
                      style: const TextStyle(
                        color: AppColors.textoClaro,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          professor.nome,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textoPrimario,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          professor.email.isNotEmpty ? professor.email : '—',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textoSecundario,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${aulasDoProfessor.length} ${aulasDoProfessor.length == 1 ? 'aula associada' : 'aulas associadas'}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: aulasDoProfessor.isEmpty
                ? const EstadoVazio(
                    titulo: 'Nenhuma aula associada',
                    subtitulo: 'Este professor não possui aulas cadastradas no momento.',
                    icone: Icons.event_busy,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: aulasDoProfessor.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (context, index) {
                      final aula = aulasDoProfessor[index];
                      return Animacoes.fadeSlide(
                        delay: Duration(milliseconds: 40 * index),
                        child: CardAula(
                          aula: aula,
                          totalAlunos: aula.alunoIds.length,
                          onDetalhes: () => Navigator.pushNamed(
                            context,
                            AppRoutes.detalheAula,
                            arguments: aula.id,
                          ),
                          onFrequencia: () => Navigator.pushNamed(
                            context,
                            AppRoutes.frequenciaTotem,
                            arguments: aula,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
