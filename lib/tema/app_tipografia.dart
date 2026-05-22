import 'package:flutter/material.dart';

/// Sistema de tipografia padronizado
class AppTypography {
  // Tamanhos de fonte
  static const double fontSizeXs = 11.0;
  static const double fontSizeSm = 12.0;
  static const double fontSizeMd = 13.0;
  static const double fontSizeLg = 14.0;
  static const double fontSizeXl = 15.0;
  static const double fontSizeXXl = 16.0;
  static const double fontSizeXXXl = 18.0;
  static const double fontSizeH4 = 20.0;
  static const double fontSizeH3 = 22.0;
  static const double fontSizeH2 = 24.0;
  static const double fontSizeH1 = 28.0;

  // Pesos de fonte
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Estilos de texto
  static TextStyle get displayLarge => TextStyle(
        fontSize: fontSizeH1,
        fontWeight: fontWeightBold,
        height: 1.2,
      );

  static TextStyle get displayMedium => TextStyle(
        fontSize: fontSizeH2,
        fontWeight: fontWeightBold,
        height: 1.2,
      );

  static TextStyle get displaySmall => TextStyle(
        fontSize: fontSizeH3,
        fontWeight: fontWeightBold,
        height: 1.2,
      );

  static TextStyle get headline => TextStyle(
        fontSize: fontSizeH4,
        fontWeight: fontWeightBold,
        height: 1.3,
      );

  static TextStyle get titleLarge => TextStyle(
        fontSize: fontSizeXXl,
        fontWeight: fontWeightSemiBold,
        height: 1.4,
      );

  static TextStyle get titleMedium => TextStyle(
        fontSize: fontSizeXl,
        fontWeight: fontWeightSemiBold,
        height: 1.4,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontSize: fontSizeLg,
        fontWeight: fontWeightRegular,
        height: 1.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: fontSizeMd,
        fontWeight: fontWeightRegular,
        height: 1.5,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: fontSizeSm,
        fontWeight: fontWeightRegular,
        height: 1.4,
      );

  static TextStyle get caption => TextStyle(
        fontSize: fontSizeXs,
        fontWeight: fontWeightMedium,
        height: 1.3,
      );
}
