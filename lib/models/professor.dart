import 'package:fluire/models/usuario.dart';

/// Professor = registro da tabela `usuarios` (não há tabela teachers separada).
class Professor {
  final String id;
  final String nome;
  final String email;

  const Professor({
    required this.id,
    required this.nome,
    this.email = '',
  });

  factory Professor.fromJson(Map<String, dynamic> json) => Professor(
        id: json['id']?.toString() ?? '',
        nome: (json['nome'] ?? json['name']) as String? ?? '',
        email: json['email'] as String? ?? '',
      );

  factory Professor.fromUsuario(Usuario usuario) => Professor(
        id: usuario.id,
        nome: usuario.nome,
        email: usuario.email,
      );
}
