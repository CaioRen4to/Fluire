import { useState, useEffect } from 'react';
import AppLayout from '../components/AppLayout';
import { EstadoCarregando, EstadoErro, EstadoVazio } from '../components/EstadoVisual';
import * as historicoService from '../services/historicoService';
import * as usuariosService from '../services/usuariosService';
import './HistoricoPage.css';

function formatarDataAuditoria(dataStr) {
  if (!dataStr) return '—';
  try {
    const data = new Date(dataStr);
    if (isNaN(data.getTime())) return dataStr;
    const dataFormatada = data.toLocaleDateString('pt-BR');
    const horaFormatada = data.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' });
    return `${dataFormatada} às ${horaFormatada}`;
  } catch {
    return dataStr;
  }
}

export default function HistoricoPage() {
  const [registros, setRegistros] = useState([]);
  const [estado, setEstado] = useState('carregando');
  const [erro, setErro] = useState(null);
  const [filtro, setFiltro] = useState('todos');

  const carregar = async () => {
    setEstado('carregando');
    try {
      const [dataHistorico, dataUsuarios] = await Promise.all([
        historicoService.listarAtividades(),
        usuariosService.listar().catch(() => [])
      ]);

      // Frontend Join: O historicoService já tenta cruzar e retornar o nome em r.criadoPor / r.atualizadoPor
      // Caso ele falhe, aplicamos o fallback.
      const historicoComResponsaveis = dataHistorico.map((r) => {
        const nomeOuId = r.acao === 'criacao' ? r.criadoPor : r.atualizadoPor;
        
        let nomeResponsavel = 'Usuário do Sistema';
        
        if (nomeOuId && nomeOuId !== 'Usuário desconhecido' && nomeOuId !== 'Não informado') {
          // O historicoService já fez o join ou enviou um nome válido
          nomeResponsavel = nomeOuId;
        } else if (r.usuarioId) {
           // Fallback extra caso tenha o ID do professor associado (ex: na aula)
           const u = dataUsuarios.find(user => String(user.id) === String(r.usuarioId));
           if (u && u.nome) nomeResponsavel = u.nome;
        }

        return {
          ...r,
          nomeResponsavel
        };
      });

      setRegistros(historicoComResponsaveis);
      setEstado(historicoComResponsaveis.length === 0 ? 'vazio' : 'sucesso');
    } catch (e) { 
      setErro(e.message); 
      setEstado('erro'); 
    }
  };

  useEffect(() => { carregar(); }, []);

  const filtrados = filtro === 'todos' ? registros : registros.filter((r) => r.entidade === filtro);

  if (estado === 'carregando') return <AppLayout titulo="Histórico"><EstadoCarregando mensagem="Carregando auditoria..." /></AppLayout>;
  if (estado === 'erro') return <AppLayout titulo="Histórico"><EstadoErro mensagem={erro} onTentarNovamente={carregar} /></AppLayout>;
  if (estado === 'vazio') return <AppLayout titulo="Histórico"><EstadoVazio titulo="Nenhum registro" subtitulo="O histórico aparecerá aqui" icone="history" /></AppLayout>;

  return (
    <AppLayout titulo="Histórico">
      <div className="hist-filters">
        {['todos', 'aluno', 'aula'].map((f) => (
          <button key={f} className={`hist-filter ${filtro === f ? 'hist-filter--active' : ''}`} onClick={() => setFiltro(f)}>
            {f === 'todos' ? 'Todos' : f === 'aluno' ? 'Alunos' : 'Aulas'}
          </button>
        ))}
      </div>
      <div className="hist-list">
        {filtrados.map((r, i) => (
          <div key={i} className="hist-item fade-slide-up" style={{ animationDelay: `${(i % 15) * 30}ms` }}>
            
            <div className={`hist-icon ${r.acao === 'criacao' ? 'hist-icon--criacao' : 'hist-icon--atualizacao'}`}>
              <span className="material-icons-outlined">
                {r.acao === 'criacao' ? 'add_circle_outline' : 'edit_note'}
              </span>
            </div>
            
            <div className="hist-content">
              <div className="hist-header">
                <span className="hist-title">
                  {r.entidade === 'aluno' ? 'Aluno' : 'Aula'} {r.acao === 'criacao' ? 'Criado(a)' : 'Atualizado(a)'}
                </span>
                <span className="hist-date">{formatarDataAuditoria(r.acao === 'criacao' ? r.dataCriacao : r.dataAtualizacao)}</span>
              </div>
              
              <div className="hist-body">
                <span className="hist-subject">{r.titulo} {r.subtitulo ? `- ${r.subtitulo}` : ''}</span>
              </div>
              
              <div className="hist-footer">
                <span className="material-icons-outlined hist-user-icon">account_circle</span>
                <span className="hist-user-name">Por: {r.nomeResponsavel}</span>
              </div>
            </div>
            
          </div>
        ))}
      </div>
    </AppLayout>
  );
}
