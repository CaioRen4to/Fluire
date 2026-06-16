import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import AppLayout from '../components/AppLayout';
import { EstadoCarregando, EstadoErro } from '../components/EstadoVisual';
import BotaoPrimario, { BotaoTexto } from '../components/BotaoPrimario';
import * as aulasService from '../services/aulasService';
import * as aulaAlunoService from '../services/aulaAlunoService';
import './DetalheAulaPage.css';

export default function DetalheAulaPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [aula, setAula] = useState(null);
  const [alunosDaAula, setAlunosDaAula] = useState([]);
  const [estado, setEstado] = useState('carregando');
  const [erro, setErro] = useState(null);

  const carregar = async () => {
    setEstado('carregando');
    try {
      const data = await aulasService.buscarPorId(id);
      if (!data) { setEstado('erro'); setErro('Aula não encontrada'); return; }
      setAula(data);
      try { const al = await aulaAlunoService.obterAlunosDeUmaAula(parseInt(id)); setAlunosDaAula(al); } catch {}
      setEstado('sucesso');
    } catch (e) { setErro(e.message); setEstado('erro'); }
  };

  useEffect(() => { carregar(); }, [id]);

  const handleExcluir = async () => {
    if (!window.confirm('Tem certeza que deseja excluir esta aula?')) return;
    try { await aulasService.remover(id); navigate('/aulas', { replace: true }); } catch {}
  };

  if (estado === 'carregando') return <AppLayout titulo="Detalhes da Aula"><EstadoCarregando /></AppLayout>;
  if (estado === 'erro') return <AppLayout titulo="Detalhes da Aula"><EstadoErro mensagem={erro} onTentarNovamente={carregar} /></AppLayout>;

  return (
    <AppLayout titulo="Detalhes da Aula">
      <div className="detalhe-aula fade-slide-up">
        <div className="detalhe-aula__card">
          <div className="detalhe-aula__icon"><span className="material-icons">event_note</span></div>
          <h2>{aula.nome}</h2>
          <span className="detalhe-aula__sub">{aula.diaSemana}</span>
        </div>
        <div className="detalhe-aula__info">
          <h3>Informações</h3>
          <div className="detalhe-aula__row"><span className="material-icons-outlined">schedule</span><div><small>Horário</small><span>{aula.horarioInicio} - {aula.horarioFim}</span></div></div>
          <div className="detalhe-aula__row"><span className="material-icons-outlined">repeat</span><div><small>Frequência</small><span>{aula.frequencia}</span></div></div>
          <div className="detalhe-aula__row"><span className="material-icons-outlined">person</span><div><small>Professor</small><span>{aula.professorNome || `Professor #${aula.usuarioId}`}</span></div></div>
        </div>
        {alunosDaAula.length > 0 && (
          <div className="detalhe-aula__info">
            <h3>Alunos ({alunosDaAula.length})</h3>
            {alunosDaAula.map((a, i) => (
              <div key={i} className="detalhe-aula__row" onClick={() => navigate(`/alunos/${a.id || a.aluno_id}`)} style={{ cursor: 'pointer' }}>
                <span className="material-icons-outlined">person</span>
                <div><span>{a.nome || `Aluno #${a.aluno_id || a.id}`}</span></div>
              </div>
            ))}
          </div>
        )}
        <div className="detalhe-aula__actions">
          <BotaoPrimario texto="Frequência" icone="fact_check" onClick={() => navigate(`/frequencia/${id}`)} />
          <BotaoTexto texto="Excluir aula" cor="erro" onClick={handleExcluir} />
        </div>
      </div>
    </AppLayout>
  );
}
