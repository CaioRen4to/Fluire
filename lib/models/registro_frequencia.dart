enum StatusPresenca { pendente, presente, ausente }

class RegistroFrequencia {
  final String alunoId;
  final String alunoNome;
  final String inicial;
  StatusPresenca status;

  RegistroFrequencia({
    required this.alunoId,
    required this.alunoNome,
    required this.inicial,
    this.status = StatusPresenca.pendente,
  });
}
