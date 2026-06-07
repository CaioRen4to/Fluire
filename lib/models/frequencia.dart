class Frequencia {
  final String? id;
  final int aulaId;
  final int alunoId;
  final int presente;
  final String dataPresenca;

  Frequencia({
    this.id,
    required this.aulaId,
    required this.alunoId,
    required this.presente,
    required this.dataPresenca,
  });

  factory Frequencia.fromJson(Map<String, dynamic> json) {
    return Frequencia(
      id: json['id']?.toString(),
      aulaId: int.tryParse(json['aula_id']?.toString() ?? '') ?? 0,
      alunoId: int.tryParse(json['aluno_id']?.toString() ?? '') ?? 0,
      presente: int.tryParse(json['presente']?.toString() ?? '') ?? 0,
      dataPresenca: json['data_presenca']?.toString() ?? json['dataPresenca']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'aula_id': aulaId,
      'aluno_id': alunoId,
      'presente': presente,
      'data_presenca': dataPresenca,
    };
  }
}
