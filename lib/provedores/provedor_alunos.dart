import 'package:flutter/foundation.dart';
import 'package:fluire/util/estado_carregamento.dart';
import 'package:fluire/modelos/aluno.dart';
import 'package:fluire/dados/dados_alunos.dart';

class ProvedorAlunos extends ChangeNotifier {
  final DadosAlunos _dados;

  ProvedorAlunos(this._dados);

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
      alunos = await _dados.listar();
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
    try {
      final criado = await _dados.criar(aluno);
      alunos = [...alunos, criado];
      estado = alunos.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizar(Aluno aluno) async {
    try {
      final atualizado = await _dados.atualizar(aluno);
      alunos = alunos.map((a) => a.id == atualizado.id ? atualizado : a).toList();
      estado = alunos.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
      notifyListeners();
      return true;
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      estado = EstadoCarregamento.erro;
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
      await _dados.remover(id);
      alunos = alunos.where((a) => a.id != id).toList();
      estado = alunos.isEmpty ? EstadoCarregamento.vazio : EstadoCarregamento.sucesso;
      notifyListeners();
    } catch (e) {
      mensagemErro = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }
}
