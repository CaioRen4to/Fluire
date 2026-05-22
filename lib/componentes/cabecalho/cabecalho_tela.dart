import 'package:flutter/material.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/widgets/menu_lateral.dart';

class CabecalhoTela extends StatelessWidget {
  final String titulo;
  final Widget? acaoDireita;
  final bool mostrarMenu;
  final VoidCallback? onAcaoDireita;

  const CabecalhoTela({
    super.key,
    required this.titulo,
    this.acaoDireita,
    this.mostrarMenu = true,
    this.onAcaoDireita,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (mostrarMenu) const BotaoMenu() else const SizedBox(width: 48),
          Text(
            titulo,
            style: AppTypography.displaySmall.copyWith(color: AppColors.textoPrimario),
          ),
          acaoDireita ??
              (onAcaoDireita != null
                  ? _botaoAcao()
                  : const SizedBox(width: 48)),
        ],
      ),
    );
  }

  Widget _botaoAcao() {
    return Material(
      color: AppColors.fundoCard,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onAcaoDireita,
        child: const SizedBox(
          width: 48,
          height: 48,
          child: Icon(Icons.notifications_outlined, color: AppColors.textoPrimario),
        ),
      ),
    );
  }
}
