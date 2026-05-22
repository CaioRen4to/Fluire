class RegistrosFrequenciaMock {
  static final Map<String, List<Map<String, dynamic>>> porNomeAula = {
    'Mat Pilates': [
      {'alunoId': 'a1', 'nome': 'Julia Ferreira', 'inicial': 'J', 'status': 'pendente'},
      {'alunoId': 'a2', 'nome': 'Carla Santos', 'inicial': 'C', 'status': 'pendente'},
      {'alunoId': 'a5', 'nome': 'Beatriz Lima', 'inicial': 'B', 'status': 'presente'},
      {'alunoId': 'a4', 'nome': 'Fernanda Costa', 'inicial': 'F', 'status': 'ausente'},
    ],
    'Pilates Funcional': [
      {'alunoId': 'a3', 'nome': 'Amanda Souza', 'inicial': 'A', 'status': 'pendente'},
      {'alunoId': 'a1', 'nome': 'Julia Ferreira', 'inicial': 'J', 'status': 'presente'},
      {'alunoId': 'a6', 'nome': 'Priscila Alves', 'inicial': 'P', 'status': 'pendente'},
    ],
    'Yoga Relax': [
      {'alunoId': 'a6', 'nome': 'Priscila Alves', 'inicial': 'P', 'status': 'presente'},
    ],
  };
}
