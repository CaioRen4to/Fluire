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
  final int? createdBy;
  final int? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
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
    int? createdBy,
    int? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
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
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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

  static DateTime? _parseData(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  factory Aluno.fromJson(dynamic json) {
    if (json is List) {
      return Aluno(
        id: json[0]?.toString() ?? '',
        nome: json[1] as String? ?? '',
        telefone: json[2] as String? ?? '',
        email: json[3] as String? ?? '',
        modalidade: json[4] as String? ?? '',
        presencas: json[5] as int? ?? 0,
        faltas: json[6] as int? ?? 0,
        ativo: json[7] == 1,
        ultimaAula: json[8] as String?,
      );
    }

    final map = json as Map<String, dynamic>;
    return Aluno(
      id: map['id']?.toString() ?? '',
      nome: map['nome'] as String? ?? '',
      telefone: map['telefone'] as String? ?? '',
      email: map['email'] as String? ?? '',
      modalidade: map['modalidade'] as String? ?? '',
      presencas: map['presencas'] as int? ?? 0,
      faltas: map['faltas'] as int? ?? 0,
      ativo: map['ativo'] == 1 || map['ativo'] == true,
      ultimaAula: map['ultimaAula'] as String?,
      createdBy: _parseInt(map['created_by']),
      updatedBy: _parseInt(map['updated_by']),
      createdAt: _parseData(map['created_at']),
      updatedAt: _parseData(map['updated_at']),
    );
  }
}
