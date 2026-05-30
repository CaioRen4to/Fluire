import 'package:fluire/modelos/registro_auditoria.dart';
import 'package:fluire/services/alunos_service.dart';
import 'package:fluire/services/aulas_service.dart';

class HistoricoService {
  final AlunosService _alunosService = AlunosService();
  final AulasService _aulasService = AulasService();

  Future<List<RegistroAuditoria>> listarAtividades({int limite = 50}) async {
    final alunos = await _alunosService.listar();
    final aulas = await _aulasService.listar();
    final registros = <RegistroAuditoria>[];

    for (final aluno in alunos) {
      if (aluno.createdAt != null || aluno.createdBy != null) {
        registros.add(
          RegistroAuditoria(
            entidade: TipoEntidadeAuditoria.aluno,
            acao: TipoAcaoAuditoria.criacao,
            titulo: aluno.nome,
            subtitulo: aluno.email.isNotEmpty ? aluno.email : aluno.telefone,
            criadoPor: _nomeUsuario(aluno.createdBy),
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
            criadoPor: _nomeUsuario(aluno.createdBy),
            atualizadoPor: _nomeUsuario(aluno.updatedBy),
            dataCriacao: aluno.createdAt,
            dataAtualizacao: aluno.updatedAt,
          ),
        );
      }
    }

    for (final aula in aulas) {
      if (aula.createdAt != null || aula.createdBy != null) {
        registros.add(
          RegistroAuditoria(
            entidade: TipoEntidadeAuditoria.aula,
            acao: TipoAcaoAuditoria.criacao,
            titulo: aula.nome,
            subtitulo: aula.horario,
            criadoPor: _nomeUsuario(aula.createdBy),
            dataCriacao: aula.createdAt,
          ),
        );
      }

      if (aula.updatedAt != null || aula.updatedBy != null) {
        registros.add(
          RegistroAuditoria(
            entidade: TipoEntidadeAuditoria.aula,
            acao: TipoAcaoAuditoria.atualizacao,
            titulo: aula.nome,
            subtitulo: aula.horario,
            criadoPor: _nomeUsuario(aula.createdBy),
            atualizadoPor: _nomeUsuario(aula.updatedBy),
            dataCriacao: aula.createdAt,
            dataAtualizacao: aula.updatedAt,
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

  String _nomeUsuario(dynamic id) {
    if (id == null) return '—';
    return 'Usuário #$id';
  }
}
