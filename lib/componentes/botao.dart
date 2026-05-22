import 'package:flutter/material.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/tema/app_bordas.dart';

class BotaoPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double? height;

  const BotaoPrimario({
    super.key,
    required this.texto,
    this.onPressed,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textoClaro,
          shape: AppBorders.buttonShape,
          elevation: 0,
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(texto, style: AppTypography.titleLarge),
                ],
              )
            : Text(texto, style: AppTypography.titleLarge),
      ),
    );
  }
}

class BotaoSecundario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double? height;

  const BotaoSecundario({
    super.key,
    required this.texto,
    this.onPressed,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textoPrimario,
          side: BorderSide(color: AppColors.divisor),
          shape: AppBorders.buttonShape,
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(texto, style: AppTypography.titleLarge),
                ],
              )
            : Text(texto, style: AppTypography.titleLarge),
      ),
    );
  }
}

class BotaoTexto extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final Color? cor;

  const BotaoTexto({
    super.key,
    required this.texto,
    this.onPressed,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        texto,
        style: AppTypography.bodyMedium.copyWith(
          color: cor ?? AppColors.primaryColor,
          fontWeight: AppTypography.fontWeightSemiBold,
        ),
      ),
    );
  }
}
