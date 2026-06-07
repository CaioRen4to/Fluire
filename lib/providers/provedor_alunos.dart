import 'package:flutter/foundation.dart';
import 'package:fluire/utils/estado_carregamento.dart';
import 'package:fluire/models/aluno.dart';
import 'package:fluire/services/alunos_service.dart';

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
