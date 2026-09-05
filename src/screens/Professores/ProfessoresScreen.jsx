import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import AppLayout from '../../components/AppLayout/AppLayout';
import { EstadoCarregando, EstadoErro, EstadoVazio } from '../../components/EstadoVisual/EstadoVisual';
import * as usuariosService from '../../services/usuariosService';
import * as aulasService from '../../services/aulasService';
import { diaSemanaAtual, normalizarDia, inicial } from '../../utils';
import './ProfessoresScreen.css';

export default function ProfessoresScreen() {
  const [professores, setProfessores] = useState([]);
  const [aulas, setAulas] = useState([]);
  const [estado, setEstado] = useState('carregando');
  const [erro, setErro] = useState(null);
  const [expanded, setExpanded] = useState(null);
  const navigate = useNavigate();

  const carregar = async () => {
    setEstado('carregando');
    try {
      const [profs, aulasData] = await Promise.all([usuariosService.listar(), aulasService.listar()]);
      setProfessores(profs);
      setAulas(aulasData);
      setEstado(profs.length === 0 ? 'vazio' : 'sucesso');
    } catch (e) { setErro(e.message); setEstado('erro'); }
  };

  useEffect(() => { carregar(); }, []);

  const aulasDoProf = (profId) => aulas.filter((a) => a.usuarioId === profId);
  const aulasHojeDoProf = (profId) => {
    const hoje = diaSemanaAtual();
    return aulasDoProf(profId).filter((a) => normalizarDia(a.diaSemana) === normalizarDia(hoje));
  };

  if (estado === 'carregando') return <AppLayout titulo="Professores"><EstadoCarregando mensagem="Carregando professores..." /></AppLayout>;
  if (estado === 'erro') return <AppLayout titulo="Professores"><EstadoErro mensagem={erro} onTentarNovamente={carregar} /></AppLayout>;
  if (estado === 'vazio') return <AppLayout titulo="Professores"><EstadoVazio titulo="Nenhum professor" subtitulo="Cadastre professores no sistema" icone="school" /></AppLayout>;

  return (
    <AppLayout titulo="Professores">
      <div className="profs-list">
        {professores.map((prof, i) => {
          const totalAulas = aulasDoProf(prof.id).length;
          const aulasHoje = aulasHojeDoProf(prof.id);
          const isExpanded = expanded === prof.id;
          return (
            <div key={prof.id} className="prof-card fade-slide-up" style={{ animationDelay: `${i * 40}ms` }}>
              <div className="prof-top" onClick={() => setExpanded(isExpanded ? null : prof.id)}>
                <div className="prof-avatar">{inicial(prof.nome)}</div>
                <div className="prof-info">
                  <span className="prof-nome">{prof.nome}</span>
                  <span className="prof-email">{prof.email}</span>
                </div>
                <div className="prof-stats">
                  <span className="prof-count">{totalAulas} aulas</span>
                  {aulasHoje.length > 0 && <span className="prof-hoje">{aulasHoje.length} hoje</span>}
                </div>
              </div>
              {isExpanded && (
                <div className="prof-aulas">
                  {aulasDoProf(prof.id).length === 0 ? (
                    <p className="prof-sem-aulas">Nenhuma aula atribuída</p>
                  ) : (
                    aulasDoProf(prof.id).map((a) => (
                      <div key={a.id} className="prof-aula-item" onClick={() => navigate(`/aulas/${a.id}`)}>
                        <span className="material-icons-outlined" style={{ fontSize: 18, color: 'var(--color-primary)' }}>event_note</span>
                        <span>{a.nome}</span>
                        <span className="prof-aula-dia">{a.diaSemana} • {a.horarioInicio}</span>
                      </div>
                    ))
                  )}
                </div>
              )}
            </div>
          );
        })}
      </div>
    </AppLayout>
  );
}

