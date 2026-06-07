import 'package:flutter/material.dart';

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
