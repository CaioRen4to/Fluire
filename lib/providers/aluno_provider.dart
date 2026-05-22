import 'package:flutter/foundation.dart';
import 'package:fluire/core/estado_carregamento.dart';
import 'package:fluire/models/aluno.dart';
import 'package:fluire/services/aluno_service.dart';

class AlunoProvider extends ChangeNotifier {
  final AlunoService _service;

  AlunoProvider(this._service);

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

  Future<bool> salvar(Aluno aluno, {bool criando = false}) async {
    try {
      final salvo = await _service.salvar(aluno, criando: criando);
      if (criando) {
        alunos = [...alunos, salvo];
      } else {
        alunos = alunos.map((a) => a.id == salvo.id ? salvo : a).toList();
      }
      estado = alunos.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
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
}
