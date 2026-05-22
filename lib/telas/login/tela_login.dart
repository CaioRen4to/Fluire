import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/tema/app_sombras.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Container(
            width: 420,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xxxl),
            decoration: BoxDecoration(
              color: AppColors.fundoCard,
              borderRadius: AppBorders.radiusLarge,
              boxShadow: AppShadows.elevatedShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primariaClara,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.waves,
                    color: AppColors.primaryColor,
                    size: 32,
                  ),
                ),
                AppSpacing.gapXl,

                // Título
                Text(
                  'Welcome to Fluirê',
                  style: AppTypography.displayMedium.copyWith(
                    color: AppColors.textoPrimario,
                  ),
                ),
                AppSpacing.gapSm,
                Text(
                  'Sign in to continue',
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.textoSecundario),
                ),
                AppSpacing.gapXxl,

                // Botão Google
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    side: BorderSide(color: AppColors.divisor),
                    shape: AppBorders.buttonShape,
                    backgroundColor: AppColors.fundoCard,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.google.com/favicon.ico',
                        width: 20,
                        height: 20,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.g_mobiledata,
                          size: 22,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                      AppSpacing.gapSmHorizontal,
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: AppTypography.fontSizeXl,
                          color: AppColors.textoPrimario,
                          fontWeight: AppTypography.fontWeightMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapXl,

                // Divisor OR
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.divisor)),
                    Padding(
                      padding: AppSpacing.screenPaddingHorizontal,
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: AppTypography.fontSizeSm,
                          color: AppColors.textoSecundario,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.divisor)),
                  ],
                ),
                AppSpacing.gapXl,

                // Label Email
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textoPrimario,
                      fontWeight: AppTypography.fontWeightMedium,
                    ),
                  ),
                ),
                AppSpacing.gapSm,

                // Campo Email
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'you@example.com',
                    hintStyle: TextStyle(color: AppColors.textoSecundario),
                    prefixIcon: const Icon(
                      Icons.mail_outline,
                      color: AppColors.textoSecundario,
                      size: 20,
                    ),
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
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                AppSpacing.gapLg,

                // Label Password
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textoPrimario,
                      fontWeight: AppTypography.fontWeightMedium,
                    ),
                  ),
                ),
                AppSpacing.gapSm,

                // Campo Password
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: TextStyle(color: AppColors.textoSecundario),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.textoSecundario,
                      size: 20,
                    ),
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
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                AppSpacing.gapXl,

                // Botão Sign In
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, Rotas.painel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.textoClaro,
                      shape: AppBorders.buttonShape,
                      elevation: 0,
                    ),
                    child: Text(
                      'Sign in',
                      style: AppTypography.titleLarge,
                    ),
                  ),
                ),
                AppSpacing.gapLg,

                // Footer links
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forgot password?',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textoSecundario,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        Rotas.cadastro,
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'Need an account? ',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textoSecundario,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: AppTypography.fontWeightBold,
                                color: AppColors.textoPrimario,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
