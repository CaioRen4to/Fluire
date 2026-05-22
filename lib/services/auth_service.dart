import 'package:fluire/models/usuario.dart';
import 'package:fluire/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository;

  AuthService(this._repository);

  Future<Usuario> login(String email, String senha) {
    if (email.trim().isEmpty || senha.isEmpty) {
      throw Exception('Preencha e-mail e senha.');
    }
    return _repository.login(email, senha);
  }

  Future<Usuario> cadastrar(String nome, String email, String senha) {
    if (nome.trim().isEmpty) throw Exception('Informe seu nome.');
    if (email.trim().isEmpty) throw Exception('Informe seu e-mail.');
    if (senha.length < 6) throw Exception('A senha deve ter pelo menos 6 caracteres.');
    return _repository.cadastrar(nome, email, senha);
  }

  Future<void> logout() => _repository.logout();
}
