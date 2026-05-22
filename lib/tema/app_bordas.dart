import 'package:flutter/material.dart';

/// Sistema de bordas e cantos arredondados padronizado
class AppBorders {
  // Raios de borda
  static const double radiusXs = 8.0;
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 24.0;
  static const double radiusXxl = 28.0;

  // BorderRadius padrão
  static BorderRadius get radiusSmall => BorderRadius.circular(radiusSm);
  static BorderRadius get radiusMedium => BorderRadius.circular(radiusMd);
  static BorderRadius get radiusLarge => BorderRadius.circular(radiusLg);
  static BorderRadius get radiusXLarge => BorderRadius.circular(radiusXl);
  static BorderRadius get radiusXXLarge => BorderRadius.circular(radiusXxl);

  // Shape para cards
  static RoundedRectangleBorder get cardShape => RoundedRectangleBorder(
        borderRadius: radiusXLarge,
      );

  static RoundedRectangleBorder get buttonShape => RoundedRectangleBorder(
        borderRadius: radiusMedium,
      );

  static RoundedRectangleBorder get inputShape => RoundedRectangleBorder(
        borderRadius: radiusSmall,
      );
}
