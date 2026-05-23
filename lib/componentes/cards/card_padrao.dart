import 'package:flutter/material.dart';
import 'package:fluire/tema/tema.dart';

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
    final card = Container(
      padding: padding ?? AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: corFundo ?? AppColors.fundoCard,
        borderRadius: AppBorders.radiusXLarge,
        boxShadow: comSombra ? AppShadows.cardShadow : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        borderRadius: AppBorders.radiusXLarge,
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
