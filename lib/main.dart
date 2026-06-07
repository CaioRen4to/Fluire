import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluire/routes/app_routes.dart';
import 'package:fluire/theme/tema_app.dart';
import 'package:fluire/providers/provedores_app.dart';
import 'package:fluire/providers/provedor_auth.dart';
import 'package:fluire/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  await authService.carregarSessao();

  runApp(
    MultiProvider(
      providers: ProvedoresApp.providers(authService: authService),
      child: const FluireApp(),
    ),
  );
}

class FluireApp extends StatelessWidget {
  const FluireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluirê',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.rotas,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      builder: (context, child) {
        return _AuthGuard(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

class _AuthGuard extends StatelessWidget {
  final Widget child;

  const _AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    final rota = ModalRoute.of(context)?.settings.name;
    if (rota == null) return child;

    if (AppRoutes.rotasPublicas.contains(rota)) {
      return child;
    }

    final autenticado = context.watch<ProvedorAuth>().autenticado;
    if (!autenticado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.login,
            (_) => false,
          );
        }
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return child;
  }
}
