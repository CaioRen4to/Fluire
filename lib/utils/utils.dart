import 'package:flutter/material.dart';

// Unified Utilities

// --- From estado_carregamento.dart ---
enum EstadoCarregamento { inicial, carregando, sucesso, erro, vazio }


// --- From animacoes.dart ---

class Animacoes {
  static const Duration rapida = Duration(milliseconds: 200);
  static const Duration media = Duration(milliseconds: 350);
  static const Curve curva = Curves.easeOutCubic;

  static Widget fadeSlide({
    required Widget child,
    Duration delay = Duration.zero,
    Offset offset = const Offset(0, 0.08),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: media + delay,
      curve: curva,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(offset.dx * 40 * (1 - value), offset.dy * 40 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }
}

Route<T> rotaComFade<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Animacoes.curva),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.03, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Animacoes.curva)),
          child: child,
        ),
      );
    },
    transitionDuration: Animacoes.media,
  );
}


// --- From responsivo.dart ---

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


