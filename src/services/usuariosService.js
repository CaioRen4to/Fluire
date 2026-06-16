import api, { extrairErro } from './api';

export async function listar() {
  const response = await api.get('/usuarios');
  const data = response.data;
  if (!Array.isArray(data)) return [];
  return data
    .filter((item) => item && typeof item === 'object')
    .map((item) => ({
      id: item.id?.toString() || '',
      nome: (item.nome || item.name || '').toString(),
      email: (item.email || '').toString(),
      tipoUsuario: item.tipo_usuario?.toString() || null,
    }));
}

export async function buscarPorNome(nome) {
  try {
    const response = await api.get(`/usuarios/${nome}`);
    const data = response.data;
    if (data && typeof data === 'object') {
      return {
        id: data.id?.toString() || '',
        nome: (data.nome || data.name || '').toString(),
        email: (data.email || '').toString(),
        tipoUsuario: data.tipo_usuario?.toString() || null,
      };
    }
    return null;
  } catch (error) {
    if (error.response?.status === 404) return null;
    throw new Error(extrairErro(error, 'Erro ao buscar usuário'));
  }
}

export async function atualizar(usuario) {
  try {
    const id = parseInt(usuario.id, 10);
    await api.put(`/usuarios/${id}`, {
      id: usuario.id,
      nome: usuario.nome,
      email: usuario.email,
      ...(usuario.tipoUsuario && { tipo_usuario: usuario.tipoUsuario }),
    });
    return usuario;
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao atualizar usuário'));
  }
}

export async function remover(id) {
  try {
    await api.delete(`/usuarios/${id}`);
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao remover usuário'));
  }
}
