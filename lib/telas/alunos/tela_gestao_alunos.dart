import 'package:flutter/material.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/tema/app_sombras.dart';
import 'package:fluire/componentes/menu_lateral.dart';

class TelaGestaoAlunos extends StatelessWidget {
  TelaGestaoAlunos({super.key});

  final List<Map<String, dynamic>> alunos = [
    {'nome': 'Julia Ferreira', 'inicial': 'J', 'telefone': '(11) 99999-1111', 'modalidade': 'Mat Pilates', 'presencas': 32, 'status': true},
    {'nome': 'Carla Santos', 'inicial': 'C', 'telefone': '(11) 99999-2222', 'modalidade': 'Reformer', 'presencas': 28, 'status': true},
    {'nome': 'Amanda Souza', 'inicial': 'A', 'telefone': '(11) 99999-3333', 'modalidade': 'Pilates Funcional', 'presencas': 12, 'status': false},
    {'nome': 'Fernanda Costa', 'inicial': 'F', 'telefone': '(11) 99999-4444', 'modalidade': 'Duet Reformer', 'presencas': 45, 'status': true},
  ];

  @override
  Widget build(BuildContext context) {
    final ativos = alunos.where((a) => a['status'] == true).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const MenuLateral(rotaAtual: Rotas.alunos),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicionar aluno')),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: AppSpacing.screenPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _icone(Icons.menu),
                  Text('Alunos', style: AppTypography.displaySmall.copyWith(color: AppColors.textoPrimario)),
                  _icone(Icons.notifications_outlined),
                ],
              ),
            ),
            Padding(
              padding: AppSpacing.screenPaddingHorizontal,
              child: Row(
                children: [
                  _resumo('${alunos.length}', 'Total', AppColors.primaryColor),
                  AppSpacing.gapSmHorizontal,
                  _resumo('$ativos', 'Ativos', AppColors.sucesso),
                  AppSpacing.gapSmHorizontal,
                  _resumo('${alunos.length - ativos}', 'Inativos', AppColors.erro),
                ],
              ),
            ),
            AppSpacing.gapLg,
            Padding(
              padding: AppSpacing.screenPaddingHorizontal,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar aluno...',
                  prefixIcon: Icon(Icons.search, color: AppColors.popUp),
                  filled: true,
                  fillColor: AppColors.fundoCard,
                  border: OutlineInputBorder(borderRadius: AppBorders.radiusXLarge, borderSide: BorderSide.none),
                ),
              ),
            ),
            AppSpacing.gapLg,
            Expanded(
              child: ListView.separated(
                padding: AppSpacing.screenPaddingHorizontal,
                itemCount: alunos.length,
                separatorBuilder: (_, _) => AppSpacing.gapSm,
                itemBuilder: (_, i) {
                  final a = alunos[i];
                  final ativo = a['status'] == true;
                  final corStatus = ativo ? AppColors.sucesso : AppColors.erro;

                  return InkWell(
                    borderRadius: AppBorders.radiusLarge,
                    onTap: () => Navigator.pushNamed(
                      context,
                      Rotas.detalheAluno,
                      arguments: a,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.fundoCard,
                        borderRadius: AppBorders.radiusLarge,
                        boxShadow: AppShadows.cardShadowSmall,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: AppColors.primaryColor,
                            child: Text(a['inicial'], style: const TextStyle(color: Colors.white, fontWeight: AppTypography.fontWeightBold, fontSize: 18)),
                          ),
                          AppSpacing.gapMdHorizontal,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['nome'], style: AppTypography.titleMedium.copyWith(color: AppColors.textoPrimario)),
                                AppSpacing.gapXs,
                                Text(a['modalidade'], style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario)),
                                AppSpacing.gapXs,
                                Text('${a['presencas']} presenças', style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: corStatus)),
                              AppSpacing.gapXs,
                              Text(ativo ? 'Ativo' : 'Inativo', style: AppTypography.bodySmall.copyWith(fontWeight: AppTypography.fontWeightSemiBold, color: corStatus)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resumo(String valor, String titulo, Color cor) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.fundoCard, borderRadius: AppBorders.radiusLarge),
          child: Column(
            children: [
              Text(valor, style: TextStyle(fontSize: AppTypography.fontSizeH2, fontWeight: AppTypography.fontWeightBold, color: cor)),
              AppSpacing.gapXs,
              Text(titulo, style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario)),
            ],
          ),
        ),
      );

  Widget _icone(IconData icon) => Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(color: AppColors.fundoCard, shape: BoxShape.circle),
        child: Icon(icon, size: 22, color: AppColors.textoPrimario),
      );
}
