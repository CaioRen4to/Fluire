import 'package:flutter/material.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';

class CabecalhoTela extends StatelessWidget {
  final String titulo;
  final Widget? trailing;
  final VoidCallback? onBack;

  const CabecalhoTela({
    super.key,
    required this.titulo,
    this.trailing,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onBack != null)
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textoPrimario),
            onPressed: onBack,
          )
        else
          const SizedBox(width: 48),
        Expanded(
          child: Text(
            titulo,
            style: AppTypography.displayLarge.copyWith(
              color: AppColors.textoPrimario,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        trailing ?? const SizedBox(width: 48),
      ],
    );
  }
}
