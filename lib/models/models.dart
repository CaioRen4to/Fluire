// Unified Models

// --- From usuario.dart ---
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
      nome: (json['nome'] ?? json['name'])?.toString() ?? '',
      email: json['email'] as String? ?? '',
      tipoUsuario: json['tipo_usuario']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      if (tipoUsuario != null) 'tipo_usuario': tipoUsuario,
    };
  }

  String get rotuloTipo {
    if (tipoUsuario == null || tipoUsuario!.isEmpty) return 'Usuário';
    return tipoUsuario!;
  }
}


// --- From aluno.dart ---
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


// --- From aula.dart ---
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
  final String diaSemana;
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
    this.diaSemana = 'segunda-feira',
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
    String? diaSemana,
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

  static String _converterDiaSemana(dynamic diaSemana) {
    if (diaSemana == null) return 'segunda-feira';

    // Se já for string, retorna direto
    if (diaSemana is String) {
      return diaSemana;
    }

    // Se for número, converte para string
    if (diaSemana is int) {
      switch (diaSemana) {
        case 1:
          return 'segunda-feira';
        case 2:
          return 'terça-feira';
        case 3:
          return 'quarta-feira';
        case 4:
          return 'quinta-feira';
        case 5:
          return 'sexta-feira';
        case 6:
          return 'sábado';
        case 7:
          return 'domingo';
        default:
          return 'segunda-feira';
      }
    }

    return 'segunda-feira'; // Padrão
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
        frequencia: (json['frequencia'] ?? json['frequencias'])?.toString() ?? 'Semanal',
        alunoIds: (json['alunoIds'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        status: StatusAula.values[json['status'] as int? ?? 1],
        diaSemana: _converterDiaSemana(json['dia_semana']),
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
      diaSemana: _converterDiaSemana(json['diaSemana']),
    );
  }
}


// --- From aula_aluno.dart ---
class AulaAluno {
  final String? id;
  final int aulaId;
  final int alunoId;

  AulaAluno({
    this.id,
    required this.aulaId,
    required this.alunoId,
  });

  factory AulaAluno.fromJson(Map<String, dynamic> json) {
    return AulaAluno(
      id: json['id']?.toString(),
      aulaId: int.tryParse(json['aula_id']?.toString() ?? '') ?? 0,
      alunoId: int.tryParse(json['aluno_id']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'aula_id': aulaId,
      'aluno_id': alunoId,
    };
  }
}


// --- From dashboard.dart ---
class DashboardData {
  final int totalAlunos;
  final int totalAulas;
  final int alunosPresentes;
  final int aulasHoje;
  final int emAndamento;
  final int frequenciaMedia;
  final List<Map<String, dynamic>> weeklyFrequency;
  final List<Map<String, dynamic>> todayClasses;
  final int alunosComFalta;

