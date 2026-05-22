import 'package:flutter/material.dart';

class AppShadows {
  // Card shadow
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Color(0x0A303027),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ];

  // Small card shadow
  static List<BoxShadow> get cardShadowSmall => [
        BoxShadow(
          color: Color(0x0A303027),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ];

  // Elevated shadow
  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Color(0x12303027),
          blurRadius: 40,
          offset: Offset(0, 8),
        ),
      ];

  // Button shadow
  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: Color(0x1A303027),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ];
}
