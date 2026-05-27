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
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'usuario_id': usuarioId,
        'professorId': professorId,
        'professorNome': professorNome,
        'horario_inicio': horarioInicio,
        'horario_fim': horarioFim,
        'frequencia': frequencia,
        'alunoIds': alunoIds,
        'status': status.index,
        'dia_semana': diaSemana,
      };

  factory Aula.fromJson(dynamic json) {
    // Backend retorna dicionário com campos snake_case
    if (json is Map<String, dynamic>) {
      return Aula(
        id: json['id']?.toString() ?? '',
        nome: json['nome'] as String? ?? '',
        usuarioId: json['usuario_id']?.toString() ?? '',
        professorId: json['professorId']?.toString() ?? '',
        professorNome: json['professorNome'] as String? ?? '',
        horarioInicio: json['horario_inicio'] as String? ?? '',
        horarioFim: json['horario_fim'] as String? ?? '',
        frequencia: json['frequencia'] as String? ?? 'Semanal',
        alunoIds: (json['alunoIds'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        status: StatusAula.values[json['status'] as int? ?? 1],
        diaSemana: json['dia_semana'] as int? ?? 1,
      );
    }
    // Fallback para formato camelCase (compatibilidade)
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
