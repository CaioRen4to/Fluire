import 'package:flutter/foundation.dart';
import 'package:fluire/util/estado_carregamento.dart';
import 'package:fluire/modelos/usuario.dart';
import 'package:fluire/dados/dados_auth.dart';

class ProvedorAuth extends ChangeNotifier {
  final DadosAuth _dados;

  ProvedorAuth(this._dados);

  EstadoCarregamento estado = EstadoCarregamento.inicial;
  Usuario? usuario;
  String? mensagemErro;

  bool get autenticado => usuario != null;

  Future<bool> login(String email, String senha) async {
    estado = EstadoCarregamento.carregando;
    mensagemErro = null;
    notifyListeners();
    try {
      final sucesso = await _dados.login(email, senha);
      if (sucesso) {
        usuario = Usuario(id: email, nome: email.split('@')[0], email: email);
        estado = EstadoCarregamento.sucesso;
      } else {
        throw Exception('Email ou senha incorretos.');
      }
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
      final sucesso = await _dados.cadastro(email, senha);
      if (sucesso) {
        usuario = Usuario(id: email, nome: nome, email: email);
        estado = EstadoCarregamento.sucesso;
      }
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
    await _dados.logout();
    usuario = null;
    estado = EstadoCarregamento.inicial;
    notifyListeners();
  }

  void limparErro() {
    mensagemErro = null;
    if (estado == EstadoCarregamento.erro) {
      estado = EstadoCarregamento.inicial;
      notifyListeners();
    }
  }
}
