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