  DashboardData({
    required this.totalAlunos,
    required this.totalAulas,
    required this.alunosPresentes,
    required this.aulasHoje,
    required this.emAndamento,
    required this.frequenciaMedia,
    required this.weeklyFrequency,
    required this.todayClasses,
    required this.alunosComFalta,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    final totalAlunos = _parseInt(data['total_alunos'] ?? data['totalAlunos'] ?? 0);
    final totalAulas = _parseInt(data['total_aulas'] ?? data['totalAulas'] ?? 0);
    final alunosComFalta = _parseInt(data['total_alunos_com_falta'] ?? data['alunos_com_falta'] ?? data['alunosComFalta'] ?? data['faltas'] ?? 0);
    final alunosPresentes = _parseInt(data['alunos_presentes'] ?? data['alunosPresentes'] ?? 0);
    final alunosPresentesCalculados = alunosPresentes > 0 ? alunosPresentes : (totalAlunos - alunosComFalta).clamp(0, totalAlunos);
    final aulasHoje = _parseInt(data['aulas_hoje'] ?? data['aulasHoje'] ?? 0);
    final emAndamento = _parseInt(data['em_andamento'] ?? data['emAndamento'] ?? 0);
    final frequenciaMedia = _parseInt(data['frequencia_media'] ?? data['frequenciaMedia'] ?? data['media_frequencia'] ?? 0);
    return DashboardData(
      totalAlunos: totalAlunos,
      totalAulas: totalAulas,
      alunosPresentes: alunosPresentesCalculados,
      aulasHoje: aulasHoje,
      emAndamento: emAndamento,
      frequenciaMedia: frequenciaMedia,
      weeklyFrequency: _parseWeeklyFrequency(data['semana_frequencia'] ?? data['weekly_frequency'] ?? data['weeklyFrequency'] ?? data['estatisticas_semanais'] ?? data['estatisticasSemanais'] ?? []),
      todayClasses: _parseTodayClasses(data['today_classes'] ?? data['todayClasses'] ?? data['proximas_aulas'] ?? data['proximasAulas'] ?? []),
      alunosComFalta: alunosComFalta,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_alunos': totalAlunos,
      'total_aulas': totalAulas,
      'alunos_presentes': alunosPresentes,
      'aulas_hoje': aulasHoje,
      'em_andamento': emAndamento,
      'frequencia_media': frequenciaMedia,
      'weekly_frequency': weeklyFrequency,
      'today_classes': todayClasses,
      'alunos_com_falta': alunosComFalta,
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    final parsed = int.tryParse(value.toString());
    return parsed ?? 0;
  }

  static List<Map<String, dynamic>> _toMapList(dynamic value) {
    if (value is List) {
      return value.map<Map<String, dynamic>>((item) {
        if (item is Map<String, dynamic>) {
          return item;
        }
        return <String, dynamic>{'value': item};
      }).toList();
    }
    return [];
  }

  static List<Map<String, dynamic>> _parseWeeklyFrequency(dynamic value) {
    final lista = _toMapList(value);
    return lista.map((item) {
      return {
        'day': item['day']?.toString() ?? item['dia']?.toString() ?? '',
        'value': _parseDouble(item['value'] ?? item['valor'] ?? 0),
      };
    }).toList();
  }

  static List<Map<String, dynamic>> _parseTodayClasses(dynamic value) {
    final lista = _toMapList(value);
    return lista.map((item) {
      return {
        'title': item['title']?.toString() ?? item['nome']?.toString() ?? 'Aula',
        'teacher': item['teacher']?.toString() ?? item['professor']?.toString() ?? 'Professor',
        'time': item['time']?.toString() ?? item['horario_inicio']?.toString() ?? '',
        'students': item['students']?.toString() ?? '${_parseInt(item['alunos'] ?? item['total_alunos']).toString()} alunos',
        'status': item['status']?.toString() ?? 'ativa',
      };
    }).toList();
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}


// --- From frequencia.dart ---
class Frequencia {
  final String? id;
  final int aulaId;
  final int alunoId;
  final int presente;
  final String dataPresenca;

  Frequencia({
    this.id,
    required this.aulaId,
    required this.alunoId,
    required this.presente,
    required this.dataPresenca,
  });

  factory Frequencia.fromJson(Map<String, dynamic> json) {
    return Frequencia(
      id: json['id']?.toString(),
      aulaId: int.tryParse(json['aula_id']?.toString() ?? '') ?? 0,
      alunoId: int.tryParse(json['aluno_id']?.toString() ?? '') ?? 0,
      presente: int.tryParse(json['presente']?.toString() ?? '') ?? 0,
      dataPresenca: json['data_presenca']?.toString() ?? json['dataPresenca']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'aula_id': aulaId,
      'aluno_id': alunoId,
      'presente': presente,
      'data_presenca': dataPresenca,
    };
  }
}


// --- From professor.dart ---

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


// --- From registro_auditoria.dart ---
enum TipoEntidadeAuditoria { aluno, aula }

enum TipoAcaoAuditoria { criacao, atualizacao }

class RegistroAuditoria {
  final TipoEntidadeAuditoria entidade;
  final TipoAcaoAuditoria acao;
  final String titulo;
  final String subtitulo;
  final String? criadoPor;
  final String? atualizadoPor;
  final DateTime? dataCriacao;
  final DateTime? dataAtualizacao;

  const RegistroAuditoria({
    required this.entidade,
    required this.acao,
    required this.titulo,
    required this.subtitulo,
    this.criadoPor,
    this.atualizadoPor,
    this.dataCriacao,
    this.dataAtualizacao,
  });

  DateTime? get dataReferencia =>
      acao == TipoAcaoAuditoria.criacao ? dataCriacao : dataAtualizacao;

  String get rotuloAcao =>
      acao == TipoAcaoAuditoria.criacao ? 'Criado' : 'Atualizado';

  String get rotuloEntidade =>
      entidade == TipoEntidadeAuditoria.aluno ? 'Aluno' : 'Aula';

  String get usuarioReferencia {
    if (acao == TipoAcaoAuditoria.criacao) {
      return criadoPor ?? '—';
    }
    return atualizadoPor ?? '—';
  }

  String formatarData(DateTime? data) {
    if (data == null) return '—';
    final d = data.day.toString().padLeft(2, '0');
    final m = data.month.toString().padLeft(2, '0');
    final y = data.year;
    final h = data.hour.toString().padLeft(2, '0');
    final min = data.minute.toString().padLeft(2, '0');
    return '$d/$m/$y às $h:$min';
  }
}


