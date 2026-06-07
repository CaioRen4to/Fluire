import 'package:fluire/models/registro_auditoria.dart';
import 'package:fluire/services/alunos_service.dart';
import 'package:fluire/services/aulas_service.dart';
import 'package:fluire/services/usuarios_service.dart';

class HistoricoService {
  final AlunosService _alunosService = AlunosService();
  final AulasService _aulasService = AulasService();
  final UsuariosService _usuariosService = UsuariosService();

  Future<List<RegistroAuditoria>> listarAtividades({int limite = 50}) async {
    // Busca alunos, aulas e usuários em paralelo
    final resultados = await Future.wait([
      _alunosService.listar(),
      _aulasService.listar(),
      _carregarUsuarios(),
    ]);

    final alunos = resultados[0] as List;
    final aulas = resultados[1] as List;
    final mapaUsuarios = resultados[2] as Map<int, String>;

    final registros = <RegistroAuditoria>[];

    for (final aluno in alunos) {
      if (aluno.createdAt != null || aluno.createdBy != null) {
        registros.add(
          RegistroAuditoria(
            entidade: TipoEntidadeAuditoria.aluno,
            acao: TipoAcaoAuditoria.criacao,
            titulo: aluno.nome,
            subtitulo: aluno.email.isNotEmpty ? aluno.email : aluno.telefone,
            criadoPor: _nomeUsuario(aluno.createdBy, mapaUsuarios),
            dataCriacao: aluno.createdAt,
          ),
        );
      }

      if (aluno.updatedAt != null || aluno.updatedBy != null) {
        registros.add(
          RegistroAuditoria(
            entidade: TipoEntidadeAuditoria.aluno,
            acao: TipoAcaoAuditoria.atualizacao,
            titulo: aluno.nome,
            subtitulo: aluno.email.isNotEmpty ? aluno.email : aluno.telefone,
            criadoPor: _nomeUsuario(aluno.createdBy, mapaUsuarios),
            atualizadoPor: _nomeUsuario(aluno.updatedBy, mapaUsuarios),
            dataCriacao: aluno.createdAt,
            dataAtualizacao: aluno.updatedAt,
          ),
        );
      }
    }

    for (final aula in aulas) {
      if (aula.createdAt != null || aula.createdBy != null || aula.id.isNotEmpty) {
        registros.add(
          RegistroAuditoria(
            entidade: TipoEntidadeAuditoria.aula,
            acao: TipoAcaoAuditoria.criacao,
            titulo: aula.nome,
            subtitulo: aula.horario,
            criadoPor: _nomeUsuario(aula.createdBy, mapaUsuarios) ?? 'Não informado',
            dataCriacao: aula.createdAt ?? DateTime.now(),
          ),
        );
      }

      // Se temos indicação de alteração ou se pudermos identificar que houve alteração (updatedBy/updatedAt)
      if (aula.updatedAt != null || aula.updatedBy != null) {
        registros.add(
          RegistroAuditoria(
            entidade: TipoEntidadeAuditoria.aula,
            acao: TipoAcaoAuditoria.atualizacao,
            titulo: aula.nome,
            subtitulo: aula.horario,
            criadoPor: _nomeUsuario(aula.createdBy, mapaUsuarios),
            atualizadoPor: _nomeUsuario(aula.updatedBy, mapaUsuarios) ?? 'Usuário logado',
            dataCriacao: aula.createdAt,
            dataAtualizacao: aula.updatedAt ?? DateTime.now(),
          ),
        );
      }
    }

    registros.sort((a, b) {
      final da = a.dataReferencia ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db = b.dataReferencia ?? DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });

    if (registros.length > limite) {
      return registros.sublist(0, limite);
    }
    return registros;
  }

  /// Carrega a lista de usuários e retorna um mapa ID → Nome.
  /// Em caso de falha, retorna mapa vazio para não quebrar a tela.
  Future<Map<int, String>> _carregarUsuarios() async {
    try {
      final usuarios = await _usuariosService.listar();
      final mapa = <int, String>{};
      for (final usuario in usuarios) {
        final idInt = int.tryParse(usuario.id);
        if (idInt != null && usuario.nome.isNotEmpty) {
          mapa[idInt] = usuario.nome;
        }
      }
      return mapa;
    } catch (_) {
      return <int, String>{};
    }
  }

  /// Resolve o ID de usuário para o nome real.
  /// Retorna null se o ID for nulo (campo não preenchido).
  String? _nomeUsuario(dynamic id, Map<int, String> mapa) {
    if (id == null) return null;
    final idInt = id is int ? id : int.tryParse(id.toString());
    if (idInt == null) return null;
    return mapa[idInt] ?? 'Usuário desconhecido';
  }
}
