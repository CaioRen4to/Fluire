class Professor {
  final String id;
  final String nome;

  const Professor({required this.id, required this.nome});

  factory Professor.fromJson(Map<String, dynamic> json) => Professor(
        id: json['id'] as String,
        nome: json['nome'] as String,
      );
}
