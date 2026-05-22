import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluire/tema/tema_app.dart';
import 'package:fluire/rotas.dart';
import 'package:fluire/providers/app_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(
    MultiProvider(
      providers: AppProviders.providers,
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
      initialRoute: Rotas.login,
      routes: Rotas.rotas,
      onGenerateRoute: Rotas.onGenerateRoute,
      builder: (context, child) => child ?? const SizedBox.shrink(),
    );
  }
}
