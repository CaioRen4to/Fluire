import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:fluire/api/api_client.dart';
import 'package:fluire/api/api_services.dart';
import 'package:fluire/models/models.dart';
import 'package:fluire/utils/utils.dart';

// --- From provedor_auth.dart ---

class ProvedorAuth extends ChangeNotifier {
  final AuthService _authService;

  ProvedorAuth(this._authService, {Usuario? usuarioInicial}) {
    usuario = usuarioInicial;
    estado = usuario != null ? EstadoCarregamento.sucesso : EstadoCarregamento.inicial;
  }

  EstadoCarregamento estado = EstadoCarregamento.inicial;
  Usuario? usuario;
  String? mensagemErro;

  bool get autenticado => usuario != null;

  Future<bool> login(String email, String senha) async {
    estado = EstadoCarregamento.carregando;
    mensagemErro = null;
    notifyListeners();
    try {
      usuario = await _authService.login(email, senha);
      estado = EstadoCarregamento.sucesso;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cadastrar(String nome, String email, String senha) async {
    estado = EstadoCarregamento.carregando;
    mensagemErro = null;
    notifyListeners();
    try {
      usuario = await _authService.cadastrar(
        nome: nome,
        email: email,
        senha: senha,
      );
      estado = EstadoCarregamento.sucesso;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
      notifyListeners();
      return false;
    }
  }

  Future<bool> recuperarSenha(String email) async {
    estado = EstadoCarregamento.carregando;
    mensagemErro = null;
    notifyListeners();
    try {
      await _authService.recuperarSenha(email);
      estado = EstadoCarregamento.sucesso;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    usuario = null;
    estado = EstadoCarregamento.inicial;
    notifyListeners();
  }

  Future<bool> validarCodigoAlterarSenha(String email, String codigo, String novaSenha) async {
    estado = EstadoCarregamento.carregando;
    mensagemErro = null;
    notifyListeners();
    try {
      await _authService.validarCodigoAlterarSenha(email, codigo, novaSenha);
      estado = EstadoCarregamento.sucesso;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
      notifyListeners();
      return false;
    }
  }

  void limparErro() {
    mensagemErro = null;
    if (estado == EstadoCarregamento.erro) {
      estado = EstadoCarregamento.inicial;
      notifyListeners();
    }
  }
}


// --- From provedor_alunos.dart ---

class ProvedorAlunos extends ChangeNotifier {
  final AlunosService _service;

  ProvedorAlunos(this._service);

  EstadoCarregamento estado = EstadoCarregamento.inicial;
  List<Aluno> alunos = [];
  String? mensagemErro;
  String busca = '';

  List<Aluno> get alunosFiltrados {
    if (busca.trim().isEmpty) return alunos;
    final q = busca.toLowerCase();
    return alunos
        .where((a) =>
            a.nome.toLowerCase().contains(q) ||
            a.modalidade.toLowerCase().contains(q))
        .toList();
  }

  int get total => alunos.length;
  int get ativos => alunos.where((a) => a.ativo).length;

  Future<void> carregar() async {
    estado = EstadoCarregamento.carregando;
    mensagemErro = null;
    notifyListeners();
    try {
      alunos = await _service.listar();
      estado = alunos.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
      notifyListeners();
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
      notifyListeners();
    }
  }

  void definirBusca(String valor) {
    busca = valor;
    notifyListeners();
  }

  Future<bool> criar(Aluno aluno) async {
    final estadoAnterior = estado;
    try {
      final criado = await _service.criar(aluno);
      alunos = [...alunos, criado];
      estado = alunos.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
      mensagemErro = null;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = estadoAnterior;
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizar(Aluno aluno) async {
    final estadoAnterior = estado;
    try {
      final atualizado = await _service.atualizar(aluno);
      alunos = alunos.map((a) => a.id == atualizado.id ? atualizado : a).toList();
      estado = alunos.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
      mensagemErro = null;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = estadoAnterior;
      notifyListeners();
      return false;
    }
  }

  Aluno? buscarLocal(String id) {
    try {
      return alunos.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> remover(String id) async {
    try {
      await _service.remover(id);
      alunos = alunos.where((a) => a.id != id).toList();
      estado = alunos.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
      notifyListeners();
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }
}


// --- From provedor_aulas.dart ---

class ProvedorAulas extends ChangeNotifier {
  final AulasService _service;
  final UsuariosService _usuariosService;

  ProvedorAulas(this._service, [UsuariosService? usuariosService])
      : _usuariosService = usuariosService ?? UsuariosService();

  EstadoCarregamento estado = EstadoCarregamento.inicial;
  List<Aula> aulas = [];
  List<Professor> professores = [];
  bool carregandoProfessores = false;
  String? mensagemErroProfessores;
  String? mensagemErro;
  String busca = '';
  String diaSelecionado = 'segunda-feira';

  String _normalizarDia(String dia) {
    return dia.toLowerCase().trim();
  }

  List<Aula> get aulasFiltradas {
    var lista = aulas.where((a) => _normalizarDia(a.diaSemana) == _normalizarDia(diaSelecionado)).toList();
    if (busca.trim().isNotEmpty) {
      final q = busca.toLowerCase();
      lista = lista
          .where((a) =>
              a.nome.toLowerCase().contains(q) ||
              a.professorNome.toLowerCase().contains(q))
          .toList();
    }
    return lista;
  }

  Future<void> carregar() async {
    estado = EstadoCarregamento.carregando;
    mensagemErro = null;
    notifyListeners();

    await carregarProfessores();

    try {
      final listaAulas = await _service.listar();
      
      final aulaAlunoService = AulaAlunoService();
      List<AulaAluno> assoc = [];
      try {
        assoc = await aulaAlunoService.listar();
      } catch (_) {}

      final mapAssoc = <String, List<String>>{};
      for (final a in assoc) {
        final aulaKey = a.aulaId.toString();
        mapAssoc.putIfAbsent(aulaKey, () => []).add(a.alunoId.toString());
      }

      aulas = listaAulas.map((aula) {
        final ids = mapAssoc[aula.id] ?? [];
        return aula.copyWith(alunoIds: ids);
      }).toList();

      if (professores.isEmpty) {
        professores = _extrairProfessores(aulas);
        notifyListeners();
      }
      estado = aulas.isEmpty && professores.isEmpty
          ? EstadoCarregamento.vazio
          : EstadoCarregamento.sucesso;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = professores.isEmpty ? EstadoCarregamento.erro : EstadoCarregamento.sucesso;
    }
    notifyListeners();
  }

  /// Carrega professores de GET /usuarios (tabela `usuarios`).
  /// Independente de /aulas — o dropdown Nova Aula depende deste método.
  Future<void> carregarProfessores() async {
    carregandoProfessores = true;
    mensagemErroProfessores = null;
    notifyListeners();
    try {
      professores = await _buscarProfessoresDaApi();
      if (professores.isEmpty) {
        professores = _extrairProfessores(aulas);
      }
    } catch (e) {
      mensagemErroProfessores = e.toString().replaceFirst('Exception: ', '');
      professores = _extrairProfessores(aulas);
    }
    carregandoProfessores = false;
    notifyListeners();
  }

  Future<List<Professor>> _buscarProfessoresDaApi() async {
    final usuarios = await _usuariosService.listar();
    return usuarios
        .where((u) => u.id.isNotEmpty && u.nome.isNotEmpty)
        .map(Professor.fromUsuario)
        .toList();
  }

  List<Professor> _extrairProfessores(List<Aula> lista) {
    final map = <String, Professor>{};
    for (final aula in lista) {
      final id = aula.usuarioId.isNotEmpty ? aula.usuarioId : aula.professorId;
      if (id.isEmpty) continue;
      map[id] = Professor(
        id: id,
        nome: aula.professorNome.isNotEmpty ? aula.professorNome : 'Professor #$id',
      );
    }
    return map.values.toList();
  }

  void definirBusca(String valor) {
    busca = valor;
    notifyListeners();
  }

  void definirDia(String dia) {
    diaSelecionado = dia;
    notifyListeners();
  }

  Future<bool> criar(Aula aula) async {
    try {
      var nova = aula;
      if (nova.usuarioId.isEmpty && ApiClient.instance.userId != null) {
        nova = nova.copyWith(usuarioId: ApiClient.instance.userId.toString());
      }
      final criada = await _service.criar(nova);
      
      final aulaId = int.tryParse(criada.id);
      if (aulaId != null) {
        final aulaAlunoService = AulaAlunoService();
        for (final alunoIdStr in aula.alunoIds) {
          final alunoId = int.tryParse(alunoIdStr);
          if (alunoId != null) {
            await aulaAlunoService.associar(aulaId, alunoId);
          }
        }
      }

      aulas = [...aulas, criada.copyWith(alunoIds: aula.alunoIds)];
      await carregarProfessores();
      estado = aulas.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizar(Aula aula) async {
    try {
      final atualizada = await _service.atualizar(aula);

      final aulaId = int.tryParse(aula.id);
      if (aulaId != null) {
        final aulaAlunoService = AulaAlunoService();
        final alunosExistentes = await aulaAlunoService.obterAlunosDeUmaAula(aulaId);
        final alunoIdsExistentes = alunosExistentes
            .map((e) => e['aluno_id']?.toString() ?? e['id']?.toString() ?? '')
            .where((id) => id.isNotEmpty)
            .toSet();

        final novosIds = aula.alunoIds.toSet();

        for (final idExistente in alunoIdsExistentes) {
          if (!novosIds.contains(idExistente)) {
            final alunoId = int.tryParse(idExistente);
            if (alunoId != null) {
              await aulaAlunoService.remover(aulaId, alunoId);
            }
          }
        }

        for (final novoId in novosIds) {
          if (!alunoIdsExistentes.contains(novoId)) {
            final alunoId = int.tryParse(novoId);
            if (alunoId != null) {
              await aulaAlunoService.associar(aulaId, alunoId);
            }
          }
        }
      }

      aulas = aulas.map((a) => a.id == atualizada.id ? atualizada.copyWith(alunoIds: aula.alunoIds) : a).toList();
      await carregarProfessores();
      estado = aulas.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
      notifyListeners();
      return false;
    }
  }

  Future<bool> salvar(Aula aula, {bool criando = false}) async {
    if (criando) {
      return criar(aula);
    } else {
      return atualizar(aula);
    }
  }

  Aula? buscarLocal(String id) {
    try {
      return aulas.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> remover(String id) async {
    try {
      await _service.remover(id);
      aulas.removeWhere((a) => a.id == id);
      estado = aulas.isEmpty && professores.isEmpty
          ? EstadoCarregamento.vazio
          : EstadoCarregamento.sucesso;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}


// --- From provedor_dashboard.dart ---

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


// --- From provedores_app.dart ---

class ProvedoresApp {
  static List<ChangeNotifierProvider> providers({AuthService? authService}) {
    final auth = authService ?? AuthService();
    return [
      ChangeNotifierProvider<ProvedorAuth>(
        create: (_) => ProvedorAuth(auth, usuarioInicial: auth.usuarioAtual),
      ),
      ChangeNotifierProvider<ProvedorAlunos>(
        create: (_) => ProvedorAlunos(AlunosService()),
      ),
      ChangeNotifierProvider<ProvedorAulas>(
        create: (_) => ProvedorAulas(AulasService(), UsuariosService()),
      ),
      ChangeNotifierProvider<ProvedorDashboard>(
        create: (_) => ProvedorDashboard(DashboardService(), AulasService()),
      ),
    ];
  }
}


