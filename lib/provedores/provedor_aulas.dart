import 'package:flutter/foundation.dart';
import 'package:fluire/util/estado_carregamento.dart';
import 'package:fluire/modelos/aula.dart';
import 'package:fluire/modelos/professor.dart';
import 'package:fluire/dados/dados_aulas.dart';
import 'package:fluire/dados/dados_professores.dart';

class ProvedorAulas extends ChangeNotifier {
  final DadosAulas _dadosAulas;
  final DadosProfessores _dadosProfessores;

  ProvedorAulas(this._dadosAulas, this._dadosProfessores);

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
      aulas = await _dadosAulas.listar();
      professores = await _dadosProfessores.listar();
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
      final salva = await _dadosAulas.salvar(aula, criando: criando);
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
