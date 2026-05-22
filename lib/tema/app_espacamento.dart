import 'package:flutter/material.dart';

/// Sistema de espaçamento padronizado para consistência visual
class AppSpacing {
  // Espaçamentos base
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Padding padrão para telas
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: xl, vertical: xl);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: xl);

  // Padding para cards
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(xl);

  // Espaçamento entre elementos
  static const SizedBox gapXs = SizedBox(height: xs);
  static const SizedBox gapSm = SizedBox(height: sm);
  static const SizedBox gapMd = SizedBox(height: md);
  static const SizedBox gapLg = SizedBox(height: lg);
  static const SizedBox gapXl = SizedBox(height: xl);
  static const SizedBox gapXxl = SizedBox(height: xxl);

  static const SizedBox gapXsHorizontal = SizedBox(width: xs);
  static const SizedBox gapSmHorizontal = SizedBox(width: sm);
  static const SizedBox gapMdHorizontal = SizedBox(width: md);
  static const SizedBox gapLgHorizontal = SizedBox(width: lg);
  static const SizedBox gapXlHorizontal = SizedBox(width: xl);
}
