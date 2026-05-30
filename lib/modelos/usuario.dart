class Usuario {
  final String id;
  final String nome;
  final String email;
  final String? tipoUsuario;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.tipoUsuario,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] as String? ?? '',
      email: json['email'] as String? ?? '',
      tipoUsuario: json['tipo_usuario']?.toString(),
    );
  }

  String get rotuloTipo {
    if (tipoUsuario == null || tipoUsuario!.isEmpty) return 'Usuário';
    return tipoUsuario!;
  }
}
