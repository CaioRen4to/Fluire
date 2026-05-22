import 'package:flutter/material.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/tema/app_tipografia.dart';

class BotaoPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icone;
  final bool carregando;
  final bool expandido;

  const BotaoPrimario({
    super.key,
    required this.texto,
    this.onPressed,
    this.icone,
    this.carregando = false,
    this.expandido = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expandido ? double.infinity : null,
      height: 52,
      child: ElevatedButton(
        onPressed: carregando ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textoClaro,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: AppBorders.buttonShape,
          textStyle: AppTypography.titleLarge,
        ),
        child: carregando
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icone != null) ...[
                    Icon(icone, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(texto),
                ],
              ),
      ),
    );
  }
}

class BotaoSecundario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icone;
  final bool expandido;

  const BotaoSecundario({
    super.key,
    required this.texto,
    this.onPressed,
    this.icone,
    this.expandido = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expandido ? double.infinity : null,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: AppBorders.buttonShape,
          side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
          textStyle: AppTypography.titleLarge,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icone != null) ...[
              Icon(icone, size: 20),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(texto),
          ],
        ),
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
      style: TextButton.styleFrom(
        foregroundColor: cor ?? AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        textStyle: AppTypography.titleMedium,
      ),
      child: Text(texto),
    );
  }
}

class BotaoIcone extends StatelessWidget {
  final IconData icone;
  final VoidCallback? onPressed;
  final Color? corFundo;
  final Color? corIcone;

  const BotaoIcone({
    super.key,
    required this.icone,
    this.onPressed,
    this.corFundo,
    this.corIcone,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: corFundo ?? AppColors.fundoCard,
      borderRadius: AppBorders.radiusMedium,
      child: InkWell(
        borderRadius: AppBorders.radiusMedium,
        onTap: onPressed,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icone, color: corIcone ?? AppColors.textoPrimario),
        ),
      ),
    );
  }
}
