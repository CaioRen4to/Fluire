import api, { extrairErro } from './api';

export async function listar() {
  const response = await api.get('/frequencias');
  const data = response.data;
  if (!Array.isArray(data)) return [];
  return data.filter((item) => item && typeof item === 'object').map(parseFrequencia);
}

export async function listarPorAula(aulaId) {
  const response = await api.get(`/frequencias/aulas/${aulaId}`);
  const data = response.data;
  if (!Array.isArray(data)) return [];
  return data.filter((item) => item && typeof item === 'object').map(parseFrequencia);
}

export async function registrar({ aulaId, alunoId, presente, dataPresenca }) {
  try {
    const response = await api.post('/frequencias', {
      aula_id: aulaId,
      aluno_id: alunoId,
      presente,
      data_presenca: dataPresenca,
    });
    const data = response.data;
    if (data && (data.aula_id || data.id)) {
      return parseFrequencia(data);
    }
    return { aulaId, alunoId, presente, dataPresenca };
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao registrar frequência'));
  }
}

function parseFrequencia(json) {
  // presente vem como boolean do PostgreSQL (true/false), converte para 1/0
  const presente = json.presente === true || json.presente === 1 || json.presente === '1' ? 1 : 0;
  return {
    id: json.id?.toString() || null,
    aulaId: parseInt(json.aula_id, 10) || 0,
    alunoId: parseInt(json.aluno_id, 10) || 0,
    presente,
    dataPresenca: (json.data_presenca || json.dataPresenca || '').toString(),
  };
}
