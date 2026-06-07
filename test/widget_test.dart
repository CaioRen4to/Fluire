import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fluire/main.dart';
import 'package:fluire/providers/providers.dart';

void main() {
  testWidgets('App inicia na tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: ProvedoresApp.providers(),
        child: const FluireApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo ao Fluirê'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
