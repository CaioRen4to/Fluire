import 'package:fluire/services/alunos_service.dart';
import 'package:fluire/services/api_client.dart';
import 'package:fluire/services/aulas_service.dart';
import 'package:fluire/services/frequencia_service.dart';

class PainelService {
  final ApiClient _api = ApiClient.instance;
  final AlunosService _alunosService = AlunosService();
  final AulasService _aulasService = AulasService();
  final FrequenciaService _frequenciaService = FrequenciaService();

  Future<Map<String, dynamic>> buscarPainel() async {
    try {
      final response = await _api.get('/painel');
      if (response.statusCode == 200) {
        final jsonData = ApiClient.decodificarCorpo(response);
        if (jsonData is Map && jsonData['success'] == true && jsonData['data'] != null) {
          return Map<String, dynamic>.from(jsonData['data'] as Map);
        }
        if (jsonData is Map && jsonData['data'] != null) {
          return Map<String, dynamic>.from(jsonData['data'] as Map);
        }
        if (jsonData is Map && jsonData.containsKey('total_alunos')) {
          return _adaptarDashboard(jsonData as Map<String, dynamic>);
        }
      }
    } catch (_) {
      // fallback abaixo
    }

    return _montarPainelLocal();
  }

  Map<String, dynamic> _adaptarDashboard(Map<String, dynamic> data) {
    final media = data['media_frequencia'];
    final mediaPercent = media is num ? (media * 100).round() : 0;

    return {
      'alunos_presentes': data['total_alunos'] ?? 0,
      'aulas_hoje': data['total_aulas'] ?? 0,
      'em_andamento': 0,
      'frequencia_media': mediaPercent,
      'weekly_frequency': _frequenciaSemanalPadrao(),
      'today_classes': _adaptarAulas(data['proximas_aulas']),
    };
  }

  Future<Map<String, dynamic>> _montarPainelLocal() async {
    final alunos = await _alunosService.listar();
    final aulas = await _aulasService.listar();
    List<Map<String, dynamic>> frequencias = [];

    try {
      frequencias = await _frequenciaService.listar();
    } catch (_) {}

    final hoje = DateTime.now();
    final diaSemana = hoje.weekday;
    final aulasHoje = aulas.where((a) => a.diaSemana == diaSemana).toList();

    final presentesHoje = frequencias.where((f) {
      final data = f['data_presenca']?.toString() ?? '';
      final hojeStr =
          '${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';
      return data.startsWith(hojeStr) && (f['presente'] == 1 || f['presente'] == true);
    }).length;

    final totalFreq = frequencias.length;
    final totalPresentes = frequencias.where((f) => f['presente'] == 1 || f['presente'] == true).length;
    final media = totalFreq == 0 ? 0 : ((totalPresentes / totalFreq) * 100).round();

    return {
      'alunos_presentes': presentesHoje,
      'aulas_hoje': aulasHoje.length,
      'em_andamento': aulasHoje.length > 0 ? 1 : 0,
      'frequencia_media': media,
      'weekly_frequency': _frequenciaSemanalDeDados(frequencias),
      'today_classes': aulasHoje
          .map((a) => {
                'title': a.nome,
                'teacher': a.professorNome.isNotEmpty ? a.professorNome : 'Professor',
                'time': a.horario,
                'students': '${a.alunoIds.length} alunos',
                'status': 'ativa',
              })
          .toList(),
      'total_alunos': alunos.length,
      'total_aulas': aulas.length,
    };
  }

  List<Map<String, dynamic>> _frequenciaSemanalPadrao() {
    const dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    return dias.map((d) => {'day': d, 'value': 40.0}).toList();
  }

  List<Map<String, dynamic>> _frequenciaSemanalDeDados(List<Map<String, dynamic>> frequencias) {
    const dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    final contagem = List.filled(7, 0);

    for (final f in frequencias) {
      if (f['presente'] != 1 && f['presente'] != true) continue;
      final dataStr = f['data_presenca']?.toString();
      if (dataStr == null || dataStr.isEmpty) continue;
      try {
        final data = DateTime.parse(dataStr);
        final idx = data.weekday - 1;
        if (idx >= 0 && idx < 7) contagem[idx]++;
      } catch (_) {}
    }

    final max = contagem.reduce((a, b) => a > b ? a : b);
    return List.generate(7, (i) {
      final valor = max == 0 ? 0.0 : (contagem[i] / max) * 80.0 + 20.0;
      return {'day': dias[i], 'value': valor};
    });
  }

  List<Map<String, dynamic>> _adaptarAulas(dynamic proximas) {
    if (proximas is! List) return [];
    return proximas.map<Map<String, dynamic>>((item) {
      if (item is Map) {
        return {
          'title': item['nome'] ?? 'Aula',
          'teacher': item['professor'] ?? 'Professor',
          'time': item['horario_inicio'] ?? item['time'] ?? '',
          'students': '${item['alunos'] ?? 0} alunos',
          'status': 'ativa',
        };
      }
      return {
        'title': 'Aula',
        'teacher': 'Professor',
        'time': '',
        'students': '0 alunos',
        'status': 'ativa',
      };
    }).toList();
  }
}
