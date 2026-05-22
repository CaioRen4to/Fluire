import 'package:fluire/models/usuario.dart';

abstract class AuthRepository {
  Future<Usuario> login(String email, String senha);
  Future<Usuario> cadastrar(String nome, String email, String senha);
  Future<void> logout();
}
