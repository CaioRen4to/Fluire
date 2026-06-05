enum StatusAula { emAndamento, proxima, concluida, cancelada }

class Aula {
  final String id;
  final String nome;
  final String usuarioId;
  final String professorId;
  final String professorNome;
  final String horarioInicio;
  final String horarioFim;
  final String frequencia;
  final List<String> alunoIds;
  final StatusAula status;
  final int diaSemana;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Aula({
    required this.id,
    required this.nome,
    required this.usuarioId,
    this.professorId = '',
    this.professorNome = '',
    required this.horarioInicio,
    required this.horarioFim,
    required this.frequencia,
    this.alunoIds = const [],
    this.status = StatusAula.proxima,
    this.diaSemana = 1,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  String get horario => '$horarioInicio - $horarioFim';

  String get statusLabel {
    switch (status) {
      case StatusAula.emAndamento:
        return 'Em andamento';
      case StatusAula.proxima:
        return 'Próxima';
      case StatusAula.concluida:
        return 'Concluída';
      case StatusAula.cancelada:
        return 'Cancelada';
    }
  }

  Aula copyWith({
    String? id,
    String? nome,
    String? usuarioId,
    String? professorId,
    String? professorNome,
    String? horarioInicio,
    String? horarioFim,
    String? frequencia,
    List<String>? alunoIds,
    StatusAula? status,
    int? diaSemana,
    int? createdBy,
    int? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Aula(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      usuarioId: usuarioId ?? this.usuarioId,
      professorId: professorId ?? this.professorId,
      professorNome: professorNome ?? this.professorNome,
      horarioInicio: horarioInicio ?? this.horarioInicio,
      horarioFim: horarioFim ?? this.horarioFim,
      frequencia: frequencia ?? this.frequencia,
      alunoIds: alunoIds ?? this.alunoIds,
      status: status ?? this.status,
      diaSemana: diaSemana ?? this.diaSemana,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'usuario_id': usuarioId,
        'horario_inicio': horarioInicio,
        'horario_fim': horarioFim,
        'frequencia': frequencia,
        'dia_semana': diaSemana,
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

  factory Aula.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return Aula(
        id: json['id']?.toString() ?? '',
        nome: json['nome'] as String? ?? '',
        usuarioId: json['usuario_id']?.toString() ?? '',
        professorId: json['professorId']?.toString() ?? '',
        professorNome: json['professorNome'] as String? ?? '',
        horarioInicio: json['horario_inicio']?.toString() ?? '',
        horarioFim: json['horario_fim']?.toString() ?? '',
        frequencia: json['frequencia'] as String? ?? 'Semanal',
        alunoIds: (json['alunoIds'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        status: StatusAula.values[json['status'] as int? ?? 1],
        diaSemana: json['dia_semana'] as int? ?? 1,
        createdBy: _parseInt(json['created_by']),
        updatedBy: _parseInt(json['updated_by']),
        createdAt: _parseData(json['created_at']),
        updatedAt: _parseData(json['updated_at']),
      );
    }

    return Aula(
      id: json['id'] as String,
      nome: json['nome'] as String,
      usuarioId: json['usuarioId'] as String? ?? '',
      professorId: json['professorId'] as String? ?? '',
      professorNome: json['professorNome'] as String? ?? '',
      horarioInicio: json['horarioInicio'] as String,
      horarioFim: json['horarioFim'] as String? ?? '',
      frequencia: json['frequencia'] as String? ?? 'Semanal',
      alunoIds: (json['alunoIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: StatusAula.values[json['status'] as int? ?? 1],
      diaSemana: json['diaSemana'] as int? ?? 1,
    );
  }
}
