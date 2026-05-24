import 'package:flutter/material.dart';
import 'package:fluire/tema/tema.dart';
import 'package:fluire/componentes/layout_tela.dart';
import 'package:fluire/componentes/botao/botao.dart';


class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});




  @override
  Widget build(BuildContext context) {
    return LayoutTela(
      titulo: 'Meu Perfil',
      mostrarMenu: true,
      child: Column(
        children: [
          AppSpacing.gapXl,
          _buildProfileCard(context),
          AppSpacing.gapLg,
          _buildInfoSection(context),
          AppSpacing.gapLg,
          _buildActionsSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
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
            'Nome do Usuário',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textoPrimario,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            'usuario@email.com',
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
              'Professor',
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

  Widget _buildInfoSection(BuildContext context) {
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
            'Informações Pessoais',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textoPrimario,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
          AppSpacing.gapMd,
          _buildInfoRow(Icons.phone, 'Telefone', '(00) 00000-0000'),
          AppSpacing.gapMd,
          _buildInfoRow(Icons.calendar_today, 'Data de Nascimento', '01/01/1990'),
          AppSpacing.gapMd,
          _buildInfoRow(Icons.location_on, 'Localização', 'São Paulo, SP'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryColor,
        ),
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

  Widget _buildActionsSection(BuildContext context) {
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
            texto: 'Editar Perfil',
            icone: Icons.edit,
            onPressed: () {
              // TODO: Implementar edição de perfil
            },
          ),
          AppSpacing.gapMd,
          BotaoSecundario(
            texto: 'Alterar Senha',
            icone: Icons.lock,
            onPressed: () {
              // TODO: Implementar alteração de senha
            },
          ),
          AppSpacing.gapMd,
          BotaoTexto(
            texto: 'Sair',
            cor: AppColors.erro,
            onPressed: () {
              // TODO: Implementar logout
            },
          ),
        ],
      ),
    );
  }
}
