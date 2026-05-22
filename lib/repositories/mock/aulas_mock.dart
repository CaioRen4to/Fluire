import 'package:fluire/models/aula.dart';

class AulasMock {
  static final List<Aula> lista = [
    Aula(
      id: 'aula1',
      nome: 'Mat Pilates',
      professorId: 'p1',
      professorNome: 'Ana Silva',
      horarioInicio: '08:00',
      horarioFim: '09:00',
      frequencia: 'Segunda, Quarta e Sexta',
      alunoIds: ['a1', 'a2', 'a5', 'a4'],
      status: StatusAula.emAndamento,
      diaSemana: 1,
    ),
    Aula(
      id: 'aula2',
      nome: 'Reformer Avançado',
      professorId: 'p2',
      professorNome: 'Carlos Lima',
      horarioInicio: '09:30',
      horarioFim: '10:30',
      frequencia: 'Terça e Quinta',
      alunoIds: ['a2', 'a4'],
      status: StatusAula.proxima,
      diaSemana: 2,
    ),
    Aula(
      id: 'aula3',
      nome: 'Pilates Funcional',
      professorId: 'p3',
      professorNome: 'Mariana Costa',
      horarioInicio: '11:00',
      horarioFim: '12:00',
      frequencia: 'Diária',
      alunoIds: ['a3', 'a1', 'a6'],
      status: StatusAula.proxima,
      diaSemana: 3,
    ),
    Aula(
      id: 'aula4',
      nome: 'Yoga Relax',
      professorId: 'p3',
      professorNome: 'Mariana Costa',
      horarioInicio: '14:00',
      horarioFim: '15:00',
      frequencia: 'Sábado',
      alunoIds: ['a6'],
      status: StatusAula.proxima,
      diaSemana: 6,
    ),
  ];
}
