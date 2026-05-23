import 'package:flutter/material.dart';

class Responsivo {
  static const double tablet = 600;
  static const double desktop = 900;

  static bool isMobile(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w < tablet;
  }

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= tablet && w < desktop;
  }

  static bool isDesktop(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= desktop;
  }

  static double larguraConteudo(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= desktop) return 720;
    if (w >= tablet) return 560;
    return w;
  }

  static int colunasGrid(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= desktop) return 3;
    if (w >= tablet) return 2;
    return 1;
  }

  static EdgeInsets paddingTela(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.paddingOf(context).horizontal;
    if (w >= desktop) {
      return EdgeInsets.symmetric(horizontal: 48 + h, vertical: 24);
    }
    if (w >= tablet) {
      return EdgeInsets.symmetric(horizontal: 32 + h, vertical: 20);
    }
    return EdgeInsets.symmetric(horizontal: 20 + h / 2, vertical: 20);
  }
}
