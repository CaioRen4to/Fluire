import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluire/api/api_client.dart';
import 'package:fluire/models/models.dart';

// --- From alunos_service.dart ---

class AlunosService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Aluno>> listar() async {
    final response = await _api.get('/alunos');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar alunos: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    final alunos = <Aluno>[];
    for (final item in jsonData) {
      try {
        alunos.add(Aluno.fromJson(item));
      } catch (_) {
        continue;
      }
    }
    return alunos;
  }

  Future<Aluno?> buscarPorId(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.get('/alunos/$idInt');

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar aluno: ${response.statusCode}');
    }

    return Aluno.fromJson(ApiClient.decodificarCorpo(response));
  }

  Future<Aluno> criar(Aluno aluno) async {
    final body = {
      'nome': aluno.nome,
      'email': aluno.email,
      'telefone': aluno.telefone,
      if (_api.userId != null) 'usuario_logado_id': _api.userId,
    };

    final response = await _api.post('/alunos', body: body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao criar aluno'));
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is Map<String, dynamic>) {
      final alunoId = jsonData['id']?.toString() ?? aluno.id;
      return aluno.copyWith(id: alunoId);
    }

    return aluno;
  }

  Future<Aluno> atualizar(Aluno aluno) async {
    final idInt = int.tryParse(aluno.id);
    if (idInt == null) throw Exception('ID inválido: ${aluno.id}');

    final body = {
      'id': idInt,
      'nome': aluno.nome,
      'email': aluno.email,
      'telefone': aluno.telefone,
      'modalidade': aluno.modalidade,
      'ativo': aluno.ativo,
      'presencas': aluno.presencas,
      'faltas': aluno.faltas,
      if (aluno.ultimaAula != null) 'ultima_aula': aluno.ultimaAula,
      if (_api.userId != null) 'usuario_logado_id': _api.userId,
    };

    final response = await _api.put('/alunos/$idInt', body: body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao atualizar aluno'));
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is Map<String, dynamic>) {
      try {
        return Aluno.fromJson(jsonData);
      } catch (_) {
        // Caso o backend retorne um JSON com formato inesperado, retorna o objeto enviado
      }
    }

    return aluno;
  }

  Future<void> remover(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.delete('/alunos/$idInt');

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao remover aluno'));
    }
  }

  Future<List<Aluno>> buscarPorNome(String nome) async {
    final response = await _api.get('/alunos/nome/$nome');

    if (response.statusCode == 404) return [];
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar alunos: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    return jsonData.map((json) => Aluno.fromJson(json)).toList();
  }
}


// --- From aula_aluno_service.dart ---

class AulaAlunoService {
  final ApiClient _api = ApiClient.instance;

  Future<List<AulaAluno>> listar() async {
    final response = await _api.get('/aula-alunos');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar associações: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    List<dynamic> list = [];
    if (jsonData is Map) {
      list = jsonData['dados'] ?? jsonData['data'] ?? [];
    } else if (jsonData is List) {
      list = jsonData;
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => AulaAluno.fromJson(json))
        .toList();
  }

  Future<AulaAluno?> buscarPorId(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.get('/aula-alunos/$idInt');

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar associação: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is Map<String, dynamic>) {
      return AulaAluno.fromJson(jsonData);
    }
    return null;
  }

  Future<AulaAluno> associar(int aulaId, int alunoId) async {
    final response = await _api.post('/aula-alunos', body: {
      'aula_id': aulaId,
      'aluno_id': alunoId,
    });

    if (response.statusCode != 201) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao associar aluno à aula'));
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    return AulaAluno.fromJson(jsonData as Map<String, dynamic>);
  }

  Future<void> remover(int aulaId, int alunoId) async {
    final response = await _api.delete('/aula-alunos', body: {
      'aula_id': aulaId,
      'aluno_id': alunoId,
    });

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao remover associação'));
    }
  }

  Future<List<Map<String, dynamic>>> obterAlunosDeUmaAula(int aulaId) async {
    final response = await _api.get('/aulas/$aulaId/alunos');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar alunos da aula: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is Map) {
      final list = jsonData['dados'] ?? jsonData['data'];
      if (list is List) {
        return list.cast<Map<String, dynamic>>();
      }
    }
    if (jsonData is List) {
      return jsonData.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> obterAulasDeUmAluno(int alunoId) async {
    final response = await _api.get('/alunos/$alunoId/aulas');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar aulas do aluno: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is Map) {
      final list = jsonData['dados'] ?? jsonData['data'];
      if (list is List) {
        return list.cast<Map<String, dynamic>>();
      }
    }
    if (jsonData is List) {
      return jsonData.cast<Map<String, dynamic>>();
    }
    return [];
  }
}


