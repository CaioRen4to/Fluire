import api, { extrairErro, getUserId } from './api';

export async function listar() {
  const response = await api.get('/alunos');
  const data = response.data;
  if (!Array.isArray(data)) return [];
  return data.filter((item) => item && typeof item === 'object');
}

export async function buscarPorId(id) {
  try {
    const response = await api.get(`/alunos/${id}`);
    return response.data;
  } catch (error) {
    if (error.response?.status === 404) return null;
    throw new Error(extrairErro(error, 'Erro ao carregar aluno'));
  }
}

export async function criar(aluno) {
  try {
    const body = {
      nome: aluno.nome,
      email: aluno.email,
      telefone: aluno.telefone,
    };
    const userId = getUserId();
    if (userId) body.usuario_logado_id = userId;

    const response = await api.post('/alunos', body);
    const data = response.data;
    return { ...aluno, id: data?.id?.toString() || aluno.id };
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao criar aluno'));
  }
}

export async function atualizar(aluno) {
  try {
    const id = parseInt(aluno.id, 10);
    const body = {
      id,
      nome: aluno.nome,
      email: aluno.email,
      telefone: aluno.telefone,
      modalidade: aluno.modalidade,
      ativo: aluno.ativo,
      presencas: aluno.presencas,
      faltas: aluno.faltas,
    };
    if (aluno.ultimaAula) body.ultima_aula = aluno.ultimaAula;
    const userId = getUserId();
    if (userId) body.usuario_logado_id = userId;

    const response = await api.put(`/alunos/${id}`, body);
    return response.data && response.data.id ? response.data : aluno;
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao atualizar aluno'));
  }
}

export async function remover(id) {
  try {
    await api.delete(`/alunos/${id}`);
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao remover aluno'));
  }
}

export async function buscarPorNome(nome) {
  try {
    const response = await api.get(`/alunos/nome/${nome}`);
    const data = response.data;
    if (!Array.isArray(data)) return [];
    return data;
  } catch (error) {
    if (error.response?.status === 404) return [];
    throw new Error(extrairErro(error, 'Erro ao buscar alunos'));
  }
}
