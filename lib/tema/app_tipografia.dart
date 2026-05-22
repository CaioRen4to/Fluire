import 'package:flutter/material.dart';

class AppTypography {
  // Font sizes
  static const double fontSizeSm = 12.0;
  static const double fontSizeXs = 10.0;
  static const double fontSizeMd = 14.0;
  static const double fontSizeLg = 16.0;
  static const double fontSizeXl = 18.0;
  static const double fontSizeH3 = 22.0;
  static const double fontSizeH2 = 24.0;
  static const double fontSizeH1 = 28.0;

  // Font weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Text styles
  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeSm,
    fontWeight: fontWeightRegular,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeMd,
    fontWeight: fontWeightRegular,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: fontWeightRegular,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: fontSizeMd,
    fontWeight: fontWeightSemiBold,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: fontWeightSemiBold,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: fontSizeXl,
    fontWeight: fontWeightSemiBold,
  );

  static const TextStyle headline = TextStyle(
    fontSize: fontSizeH2,
    fontWeight: fontWeightBold,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: fontSizeH2,
    fontWeight: fontWeightBold,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: fontSizeH1,
    fontWeight: fontWeightBold,
  );

  static const TextStyle displayLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: fontWeightBold,
  );
}
