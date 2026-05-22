import 'package:fluire/models/aluno.dart';
import 'package:fluire/models/aula.dart';
import 'package:fluire/models/professor.dart';

class MockDados {
  static final professores = [
    const Professor(id: 'p1', nome: 'Ana Silva'),
    const Professor(id: 'p2', nome: 'Carlos Lima'),
    const Professor(id: 'p3', nome: 'Mariana Costa'),
    const Professor(id: 'p4', nome: 'Roberto Alves'),
  ];

  static final alunos = [
    Aluno(
      id: 'a1',
      nome: 'Julia Ferreira',
      telefone: '(11) 99999-1111',
      email: 'julia@email.com',
      modalidade: 'Mat Pilates',
      presencas: 32,
      faltas: 4,
      ativo: true,
      ultimaAula: '20/05/2026',
    ),
    Aluno(
      id: 'a2',
      nome: 'Carla Santos',
      telefone: '(11) 99999-2222',
      email: 'carla@email.com',
      modalidade: 'Reformer',
      presencas: 28,
      faltas: 6,
      ativo: true,
      ultimaAula: '19/05/2026',
    ),
    Aluno(
      id: 'a3',
      nome: 'Amanda Souza',
      telefone: '(11) 99999-3333',
      email: 'amanda@email.com',
      modalidade: 'Pilates Funcional',
      presencas: 12,
      faltas: 8,
      ativo: false,
      ultimaAula: '10/05/2026',
    ),
    Aluno(
      id: 'a4',
      nome: 'Fernanda Costa',
      telefone: '(11) 99999-4444',
      email: 'fernanda@email.com',
      modalidade: 'Duet Reformer',
      presencas: 45,
      faltas: 2,
      ativo: true,
      ultimaAula: '21/05/2026',
    ),
    Aluno(
      id: 'a5',
      nome: 'Beatriz Lima',
      telefone: '(11) 99999-5555',
      email: 'beatriz@email.com',
      modalidade: 'Mat Pilates',
      presencas: 20,
      faltas: 3,
      ativo: true,
      ultimaAula: '18/05/2026',
    ),
    Aluno(
      id: 'a6',
      nome: 'Priscila Alves',
      telefone: '(11) 99999-6666',
      email: 'priscila@email.com',
      modalidade: 'Yoga Relax',
      presencas: 15,
      faltas: 5,
      ativo: true,
      ultimaAula: '17/05/2026',
    ),
  ];

  static final aulas = [
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

  static const credenciaisMock = {
    'admin@fluire.com': '123456',
    'demo@fluire.com': 'demo123',
  };
}
