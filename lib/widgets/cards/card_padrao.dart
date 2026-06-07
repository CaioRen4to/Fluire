import 'package:flutter/material.dart';
import 'package:fluire/theme/tema.dart';

class CardPadrao extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? corFundo;
  final bool comSombra;

  const CardPadrao({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.corFundo,
    this.comSombra = true,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: AppBorders.radiusXLarge,
        child: InkWell(
          borderRadius: AppBorders.radiusXLarge,
          onTap: onTap,
          child: Container(
            padding: padding ?? AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: corFundo ?? AppColors.fundoCard,
              borderRadius: AppBorders.radiusXLarge,
              boxShadow: comSombra ? AppShadows.cardShadow : null,
            ),
            child: child,
          ),
        ),
      );
    }

    return Container(
      padding: padding ?? AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: corFundo ?? AppColors.fundoCard,
        borderRadius: AppBorders.radiusXLarge,
        boxShadow: comSombra ? AppShadows.cardShadow : null,
      ),
      child: child,
    );
  }
}
