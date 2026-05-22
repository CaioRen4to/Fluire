import 'package:fluire/models/usuario.dart';
import 'package:fluire/repositories/auth_repository.dart';
import 'package:fluire/repositories/mock/usuarios_mock.dart';

class RepositorioAuthMock implements AuthRepository {
  Usuario? _usuarioAtual;

  Future<void> _aguardar() => Future.delayed(const Duration(milliseconds: 600));

  @override
  Future<Usuario> login(String email, String senha) async {
    await _aguardar();
    final emailNorm = email.trim().toLowerCase();
    final senhaEsperada = UsuariosMock.credenciais[emailNorm];
    if (senhaEsperada == null || senhaEsperada != senha) {
      throw Exception('E-mail ou senha inválidos.');
    }
    _usuarioAtual = Usuario(
      id: 'u1',
      nome: emailNorm.split('@').first,
      email: emailNorm,
    );
    return _usuarioAtual!;
  }

  @override
  Future<Usuario> cadastrar(String nome, String email, String senha) async {
    await _aguardar();
    if (senha.length < 6) {
      throw Exception('A senha deve ter pelo menos 6 caracteres.');
    }
    _usuarioAtual = Usuario(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      nome: nome.trim(),
      email: email.trim().toLowerCase(),
    );
    return _usuarioAtual!;
  }

  @override
  Future<void> logout() async {
    await _aguardar();
    _usuarioAtual = null;
  }
}