// --- From aulas_service.dart ---

class AulasService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Aula>> listar() async {
    final response = await _api.get('/aulas');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar aulas: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    final aulas = <Aula>[];
    for (final item in jsonData) {
      try {
        aulas.add(Aula.fromJson(item));
      } catch (_) {
        continue;
      }
    }
    return aulas;
  }

  Future<Aula?> buscarPorId(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.get('/aulas/$idInt');

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar aula: ${response.statusCode}');
    }

    return Aula.fromJson(ApiClient.decodificarCorpo(response));
  }

  Future<Aula> criar(Aula aula) async {
    final payload = Map<String, dynamic>.from(aula.toJson());
    if (_api.userId != null) {
      payload['usuario_id'] = _api.userId;
    }

    final response = await _api.post('/aulas', body: payload);

    if (response.statusCode != 201) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao criar aula'));
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    return aula.copyWith(id: jsonData['id'].toString());
  }

  Future<Aula> atualizar(Aula aula) async {
    final idInt = int.tryParse(aula.id);
    if (idInt == null) throw Exception('ID inválido: ${aula.id}');

    final payload = Map<String, dynamic>.from(aula.toJson());
    if (_api.userId != null) {
      payload['usuario_id'] = _api.userId;
    }

    final response = await _api.put('/aulas/$idInt', body: payload);

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao atualizar aula'));
    }

    return aula;
  }

  Future<void> remover(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.delete('/aulas/$idInt');

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao remover aula'));
    }
  }
}


// --- From auth_service.dart ---


class AuthService {
  AuthService();

  final ApiClient _api = ApiClient.instance;
  Usuario? _usuario;

  static const String _usuarioKey = 'api_usuario';

  Usuario? get usuarioAtual => _usuario;

  Future<void> carregarSessao() async {
    await _api.carregarSessao();
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString(_usuarioKey);
    if (usuarioJson != null) {
      try {
        _usuario = Usuario.fromJson(json.decode(usuarioJson) as Map<String, dynamic>);
      } catch (_) {
        _usuario = null;
      }
    }
  }

  Future<Usuario> login(String email, String senha) async {
    final response = await _api.post('/login', body: {
      'email': email.trim(),
      'senha': senha,
    });

    final jsonData = ApiClient.decodificarCorpo(response);

    if (response.statusCode != 200) {
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Email ou senha incorretos'));
    }

    final usuarioJson = jsonData['usuario'] as Map<String, dynamic>?;
    final token = jsonData['token']?.toString();

    if (usuarioJson == null || token == null) {
      throw Exception('Resposta de login inválida');
    }

    final usuario = Usuario.fromJson(usuarioJson);
    await _api.definirSessao(token: token, userId: int.parse(usuario.id));
    _usuario = usuario;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usuarioKey, json.encode(usuarioJson));

