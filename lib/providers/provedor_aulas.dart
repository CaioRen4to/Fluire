import 'package:flutter/foundation.dart';
import 'package:fluire/utils/estado_carregamento.dart';
import 'package:fluire/models/aula.dart';
import 'package:fluire/models/aula_aluno.dart';
import 'package:fluire/models/professor.dart';
import 'package:fluire/services/aulas_service.dart';
import 'package:fluire/services/usuarios_service.dart';
import 'package:fluire/services/aula_aluno_service.dart';
import 'package:fluire/services/api_client.dart';

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
