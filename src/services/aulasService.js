import api, { extrairErro, getUserId } from './api';

// Helper para converter dia_semana numérico para texto
function converterDiaSemana(diaSemana) {
  if (diaSemana == null) return 'segunda-feira';
  if (typeof diaSemana === 'string') return diaSemana;
  const dias = {
    1: 'segunda-feira', 2: 'terça-feira', 3: 'quarta-feira',
    4: 'quinta-feira', 5: 'sexta-feira', 6: 'sábado', 7: 'domingo',
  };
  return dias[diaSemana] || 'segunda-feira';
}

// Helper para parsear aula do JSON
export function parseAula(json) {
  if (!json || typeof json !== 'object') return null;
  return {
    id: json.id?.toString() || '',
    nome: json.nome || '',
    usuarioId: json.usuario_id?.toString() || '',
    professorId: json.professorId?.toString() || '',
    professorNome: json.professorNome || '',
    horarioInicio: json.horario_inicio?.toString() || '',
    horarioFim: json.horario_fim?.toString() || '',
    frequencia: (json.frequencia || json.frequencias || 'Semanal').toString(),
    alunoIds: Array.isArray(json.alunoIds) ? json.alunoIds.map(String) : [],
    status: json.status ?? 1,
    diaSemana: converterDiaSemana(json.dia_semana || json.diaSemana),
    createdBy: json.created_by ?? null,
    updatedBy: json.updated_by ?? null,
    createdAt: json.created_at || null,
    updatedAt: json.updated_at || null,
  };
}

export async function listar() {
  const response = await api.get('/aulas');
  const data = response.data;
  if (!Array.isArray(data)) return [];
  return data.map(parseAula).filter(Boolean);
}

export async function buscarPorId(id) {
  try {
    const response = await api.get(`/aulas/${id}`);
    return parseAula(response.data);
  } catch (error) {
    if (error.response?.status === 404) return null;
    throw new Error(extrairErro(error, 'Erro ao buscar aula'));
  }
}

export async function criar(aula) {
  try {
    const payload = {
      nome: aula.nome,
      usuario_id: aula.usuarioId,
      horario_inicio: aula.horarioInicio,
      horario_fim: aula.horarioFim,
      frequencia: aula.frequencia,
      dia_semana: aula.diaSemana,
    };
    const userId = getUserId();
    if (userId) payload.usuario_id = userId.toString();

    const response = await api.post('/aulas', payload);
    return { ...aula, id: response.data?.id?.toString() || aula.id };
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao criar aula'));
  }
}

export async function atualizar(aula) {
  try {
    const id = parseInt(aula.id, 10);
    const payload = {
      nome: aula.nome,
      usuario_id: aula.usuarioId,
      horario_inicio: aula.horarioInicio,
      horario_fim: aula.horarioFim,
      frequencia: aula.frequencia,
      dia_semana: aula.diaSemana,
    };
    const userId = getUserId();
    if (userId) payload.usuario_id = userId.toString();

    await api.put(`/aulas/${id}`, payload);
    return aula;
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao atualizar aula'));
  }
}

export async function remover(id) {
  try {
    await api.delete(`/aulas/${id}`);
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao remover aula'));
  }
}