    return usuario;
  }

  Future<Usuario> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final response = await _api.post('/usuarios', body: {
      'nome': nome.trim(),
      'email': email.trim(),
      'senha': senha,
    });

    final jsonData = ApiClient.decodificarCorpo(response);

    if (response.statusCode != 201) {
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao criar conta'));
    }

    return login(email, senha);
  }

  Future<void> recuperarSenha(String email) async {
    final response = await _api.post('/recuperar-senha', body: {
      'email': email.trim(),
    });

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao recuperar senha'));
    }
  }

  Future<void> logout() async {
    await _api.limparSessao();
    _usuario = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usuarioKey);
  }

  Future<void> validarCodigoAlterarSenha(String email, String codigo, String novaSenha) async {
    final response = await _api.post('/validar-codigo-alterar-senha', body: {
      'email': email.trim(),
      'codigo': codigo.trim(),
      'nova_senha': novaSenha,
    });

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao alterar senha'));
    }
  }
}


// --- From dashboard_service.dart ---

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


// --- From frequencia_service.dart ---

class FrequenciaService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Frequencia>> listar() async {
    final response = await _api.get('/frequencias');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar frequências: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    return jsonData
        .whereType<Map<String, dynamic>>()
        .map((json) => Frequencia.fromJson(json))
        .toList();
  }

  Future<List<Frequencia>> listarPorAula(int aulaId) async {
    final response = await _api.get('/frequencias/aulas/$aulaId');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar frequências da aula: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    return jsonData
        .whereType<Map<String, dynamic>>()
        .map((json) => Frequencia.fromJson(json))
        .toList();
  }

  Future<Frequencia> registrar({
    required int aulaId,
    required int alunoId,
    required int presente,
    required String dataPresenca,
  }) async {
    final response = await _api.post('/frequencias', body: {
      'aula_id': aulaId,
      'aluno_id': alunoId,
      'presente': presente,
      'data_presenca': dataPresenca,
    });

    if (response.statusCode != 201) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao registrar frequência'));
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is Map<String, dynamic> && (jsonData.containsKey('aula_id') || jsonData.containsKey('id'))) {
      return Frequencia.fromJson(jsonData);
    }
    return Frequencia(
      aulaId: aulaId,
      alunoId: alunoId,
      presente: presente,
      dataPresenca: dataPresenca,
    );
  }
}


// --- From historico_service.dart ---

class HistoricoService {
  final AlunosService _alunosService = AlunosService();
  final AulasService _aulasService = AulasService();
  final UsuariosService _usuariosService = UsuariosService();

  Future<List<RegistroAuditoria>> listarAtividades({int limite = 50}) async {
    // Busca alunos, aulas e usuários em paralelo
    final resultados = await Future.wait([
      _alunosService.listar(),
      _aulasService.listar(),
      _carregarUsuarios(),
    ]);

    final alunos = resultados[0] as List;
    final aulas = resultados[1] as List;
    final mapaUsuarios = resultados[2] as Map<int, String>;

    final registros = <RegistroAuditoria>[];

    for (final aluno in alunos) {
      if (aluno.createdAt != null || aluno.createdBy != null) {
        registros.add(
          RegistroAuditoria(
            entidade: TipoEntidadeAuditoria.aluno,
            acao: TipoAcaoAuditoria.criacao,
            titulo: aluno.nome,
            subtitulo: aluno.email.isNotEmpty ? aluno.email : aluno.telefone,
            criadoPor: _nomeUsuario(aluno.createdBy, mapaUsuarios),
            dataCriacao: aluno.createdAt,
          ),
        );
      }

      if (aluno.updatedAt != null || aluno.updatedBy != null) {
        registros.add(
          RegistroAuditoria(
            entidade: TipoEntidadeAuditoria.aluno,
            acao: TipoAcaoAuditoria.atualizacao,
            titulo: aluno.nome,
            subtitulo: aluno.email.isNotEmpty ? aluno.email : aluno.telefone,
            criadoPor: _nomeUsuario(aluno.createdBy, mapaUsuarios),
            atualizadoPor: _nomeUsuario(aluno.updatedBy, mapaUsuarios),
            dataCriacao: aluno.createdAt,
            dataAtualizacao: aluno.updatedAt,
          ),
        );
      }
    }

    for (final aula in aulas) {
      if (aula.createdAt != null || aula.createdBy != null || aula.id.isNotEmpty) {
        registros.add(
          RegistroAuditoria(
            entidade: TipoEntidadeAuditoria.aula,
            acao: TipoAcaoAuditoria.criacao,
            titulo: aula.nome,
            subtitulo: aula.horario,
            criadoPor: _nomeUsuario(aula.createdBy, mapaUsuarios) ?? 'Não informado',
            dataCriacao: aula.createdAt ?? DateTime.now(),
          ),
        );
      }

      // Se temos indicação de alteração ou se pudermos identificar que houve alteração (updatedBy/updatedAt)
      if (aula.updatedAt != null || aula.updatedBy != null) {
        registros.add(
          RegistroAuditoria(
            entidade: TipoEntidadeAuditoria.aula,
            acao: TipoAcaoAuditoria.atualizacao,
            titulo: aula.nome,
            subtitulo: aula.horario,
            criadoPor: _nomeUsuario(aula.createdBy, mapaUsuarios),
            atualizadoPor: _nomeUsuario(aula.updatedBy, mapaUsuarios) ?? 'Usuário logado',
            dataCriacao: aula.createdAt,
            dataAtualizacao: aula.updatedAt ?? DateTime.now(),
          ),
        );
      }
    }

    registros.sort((a, b) {
      final da = a.dataReferencia ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db = b.dataReferencia ?? DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });

    if (registros.length > limite) {
      return registros.sublist(0, limite);
    }
    return registros;
  }

