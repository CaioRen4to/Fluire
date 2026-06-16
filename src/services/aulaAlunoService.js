import api, { extrairErro } from './api';

export async function listar() {
  const response = await api.get('/aula-alunos');
  const data = response.data;
  let list = [];
  if (data && typeof data === 'object' && !Array.isArray(data)) {
    list = data.dados || data.data || [];
  } else if (Array.isArray(data)) {
    list = data;
  }
  return list.filter((item) => item && typeof item === 'object').map((item) => ({
    id: item.id?.toString() || null,
    aulaId: parseInt(item.aula_id, 10) || 0,
    alunoId: parseInt(item.aluno_id, 10) || 0,
  }));
}

export async function associar(aulaId, alunoId) {
  try {
    const response = await api.post('/aula-alunos', {
      aula_id: aulaId,
      aluno_id: alunoId,
    });
    return response.data;
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao associar aluno à aula'));
  }
}

export async function remover(aulaId, alunoId) {
  try {
    await api.delete('/aula-alunos', {
      data: { aula_id: aulaId, aluno_id: alunoId },
    });
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao remover associação'));
  }
}

export async function obterAlunosDeUmaAula(aulaId) {
  const response = await api.get(`/aulas/${aulaId}/alunos`);
  const data = response.data;
  if (data && typeof data === 'object' && !Array.isArray(data)) {
    const list = data.dados || data.data;
    if (Array.isArray(list)) return list;
  }
  if (Array.isArray(data)) return data;
  return [];
}

export async function obterAulasDeUmAluno(alunoId) {
  const response = await api.get(`/alunos/${alunoId}/aulas`);
  const data = response.data;
  if (data && typeof data === 'object' && !Array.isArray(data)) {
    const list = data.dados || data.data;
    if (Array.isArray(list)) return list;
  }
  if (Array.isArray(data)) return data;
  return [];
}
