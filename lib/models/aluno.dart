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
    final str = value.toString().trim();
    if (str.isEmpty) return null;

    final parsed = DateTime.tryParse(str);
    if (parsed != null) return parsed;

    try {
      final parts = str.split(RegExp(r'\s+'));
      if (parts.length >= 5) {
        int dayIdx = 1;
        if (!parts[0].contains(',')) {
          dayIdx = 0;
        }
        final dayStr = parts[dayIdx].replaceAll(RegExp(r'[^0-9]'), '');
        final day = int.parse(dayStr);

        final monthStr = parts[dayIdx + 1].toLowerCase().substring(0, 3);
        final year = int.parse(parts[dayIdx + 2]);

        final timeParts = parts[dayIdx + 3].split(':');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final second = timeParts.length > 2 ? int.parse(timeParts[2]) : 0;

        final months = {
          'jan': 1, 'feb': 1, 'fev': 2, 'mar': 3, 'apr': 4, 'abr': 4,
          'may': 5, 'mai': 5, 'jun': 6, 'jul': 7, 'aug': 8, 'ago': 8,
          'sep': 9, 'set': 9, 'oct': 10, 'out': 10, 'nov': 11, 'dec': 12, 'dez': 12
        };

        final month = months[monthStr] ?? 1;

        final isUtc = str.toUpperCase().contains('GMT') || str.toUpperCase().contains('UTC');

        if (isUtc) {
          return DateTime.utc(year, month, day, hour, minute, second).toLocal();
        } else {
          return DateTime(year, month, day, hour, minute, second);
        }
      }
    } catch (_) {
      // Retorna null em caso de erro de parsing
    }

    return null;
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
