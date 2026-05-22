import 'package:flutter/material.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/tema/app_espacamento.dart';

/// Tema principal da aplicação Fluirê
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.light,
        primary: AppColors.primaryColor,
        secondary: AppColors.primariaClara,
        surface: AppColors.fundoCard,
        background: AppColors.backgroundColor,
        error: AppColors.erro,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppColors.backgroundColor,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.displayMedium.copyWith(
          color: AppColors.textoPrimario,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textoPrimario,
        ),
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: AppColors.fundoCard,
        elevation: 0,
        shape: AppBorders.cardShape,
        margin: EdgeInsets.zero,
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textoClaro,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: AppBorders.buttonShape,
          textStyle: AppTypography.titleLarge,
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: AppBorders.buttonShape,
          side: BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
          textStyle: AppTypography.titleLarge,
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.titleMedium,
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fundoCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppBorders.radiusSmall,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorders.radiusSmall,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorders.radiusSmall,
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorders.radiusSmall,
          borderSide: BorderSide(
            color: AppColors.erro,
            width: 1.5,
          ),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textoSecundario,
        ),
        labelStyle: AppTypography.bodyLarge.copyWith(
          color: AppColors.textoPrimario,
        ),
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.textoPrimario,
        size: 24,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(
          color: AppColors.textoPrimario,
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          color: AppColors.textoPrimario,
        ),
        displaySmall: AppTypography.displaySmall.copyWith(
          color: AppColors.textoPrimario,
        ),
        headlineLarge: AppTypography.headline.copyWith(
          color: AppColors.textoPrimario,
        ),
        headlineMedium: AppTypography.headline.copyWith(
          color: AppColors.textoPrimario,
        ),
        headlineSmall: AppTypography.headline.copyWith(
          color: AppColors.textoPrimario,
        ),
        titleLarge: AppTypography.titleLarge.copyWith(
          color: AppColors.textoPrimario,
        ),
        titleMedium: AppTypography.titleMedium.copyWith(
          color: AppColors.textoPrimario,
        ),
        titleSmall: AppTypography.titleMedium.copyWith(
          color: AppColors.textoPrimario,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: AppColors.textoPrimario,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: AppColors.textoPrimario,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: AppColors.textoSecundario,
        ),
        labelLarge: AppTypography.bodyLarge.copyWith(
          color: AppColors.textoPrimario,
        ),
        labelMedium: AppTypography.bodyMedium.copyWith(
          color: AppColors.textoSecundario,
        ),
        labelSmall: AppTypography.caption.copyWith(
          color: AppColors.textoSecundario,
        ),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.divisor,
        thickness: 1,
        space: AppSpacing.lg,
      ),
      
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryColor,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textoClaro,
        ),
        shape: AppBorders.cardShape,
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),
    );
  }
}
