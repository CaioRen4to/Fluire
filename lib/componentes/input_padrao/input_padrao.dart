import 'package:flutter/material.dart';
import 'package:fluire/tema/tema.dart';

class InputPadrao extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final IconData? icone;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const InputPadrao({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.icone,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textoPrimario,
            fontWeight: AppTypography.fontWeightMedium,
          ),
        ),
        AppSpacing.gapSm,
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.textoPrimario),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textoSecundario),
            prefixIcon: icone != null
                ? Icon(icone, color: AppColors.textoSecundario, size: 20)
                : null,
            filled: true,
            fillColor: AppColors.fundoCard,
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.lg,
            ),
            border: OutlineInputBorder(
              borderRadius: AppBorders.radiusSmall,
              borderSide: BorderSide(color: AppColors.divisor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppBorders.radiusSmall,
              borderSide: BorderSide(color: AppColors.divisor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppBorders.radiusSmall,
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppBorders.radiusSmall,
              borderSide: BorderSide(color: AppColors.erro),
            ),
          ),
        ),
      ],
    );
  }
}
