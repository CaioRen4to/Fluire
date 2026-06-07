import 'package:flutter/foundation.dart';
import 'package:fluire/utils/estado_carregamento.dart';
import 'package:fluire/models/dashboard.dart';
import 'package:fluire/models/aula.dart';
import 'package:fluire/models/aula_aluno.dart';
import 'package:fluire/services/dashboard_service.dart';
import 'package:fluire/services/aulas_service.dart';
import 'package:fluire/services/aula_aluno_service.dart';

class ProvedorDashboard extends ChangeNotifier {
  final DashboardService _service;
  final AulasService _aulasService;

  ProvedorDashboard(this._service, this._aulasService);

  EstadoCarregamento estado = EstadoCarregamento.inicial;
  DashboardData? dashboard;
  List<Aula> aulas = [];
  String? mensagemErro;

  Future<void> carregar() async {
    estado = EstadoCarregamento.carregando;
    mensagemErro = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.buscarDashboard(),
        _aulasService.listar(),
        AulaAlunoService().listar(),
      ]);

      dashboard = results[0] as DashboardData;
      final listaAulas = results[1] as List<Aula>;
      final assoc = results[2] as List<AulaAluno>;

      final mapAssoc = <String, List<String>>{};
      for (final a in assoc) {
        final aulaKey = a.aulaId.toString();
        mapAssoc.putIfAbsent(aulaKey, () => []).add(a.alunoId.toString());
      }

      aulas = listaAulas.map((aula) {
        final ids = mapAssoc[aula.id] ?? [];
        return aula.copyWith(alunoIds: ids);
      }).toList();

      estado = dashboard == null ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
    }
    notifyListeners();
  }

  String _normalizarDiaSemana(String dia) {
    return dia
        .toLowerCase()
        .trim()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
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

  int get alunosPresentesReal {
    return dashboard?.alunosPresentes ?? 0;
  }

  int get aulasHojeReal {
    final hoje = DateTime.now();
    final diaSemanaTexto = _normalizarDiaSemana(_converterDiaSemanaInt(hoje.weekday));
    return aulas.where((a) => _normalizarDiaSemana(a.diaSemana) == diaSemanaTexto).length;
  }

  int get aulasEmAndamentoCount {
    final hoje = DateTime.now();
    final diaSemanaTexto = _normalizarDiaSemana(_converterDiaSemanaInt(hoje.weekday));
    final aulasHoje = aulas.where((a) => _normalizarDiaSemana(a.diaSemana) == diaSemanaTexto).toList();

    int count = 0;
    for (final aula in aulasHoje) {
      if (_isTimeInProgress(aula.horario)) {
        count++;
      }
    }
    return count;
  }

  List<Map<String, dynamic>> get todayClassesReal {
    final hoje = DateTime.now();
    final diaSemanaTexto = _normalizarDiaSemana(_converterDiaSemanaInt(hoje.weekday));
    final aulasHoje = aulas.where((a) => _normalizarDiaSemana(a.diaSemana) == diaSemanaTexto).toList();

    // Sort by start time
    aulasHoje.sort((a, b) => a.horarioInicio.compareTo(b.horarioInicio));

    return aulasHoje.map((a) {
      final isInProgress = _isTimeInProgress(a.horario);
      return {
        'id': a.id,
        'title': a.nome,
        'teacher': a.professorNome.isNotEmpty ? a.professorNome : 'Professor #${a.usuarioId}',
        'time': a.horario,
        'students': '${a.alunoIds.length} alunos',
        'status': isInProgress ? 'andamento' : 'ativa',
      };
    }).toList();
  }

  bool _isTimeInProgress(String timeStr) {
    try {
      final parts = timeStr.split('-');
      if (parts.length != 2) return false;
      final startParts = parts[0].trim().split(':');
      final endParts = parts[1].trim().split(':');

      if (startParts.length < 2 || endParts.length < 2) return false;

      final startHour = int.parse(startParts[0]);
      final startMinute = int.parse(startParts[1]);

      final endHour = int.parse(endParts[0]);
      final endMinute = int.parse(endParts[1]);

      final now = DateTime.now();
      final currentMinutes = now.hour * 60 + now.minute;

      final startMinutes = startHour * 60 + startMinute;
      final endMinutes = endHour * 60 + endMinute;

      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } catch (_) {
      return false;
    }
  }

  List<Map<String, dynamic>> get frequenciaSemanaCalculada {
    if (dashboard == null) return [];

    const diasSiglas = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    const diasNomes = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo'
    ];

    final Map<String, String> dePara = {
      'Seg': 'Ter', // Segunda real vem como 'Ter' da API
      'Ter': 'Qua', // Terça real vem como 'Qua' da API
      'Qua': 'Qui', // Quarta real vem como 'Qui' da API
      'Qui': 'Sex', // Quinta real vem como 'Sex' da API
      'Sex': 'Sáb', // Sexta real vem como 'Sáb' da API
      'Sáb': 'Dom', // Sábado real vem como 'Dom' da API
      'Dom': 'Seg', // Domingo real vem como 'Seg' da API
    };

    final Map<String, double> apiValues = {};
    for (final item in dashboard!.weeklyFrequency) {
      final day = item['day']?.toString() ?? '';
      final val = (item['value'] ?? 20.0) as double;
      apiValues[day] = val;
    }

    final totalAlunos = dashboard!.totalAlunos;

    return List.generate(7, (i) {
      final siglaExibicao = diasSiglas[i];
      final siglaApi = dePara[siglaExibicao] ?? siglaExibicao;
      final val = apiValues[siglaApi] ?? 20.0;
      final percentual = ((val - 20.0) / 80.0 * 100.0).clamp(0.0, 100.0).round();
      final presencas = (percentual / 100.0 * totalAlunos).round();

      return {
        'day': siglaExibicao,
        'fullName': diasNomes[i],
        'value': val,
        'presencas': presencas,
        'total': totalAlunos,
        'percentual': percentual,
      };
    });
  }
}
