import 'package:flutter/foundation.dart';
import 'package:fluire/core/estado_carregamento.dart';
import 'package:fluire/models/aula.dart';
import 'package:fluire/models/professor.dart';
import 'package:fluire/repositories/professor_repository.dart';
import 'package:fluire/services/aula_service.dart';

class AulaProvider extends ChangeNotifier {
  final AulaService _service;
  final ProfessorRepository _professorRepo;

  AulaProvider(this._service, this._professorRepo);

  EstadoCarregamento estado = EstadoCarregamento.inicial;
  List<Aula> aulas = [];
  List<Professor> professores = [];
  String? mensagemErro;
  String busca = '';
  int diaSelecionado = 1;

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
      professores = await _professorRepo.listar();
      estado = aulas.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
    }
    notifyListeners();
  }

  void definirBusca(String valor) {
    busca = valor;
    notifyListeners();
  }

  void definirDia(int dia) {
    diaSelecionado = dia;
    notifyListeners();
  }

  Future<bool> salvar(Aula aula, {bool criando = false}) async {
    try {
      final salva = await _service.salvar(aula, criando: criando);
      if (criando) {
        aulas = [...aulas, salva];
      } else {
        aulas = aulas.map((a) => a.id == salva.id ? salva : a).toList();
      }
      estado = aulas.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
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
