import 'package:flutter/foundation.dart';
import 'package:fluire/util/estado_carregamento.dart';
import 'package:fluire/modelos/usuario.dart';
import 'package:fluire/services/auth_service.dart';

class ProvedorAuth extends ChangeNotifier {
  final AuthService _authService;

  ProvedorAuth(this._authService);

  EstadoCarregamento estado = EstadoCarregamento.inicial;
  Usuario? usuario;
  String? mensagemErro;

  bool get autenticado => usuario != null;

  Future<bool> login(String email, String senha) async {
    estado = EstadoCarregamento.carregando;
    mensagemErro = null;
    notifyListeners();
    try {
      usuario = await _authService.login(email, senha);
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
      usuario = await _authService.cadastrar(
        nome: nome,
        email: email,
        senha: senha,
      );
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

  Future<bool> recuperarSenha(String email) async {
    estado = EstadoCarregamento.carregando;
    mensagemErro = null;
    notifyListeners();
    try {
      await _authService.recuperarSenha(email);
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
    await _authService.logout();
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
