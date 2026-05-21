import 'package:flutter/material.dart';
import 'package:fluire/rotas.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluire',
      debugShowCheckedModeBanner: false,
      initialRoute: Rotas.login,
      routes: Rotas.rotas,
      onGenerateRoute: Rotas.onGenerateRoute,
    );
  }
}