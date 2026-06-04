class AulaAluno {
  final String? id;
  final int aulaId;
  final int alunoId;

  AulaAluno({
    this.id,
    required this.aulaId,
    required this.alunoId,
  });

  factory AulaAluno.fromJson(Map<String, dynamic> json) {
    return AulaAluno(
      id: json['id']?.toString(),
      aulaId: int.tryParse(json['aula_id']?.toString() ?? '') ?? 0,
      alunoId: int.tryParse(json['aluno_id']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'aula_id': aulaId,
      'aluno_id': alunoId,
    };
  }
}
