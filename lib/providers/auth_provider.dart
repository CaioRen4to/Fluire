import 'package:flutter/foundation.dart';
import 'package:fluire/core/estado_carregamento.dart';
import 'package:fluire/models/usuario.dart';
import 'package:fluire/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;

  AuthProvider(this._service);

  EstadoCarregamento estado = EstadoCarregamento.inicial;
  Usuario? usuario;
  String? mensagemErro;

  bool get autenticado => usuario != null;

  Future<bool> login(String email, String senha) async {
    estado = EstadoCarregamento.carregando;
    mensagemErro = null;
    notifyListeners();
    try {
      usuario = await _service.login(email, senha);
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
      usuario = await _service.cadastrar(nome, email, senha);
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
    await _service.logout();
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
