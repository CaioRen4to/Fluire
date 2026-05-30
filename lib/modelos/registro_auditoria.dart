enum TipoEntidadeAuditoria { aluno, aula }

enum TipoAcaoAuditoria { criacao, atualizacao }

class RegistroAuditoria {
  final TipoEntidadeAuditoria entidade;
  final TipoAcaoAuditoria acao;
  final String titulo;
  final String subtitulo;
  final String? criadoPor;
  final String? atualizadoPor;
  final DateTime? dataCriacao;
  final DateTime? dataAtualizacao;

  const RegistroAuditoria({
    required this.entidade,
    required this.acao,
    required this.titulo,
    required this.subtitulo,
    this.criadoPor,
    this.atualizadoPor,
    this.dataCriacao,
    this.dataAtualizacao,
  });

  DateTime? get dataReferencia =>
      acao == TipoAcaoAuditoria.criacao ? dataCriacao : dataAtualizacao;

  String get rotuloAcao =>
      acao == TipoAcaoAuditoria.criacao ? 'Criado' : 'Atualizado';

  String get rotuloEntidade =>
      entidade == TipoEntidadeAuditoria.aluno ? 'Aluno' : 'Aula';

  String get usuarioReferencia {
    if (acao == TipoAcaoAuditoria.criacao) {
      return criadoPor ?? '—';
    }
    return atualizadoPor ?? '—';
  }

  String formatarData(DateTime? data) {
    if (data == null) return '—';
    final d = data.day.toString().padLeft(2, '0');
    final m = data.month.toString().padLeft(2, '0');
    final y = data.year;
    final h = data.hour.toString().padLeft(2, '0');
    final min = data.minute.toString().padLeft(2, '0');
    return '$d/$m/$y às $h:$min';
  }
}
