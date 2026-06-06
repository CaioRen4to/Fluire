import 'package:fluire/modelos/dashboard.dart';
import 'package:fluire/modelos/frequencia.dart';
import 'package:fluire/services/alunos_service.dart';
import 'package:fluire/services/api_client.dart';
import 'package:fluire/services/aulas_service.dart';
import 'package:fluire/services/frequencia_service.dart';

class DashboardService {
  final ApiClient _api = ApiClient.instance;
  final AlunosService _alunosService = AlunosService();
  final AulasService _aulasService = AulasService();
  final FrequenciaService _frequenciaService = FrequenciaService();

  Future<DashboardData> buscarDashboard() async {
    try {
      final response = await _api.get('/dashboard');
      if (response.statusCode == 200) {
        final jsonData = ApiClient.decodificarCorpo(response);
        if (jsonData is Map<String, dynamic>) {
          return DashboardData.fromJson(jsonData);
        }
        if (jsonData is Map) {
          return DashboardData.fromJson(Map<String, dynamic>.from(jsonData));
        }
      }
    } catch (_) {
      // fallback abaixo
    }

    return await _montarDashboardLocal();
  }

  String _converterDiaSemanaInt(int dia) {
    switch (dia) {
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

  Future<DashboardData> _montarDashboardLocal() async {
    final alunos = await _alunosService.listar();
    final aulas = await _aulasService.listar();
    List<Frequencia> frequencias = [];

    try {
      frequencias = await _frequenciaService.listar();
    } catch (_) {}

    final hoje = DateTime.now();
    final diaSemanaTexto = _converterDiaSemanaInt(hoje.weekday);
    final aulasHoje = aulas.where((a) => a.diaSemana.toLowerCase().trim() == diaSemanaTexto).toList();

    final hojeStr =
        '${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';
    final presentesHoje = frequencias.where((f) {
      return f.dataPresenca.startsWith(hojeStr) && f.presente == 1;
    }).length;

    final totalFreq = frequencias.length;
    final totalPresentes = frequencias.where((f) => f.presente == 1).length;
    final media = totalFreq == 0 ? 0 : ((totalPresentes / totalFreq) * 100).round();

    return DashboardData(
      totalAlunos: alunos.length,
      totalAulas: aulas.length,
      alunosPresentes: presentesHoje,
      aulasHoje: aulasHoje.length,
      emAndamento: aulasHoje.isNotEmpty ? 1 : 0,
      frequenciaMedia: media,
      weeklyFrequency: _frequenciaSemanalDeDados(frequencias),
      todayClasses: aulasHoje
          .map((a) => {
                'title': a.nome,
                'teacher': a.professorNome.isNotEmpty ? a.professorNome : 'Professor',
                'time': a.horario,
                'students': '${a.alunoIds.length} alunos',
                'status': 'ativa',
              })
          .toList(),
      alunosComFalta: frequencias.where((f) => f.presente == 0).length,
    );
  }

  List<Map<String, dynamic>> _frequenciaSemanalDeDados(List<Frequencia> frequencias) {
    const dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    final contagem = List.filled(7, 0);

    for (final f in frequencias) {
      if (f.presente != 1) continue;
      final dataStr = f.dataPresenca;
      if (dataStr.isEmpty) continue;
      try {
        final data = DateTime.parse(dataStr);
        final idx = data.weekday - 1;
        if (idx >= 0 && idx < 7) contagem[idx]++;
      } catch (_) {}
    }

    final max = contagem.isEmpty ? 0 : contagem.reduce((a, b) => a > b ? a : b);
    return List.generate(7, (i) {
      final valor = max == 0 ? 0.0 : (contagem[i] / max) * 80.0 + 20.0;
      return {'day': dias[i], 'value': valor};
    });
  }
}
