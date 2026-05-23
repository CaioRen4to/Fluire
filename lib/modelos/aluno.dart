class Aluno {
  final String id;
  final String nome;
  final String telefone;
  final String email;
  final String modalidade;
  final int presencas;
  final int faltas;
  final bool ativo;
  final String? ultimaAula;

  const Aluno({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.modalidade,
    this.presencas = 0,
    this.faltas = 0,
    this.ativo = true,
    this.ultimaAula,
  });

  String get inicial => nome.isNotEmpty ? nome[0].toUpperCase() : '?';

  int get frequenciaPercentual {
    final total = presencas + faltas;
    if (total == 0) return 0;
    return ((presencas / total) * 100).round();
  }

  Aluno copyWith({
    String? id,
    String? nome,
    String? telefone,
    String? email,
    String? modalidade,
    int? presencas,
    int? faltas,
    bool? ativo,
    String? ultimaAula,
  }) {
    return Aluno(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      modalidade: modalidade ?? this.modalidade,
      presencas: presencas ?? this.presencas,
      faltas: faltas ?? this.faltas,
      ativo: ativo ?? this.ativo,
      ultimaAula: ultimaAula ?? this.ultimaAula,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'telefone': telefone,
        'email': email,
        'modalidade': modalidade,
        'presencas': presencas,
        'faltas': faltas,
        'ativo': ativo,
        'ultimaAula': ultimaAula,
      };

  factory Aluno.fromJson(Map<String, dynamic> json) => Aluno(
        id: json['id'] as String,
        nome: json['nome'] as String,
        telefone: json['telefone'] as String? ?? '',
        email: json['email'] as String? ?? '',
        modalidade: json['modalidade'] as String? ?? '',
        presencas: json['presencas'] as int? ?? 0,
        faltas: json['faltas'] as int? ?? 0,
        ativo: json['ativo'] as bool? ?? true,
        ultimaAula: json['ultimaAula'] as String?,
      );
}
