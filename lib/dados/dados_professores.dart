import 'package:fluire/modelos/professor.dart';
import 'package:fluire/services/usuarios_service.dart';

/// Professores são usuários da tabela `usuarios` (GET /usuarios).
class DadosProfessores {
  final UsuariosService _usuariosService;

  DadosProfessores([UsuariosService? usuariosService])
      : _usuariosService = usuariosService ?? UsuariosService();

  Future<List<Professor>> listar() async {
    final usuarios = await _usuariosService.listar();
    return usuarios.map(Professor.fromUsuario).toList();
  }

  Future<Professor?> buscarPorId(String id) async {
    final professores = await listar();
    try {
      return professores.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}