  /// Carrega a lista de usuários e retorna um mapa ID → Nome.
  /// Em caso de falha, retorna mapa vazio para não quebrar a tela.
  Future<Map<int, String>> _carregarUsuarios() async {
    try {
      final usuarios = await _usuariosService.listar();
      final mapa = <int, String>{};
      for (final usuario in usuarios) {
        final idInt = int.tryParse(usuario.id);
        if (idInt != null && usuario.nome.isNotEmpty) {
          mapa[idInt] = usuario.nome;
        }
      }
      return mapa;
    } catch (_) {
      return <int, String>{};
    }
  }

  /// Resolve o ID de usuário para o nome real.
  /// Retorna null se o ID for nulo (campo não preenchido).
  String? _nomeUsuario(dynamic id, Map<int, String> mapa) {
    if (id == null) return null;
    final idInt = id is int ? id : int.tryParse(id.toString());
    if (idInt == null) return null;
    return mapa[idInt] ?? 'Usuário desconhecido';
  }
}


// --- From usuarios_service.dart ---

class UsuariosService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Usuario>> listar() async {
    final response = await _api.get('/usuarios');

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar usuários: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is! List) return [];

    final usuarios = <Usuario>[];
    for (final item in jsonData) {
      if (item is! Map) continue;
      try {
        usuarios.add(Usuario.fromJson(Map<String, dynamic>.from(item)));
      } catch (_) {
        continue;
      }
    }
    return usuarios;
  }

  Future<Usuario?> buscarPorNome(String nome) async {
    final response = await _api.get('/usuarios/$nome');

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar usuário: ${response.statusCode}');
    }

    final jsonData = ApiClient.decodificarCorpo(response);
    if (jsonData is Map<String, dynamic>) {
      return Usuario.fromJson(jsonData);
    }
    return null;
  }

  Future<Usuario> atualizar(Usuario usuario) async {
    final idInt = int.tryParse(usuario.id);
    if (idInt == null) throw Exception('ID inválido: ${usuario.id}');

    final response = await _api.put('/usuarios/$idInt', body: usuario.toJson());

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao atualizar usuário'));
    }

    return usuario;
  }

  Future<void> remover(String id) async {
    final idInt = int.tryParse(id);
    if (idInt == null) throw Exception('ID inválido: $id');

    final response = await _api.delete('/usuarios/$idInt');

    if (response.statusCode != 200) {
      final jsonData = ApiClient.decodificarCorpo(response);
      throw Exception(ApiClient.extrairErro(jsonData, fallback: 'Erro ao remover usuário'));
    }
  }
}


