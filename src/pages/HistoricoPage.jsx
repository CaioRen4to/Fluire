import { useState, useEffect } from 'react';
import AppLayout from '../components/AppLayout';
import { EstadoCarregando, EstadoErro, EstadoVazio } from '../components/EstadoVisual';
import * as historicoService from '../services/historicoService';
import { formatarData } from '../utils/helpers';
import './HistoricoPage.css';

export default function HistoricoPage() {
  const [registros, setRegistros] = useState([]);
  const [estado, setEstado] = useState('carregando');
  const [erro, setErro] = useState(null);
  const [filtro, setFiltro] = useState('todos');

  const carregar = async () => {
    setEstado('carregando');
    try {
      const data = await historicoService.listarAtividades();
      setRegistros(data);
      setEstado(data.length === 0 ? 'vazio' : 'sucesso');
    } catch (e) { setErro(e.message); setEstado('erro'); }
  };

  useEffect(() => { carregar(); }, []);

  const filtrados = filtro === 'todos' ? registros : registros.filter((r) => r.entidade === filtro);

  if (estado === 'carregando') return <AppLayout titulo="Histórico"><EstadoCarregando mensagem="Carregando histórico..." /></AppLayout>;
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
          <div key={i} className="hist-item fade-slide-up" style={{ animationDelay: `${i * 30}ms` }}>
            <div className={`hist-icon ${r.entidade === 'aluno' ? 'hist-icon--aluno' : 'hist-icon--aula'}`}>
              <span className="material-icons-outlined">{r.entidade === 'aluno' ? 'person' : 'event_note'}</span>
            </div>
            <div className="hist-info">
              <span className="hist-titulo">{r.titulo}</span>
              <span className="hist-sub">{r.subtitulo}</span>
              <span className="hist-meta">
                {r.acao === 'criacao' ? 'Criado' : 'Atualizado'} por {r.acao === 'criacao' ? (r.criadoPor || '—') : (r.atualizadoPor || '—')}
              </span>
            </div>
            <span className="hist-data">{formatarData(r.acao === 'criacao' ? r.dataCriacao : r.dataAtualizacao)}</span>
          </div>
        ))}
      </div>
    </AppLayout>
  );
}
