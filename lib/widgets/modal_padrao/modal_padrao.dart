import 'package:flutter/material.dart';
import 'package:fluire/theme/tema.dart';
import 'package:fluire/utils/responsivo.dart';

class ModalPadrao {
  static Future<T?> mostrar<T>({
    required BuildContext context,
    required String titulo,
    required Widget conteudo,
    List<Widget>? acoes,
    bool scrollavel = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: titulo,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, animation, child) {
        final escala = Tween<double>(begin: 0.92, end: 1).animate(
          CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        );
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: escala,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: Responsivo.larguraConteudo(ctx) * 0.92,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(ctx).height * 0.85,
                    maxWidth: 520,
                  ),
                  margin: Responsivo.paddingTela(ctx),
                  padding: AppSpacing.cardPaddingLarge,
                  decoration: BoxDecoration(
                    color: AppColors.fundoCard,
                    borderRadius: AppBorders.radiusXXLarge,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sombra,
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              titulo,
                              style: AppTypography.displaySmall.copyWith(
                                color: AppColors.textoPrimario,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(Icons.close),
                            color: AppColors.textoSecundario,
                          ),
                        ],
                      ),
                      AppSpacing.gapLg,
                      Flexible(
                        child: scrollavel
                            ? SingleChildScrollView(child: conteudo)
                            : conteudo,
                      ),
                      if (acoes != null) ...[
                        AppSpacing.gapXl,
                        Row(children: acoes),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
