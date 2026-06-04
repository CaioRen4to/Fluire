import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/tema/tema.dart';
import 'package:fluire/componentes/layout_tela.dart';
import 'package:fluire/componentes/botao/botao.dart';
import 'package:fluire/componentes/estado_visual/estado_visual.dart';
import 'package:fluire/provedores/provedor_auth.dart';
import 'package:fluire/modelos/usuario.dart';

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<ProvedorAuth>();
    final usuario = auth.usuario;

    if (usuario == null) {
      return LayoutTela(
        titulo: 'Meu Perfil',
        rotaAtual: AppRoutes.perfil,
        mostrarBottomNav: true,
        child: const EstadoCarregando(mensagem: 'Carregando perfil...'),
      );
    }

    return LayoutTela(
      titulo: 'Meu Perfil',
      rotaAtual: AppRoutes.perfil,
      mostrarBottomNav: true,
      child: Column(
        children: [
          AppSpacing.gapXl,
          _buildProfileCard(usuario.nome, usuario.email, usuario.rotuloTipo),
          AppSpacing.gapLg,
          _buildInfoSection(context, usuario),
          AppSpacing.gapLg,
          _buildActionsSection(context, auth),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String nome, String email, String tipo) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPaddingLarge,
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        borderRadius: AppBorders.radiusXLarge,
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primariaClara,
            child: Icon(
              Icons.person,
              size: 60,
              color: AppColors.primaryColor,
            ),
          ),
          AppSpacing.gapMd,
          Text(
            nome,
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textoPrimario,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            email,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textoSecundario,
            ),
          ),
          AppSpacing.gapSm,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.primariaClara.withValues(alpha: 0.3),
              borderRadius: AppBorders.radiusMedium,
            ),
            child: Text(
              tipo,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textoPrimario,
                fontWeight: AppTypography.fontWeightMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Usuario usuario) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        borderRadius: AppBorders.radiusLarge,
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações da Conta',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textoPrimario,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
          AppSpacing.gapMd,
          _buildInfoRow(Icons.badge_outlined, 'ID', usuario.id),
          AppSpacing.gapMd,
          _buildInfoRow(Icons.mail_outline, 'E-mail', usuario.email),
          AppSpacing.gapMd,
          _buildInfoRow(Icons.person_outline, 'Nome', usuario.nome),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryColor),
        AppSpacing.gapSmHorizontal,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textoSecundario,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textoPrimario,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context, ProvedorAuth auth) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.fundoCard,
        borderRadius: AppBorders.radiusLarge,
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          BotaoPrimario(
            texto: 'Ver Painel',
            icone: Icons.dashboard_outlined,
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.painel),
          ),
          AppSpacing.gapMd,
          BotaoSecundario(
            texto: 'Frequência',
            icone: Icons.fact_check_outlined,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.frequenciaTotem),
          ),
          AppSpacing.gapMd,
          BotaoSecundario(
            texto: 'Professores',
            icone: Icons.school_outlined,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.professores),
          ),
          AppSpacing.gapMd,
          BotaoTexto(
            texto: 'Sair',
            cor: AppColors.erro,
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
