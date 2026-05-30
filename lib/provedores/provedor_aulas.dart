import 'package:flutter/foundation.dart';
import 'package:fluire/util/estado_carregamento.dart';
import 'package:fluire/modelos/aula.dart';
import 'package:fluire/modelos/professor.dart';
import 'package:fluire/services/aulas_service.dart';
import 'package:fluire/services/api_client.dart';

class ProvedorAulas extends ChangeNotifier {
  final AulasService _service;

  ProvedorAulas(this._service);

  EstadoCarregamento estado = EstadoCarregamento.inicial;
  List<Aula> aulas = [];
  List<Professor> professores = [];
  String? mensagemErro;
  String busca = '';
  int diaSelecionado = DateTime.now().weekday;

  List<Aula> get aulasFiltradas {
    var lista = aulas.where((a) => a.diaSemana == diaSelecionado).toList();
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
    try {
      aulas = await _service.listar();
      professores = _extrairProfessores(aulas);
      estado = aulas.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
    }
    notifyListeners();
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

  void definirDia(int dia) {
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
      aulas = [...aulas, criada];
      professores = _extrairProfessores(aulas);
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
      aulas = aulas.map((a) => a.id == atualizada.id ? atualizada : a).toList();
      professores = _extrairProfessores(aulas);
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
}
