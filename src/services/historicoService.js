import * as alunosService from './alunosService';
import * as aulasService from './aulasService';
import * as usuariosService from './usuariosService';

export async function listarAtividades(limite = 50) {
  const [alunos, aulas, mapaUsuarios] = await Promise.all([
    alunosService.listar(),
    aulasService.listar(),
    carregarUsuarios(),
  ]);

  const registros = [];

  for (const aluno of alunos) {
    if (aluno.created_at || aluno.created_by) {
      registros.push({
        entidade: 'aluno',
        acao: 'criacao',
        titulo: aluno.nome,
        subtitulo: aluno.email || aluno.telefone || '',
        criadoPor: nomeUsuario(aluno.created_by, mapaUsuarios),
        dataCriacao: parseData(aluno.created_at),
      });
    }
    if (aluno.updated_at || aluno.updated_by) {
      registros.push({
        entidade: 'aluno',
        acao: 'atualizacao',
        titulo: aluno.nome,
        subtitulo: aluno.email || aluno.telefone || '',
        criadoPor: nomeUsuario(aluno.created_by, mapaUsuarios),
        atualizadoPor: nomeUsuario(aluno.updated_by, mapaUsuarios),
        dataCriacao: parseData(aluno.created_at),
        dataAtualizacao: parseData(aluno.updated_at),
      });
    }
  }

  for (const aula of aulas) {
    if (aula.createdAt || aula.createdBy || aula.id) {
      registros.push({
        entidade: 'aula',
        acao: 'criacao',
        titulo: aula.nome,
        subtitulo: `${aula.horarioInicio} - ${aula.horarioFim}`,
        criadoPor: nomeUsuario(aula.createdBy, mapaUsuarios) || 'Não informado',
        dataCriacao: parseData(aula.createdAt) || new Date(),
      });
    }
    if (aula.updatedAt || aula.updatedBy) {
      registros.push({
        entidade: 'aula',
        acao: 'atualizacao',
        titulo: aula.nome,
        subtitulo: `${aula.horarioInicio} - ${aula.horarioFim}`,
        criadoPor: nomeUsuario(aula.createdBy, mapaUsuarios),
        atualizadoPor: nomeUsuario(aula.updatedBy, mapaUsuarios) || 'Usuário logado',
        dataCriacao: parseData(aula.createdAt),
        dataAtualizacao: parseData(aula.updatedAt) || new Date(),
      });
    }
  }

  registros.sort((a, b) => {
    const da = dataReferencia(a) || new Date(0);
    const db = dataReferencia(b) || new Date(0);
    return db - da;
  });

  return registros.slice(0, limite);
}

function dataReferencia(registro) {
  return registro.acao === 'criacao' ? registro.dataCriacao : registro.dataAtualizacao;
}

async function carregarUsuarios() {
  try {
    const usuarios = await usuariosService.listar();
    const mapa = {};
    for (const u of usuarios) {
      const id = parseInt(u.id, 10);
      if (!isNaN(id) && u.nome) mapa[id] = u.nome;
    }
    return mapa;
  } catch {
    return {};
  }
}

function nomeUsuario(id, mapa) {
  if (id == null) return null;
  const idInt = parseInt(id, 10);
  if (isNaN(idInt)) return null;
  return mapa[idInt] || 'Usuário desconhecido';
}

function parseData(value) {
  if (!value) return null;
  if (value instanceof Date) return value;
  const d = new Date(value);
  return isNaN(d.getTime()) ? null : d;
}

export function formatarData(data) {
  if (!data) return '—';
  const d = data instanceof Date ? data : new Date(data);
  if (isNaN(d.getTime())) return '—';
  const dia = String(d.getDate()).padStart(2, '0');
  const mes = String(d.getMonth() + 1).padStart(2, '0');
  const ano = d.getFullYear();
  const hora = String(d.getHours()).padStart(2, '0');
  const min = String(d.getMinutes()).padStart(2, '0');
  return `${dia}/${mes}/${ano} às ${hora}:${min}`;
}
