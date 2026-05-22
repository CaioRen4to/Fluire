import 'package:flutter/material.dart';

class AppBorders {
  // Border radius values
  static const double radiusSmallValue = 8.0;
  static const double radiusMediumValue = 12.0;
  static const double radiusLargeValue = 16.0;
  static const double radiusXLargeValue = 20.0;
  static const double radiusXXLargeValue = 24.0;

  // Border radius objects
  static const BorderRadius radiusSmallBorder = BorderRadius.all(Radius.circular(radiusSmallValue));
  static const BorderRadius radiusMediumBorder = BorderRadius.all(Radius.circular(radiusMediumValue));
  static const BorderRadius radiusLargeBorder = BorderRadius.all(Radius.circular(radiusLargeValue));
  static const BorderRadius radiusXLargeBorder = BorderRadius.all(Radius.circular(radiusXLargeValue));
  static const BorderRadius radiusXXLargeBorder = BorderRadius.all(Radius.circular(radiusXXLargeValue));

  // Named radius constants
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius radiusXLarge = BorderRadius.all(Radius.circular(20.0));
  static const BorderRadius radiusXXLarge = BorderRadius.all(Radius.circular(24.0));

  // Button shape
  static final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radiusMediumValue),
  );

  // Input shape
  static final OutlineInputBorder inputShape = OutlineInputBorder(
    borderRadius: BorderRadius.circular(radiusSmallValue),
    borderSide: BorderSide.none,
  );
}
