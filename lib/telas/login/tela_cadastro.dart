import 'package:flutter/material.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/tema/app_cores.dart';
import 'package:fluire/tema/app_tipografia.dart';
import 'package:fluire/tema/app_espacamento.dart';
import 'package:fluire/tema/app_bordas.dart';
import 'package:fluire/tema/app_sombras.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {

  @override



  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.backgroundColor,
    body: Center(
      child: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Container(
          width: 420,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.xxxl),
          decoration: BoxDecoration(
            color: AppColors.fundoCard,
            borderRadius: AppBorders.radiusXLarge,
            boxShadow: AppShadows.elevatedShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primariaClara,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.waves, color: AppColors.primaryColor, size: 32),
              ),
              AppSpacing.gapXl,
              Text('Create Account', style: AppTypography.displayMedium.copyWith(color: AppColors.textoPrimario)),
              AppSpacing.gapSm,
              Text('Sign up to get started', style: AppTypography.bodyLarge.copyWith(color: AppColors.textoSecundario)),
              AppSpacing.gapXl,
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
                      errorBuilder: (_, _, _) => Icon(Icons.g_mobiledata, size: 22, color: Color(0xFF4285F4)),
                    ),
                    AppSpacing.gapSmHorizontal,
                    Text('Continuar com Google', style: TextStyle(fontSize: AppTypography.fontSizeLg, color: AppColors.textoPrimario, fontWeight: AppTypography.fontWeightMedium)),
                  ],
                ),
              ),
              AppSpacing.gapXl,
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.divisor)),
                  Padding(
                    padding: AppSpacing.screenPaddingHorizontal,
                    child: Text('OU', style: TextStyle(fontSize: AppTypography.fontSizeSm, color: AppColors.textoSecundario, letterSpacing: 1.2)),
                  ),
                  Expanded(child: Divider(color: AppColors.divisor)),
                ],
              ),
              AppSpacing.gapXl,
              Align(alignment: Alignment.centerLeft, child: Text('Nome completo', style: AppTypography.bodyLarge.copyWith(color: AppColors.textoPrimario, fontWeight: AppTypography.fontWeightMedium))),
              AppSpacing.gapSm,
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Seu nome',
                  hintStyle: TextStyle(color: AppColors.textoSecundario),
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.textoSecundario, size: 20),
                  filled: true,
                  fillColor: AppColors.fundoCard,
                  contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
                  border: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),
                  focusedBorder: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5)),
                ),
              ),
              AppSpacing.gapLg,
              Align(alignment: Alignment.centerLeft, child: Text('Email', style: AppTypography.bodyLarge.copyWith(color: AppColors.textoPrimario, fontWeight: AppTypography.fontWeightMedium))),
              AppSpacing.gapSm,
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  hintStyle: TextStyle(color: AppColors.textoSecundario),
                  prefixIcon: Icon(Icons.mail_outline, color: AppColors.textoSecundario, size: 20),
                  filled: true,
                  fillColor: AppColors.fundoCard,
                  contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
                  border: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),
                  focusedBorder: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5)),
                ),
              ),
              AppSpacing.gapLg,
              Align(alignment: Alignment.centerLeft, child: Text('Senha', style: AppTypography.bodyLarge.copyWith(color: AppColors.textoPrimario, fontWeight: AppTypography.fontWeightMedium))),
              AppSpacing.gapSm,
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(color: AppColors.textoSecundario),
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.textoSecundario, size: 20),
                  filled: true,
                  fillColor: AppColors.fundoCard,
                  contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
                  border: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),
                  focusedBorder: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5)),
                ),
              ),
              AppSpacing.gapLg,
              Align(alignment: Alignment.centerLeft, child: Text('Confirmar senha', style: AppTypography.bodyLarge.copyWith(color: AppColors.textoPrimario, fontWeight: AppTypography.fontWeightMedium))),
              AppSpacing.gapSm,
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(color: AppColors.textoSecundario),
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.textoSecundario, size: 20),
                  filled: true,
                  fillColor: AppColors.fundoCard,
                  contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
                  border: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.divisor)),
                  focusedBorder: OutlineInputBorder(borderRadius: AppBorders.radiusSmall, borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5)),
                ),
              ),
              AppSpacing.gapXl,
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.textoClaro,
                    shape: AppBorders.buttonShape,
                    elevation: 0,
                  ),
                  child: Text('Criar conta', style: AppTypography.titleLarge),
                ),
              ),
              AppSpacing.gapLg,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Já tem uma conta? ', style: AppTypography.bodySmall.copyWith(color: AppColors.textoSecundario)),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, Rotas.login),
                    child: Text('Entrar', style: AppTypography.bodySmall.copyWith(fontWeight: AppTypography.fontWeightBold, color: AppColors.textoPrimario)),
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