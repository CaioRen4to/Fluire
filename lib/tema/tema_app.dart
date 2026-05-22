import 'package:flutter/material.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_bordas.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.backgroundColor,
      cardTheme: CardThemeData(
        color: AppColors.fundoCard,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.radiusLargeBorder,
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fundoCard,
        border: OutlineInputBorder(
          borderRadius: AppBorders.radiusSmallBorder,
          borderSide: BorderSide(color: AppColors.divisor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorders.radiusSmallBorder,
          borderSide: BorderSide(color: AppColors.divisor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorders.radiusSmallBorder,
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textoClaro,
          shape: AppBorders.buttonShape,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textoPrimario,
          side: BorderSide(color: AppColors.divisor),
          shape: AppBorders.buttonShape,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.divisor,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
