import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import AppLayout from '../../components/AppLayout/AppLayout';
import { EstadoCarregando, EstadoErro, EstadoVazio } from '../../components/EstadoVisual/EstadoVisual';
import * as dashboardService from '../../services/dashboardService';
import * as aulasService from '../../services/aulasService';
import * as aulaAlunoService from '../../services/aulaAlunoService';
import { mesAnoAtual } from '../../utils/formatDate';
import { normalizarDia, isHorarioEmAndamento } from '../../utils/formatters';
import { DIAS_SEMANA, DIAS_SIGLAS, DIAS_NOMES } from '../../constants/diasSemana';
import './DashboardScreen.css';

export default function DashboardScreen() {
  const [estado, setEstado] = useState('carregando');
  const [dashboard, setDashboard] = useState(null);
  const [aulas, setAulas] = useState([]);
  const [erro, setErro] = useState(null);
  const [selectedDay, setSelectedDay] = useState(new Date().getDay() === 0 ? 6 : new Date().getDay() - 1);
  const navigate = useNavigate();

  const carregar = async () => {
    setEstado('carregando');
    try {
      const [dashData, aulasData, assocData] = await Promise.all([
        dashboardService.buscarDashboard(),
        aulasService.listar(),
        aulaAlunoService.listar().catch(() => []),
      ]);
      const mapAssoc = {};
      for (const a of assocData) {
        const key = a.aulaId.toString();
        if (!mapAssoc[key]) mapAssoc[key] = [];
        mapAssoc[key].push(a.alunoId.toString());
      }
      const aulasComAlunos = aulasData.map((aula) => ({ ...aula, alunoIds: mapAssoc[aula.id] || aula.alunoIds || [] }));
      setDashboard(dashData);
      setAulas(aulasComAlunos);
      setEstado('sucesso');
    } catch (e) {
      setErro(e.message);
      setEstado('erro');
    }
  };

  useEffect(() => { carregar(); }, []);

  const diaSemanaHoje = () => { const dow = new Date().getDay(); return DIAS_SEMANA[dow === 0 ? 7 : dow]; };
  const aulasHoje = aulas.filter((a) => normalizarDia(a.diaSemana) === normalizarDia(diaSemanaHoje()));
  const aulasHojeCount = aulasHoje.length;
  const emAndamento = aulasHoje.filter((a) => isHorarioEmAndamento(a.horarioInicio, a.horarioFim)).length;

  const todayClassesReal = aulasHoje
    .sort((a, b) => a.horarioInicio.localeCompare(b.horarioInicio))
    .map((a) => ({
      id: a.id,
      title: a.nome,
      teacher: a.professorNome || `Professor #${a.usuarioId}`,
      time: `${a.horarioInicio} - ${a.horarioFim}`,
      students: `${a.alunoIds.length} alunos`,
      status: isHorarioEmAndamento(a.horarioInicio, a.horarioFim) ? 'andamento' : 'ativa',
    }));

  // Frequência semanal recebida limpamente do dashboardService
  const frequenciaSemana = (() => {
    if (!dashboard) return [];
    return (dashboard.weeklyFrequency || []).map((item, i) => {
      const presencas = item.count || 0;
      const total = dashboard.totalAlunos || 0;
      const pct = total === 0 ? 0 : Math.round((presencas / total) * 100);
      return { 
        day: item.day, 
        fullName: DIAS_NOMES[i] || item.day, 
        value: item.value, 
        presencas, 
        total, 
        percentual: pct 
      };
    });
  })();

  const statusColor = (status) => {
    if (status === 'ativa') return 'var(--color-sucesso)';
    if (status === 'andamento') return 'var(--color-em-andamento)';
    if (status === 'lotada') return 'var(--color-lotado)';
    return 'var(--color-primary)';
  };

  if (estado === 'carregando') return <AppLayout titulo="Dashboard"><EstadoCarregando mensagem="Carregando dashboard..." /></AppLayout>;
  if (estado === 'erro') return <AppLayout titulo="Dashboard"><EstadoErro mensagem={erro} onTentarNovamente={carregar} /></AppLayout>;
  if (!dashboard) return <AppLayout titulo="Dashboard"><EstadoVazio titulo="Nenhum dado encontrado." subtitulo="Tente recarregar." icone="dashboard" onAcao={carregar} textoAcao="Recarregar" /></AppLayout>;

  return (
    <AppLayout titulo="Dashboard">
      <div className="dash-content">
        {/* Cards Estatísticos */}
        <div className="dash-cards">
          <div className="dash-stat-card">
            <div className="dash-stat-info"><span className="dash-stat-label">Total de Alunos</span><span className="dash-stat-value">{dashboard.totalAlunos}</span></div>
            <div className="dash-stat-icon" style={{ background: 'rgba(236,163,29,0.12)' }}><span className="material-icons" style={{ color: 'var(--color-primary)' }}>people_outline</span></div>
          </div>
          <div className="dash-stat-card">
            <div className="dash-stat-info"><span className="dash-stat-label">Aulas Hoje</span><span className="dash-stat-value">{aulasHojeCount}</span></div>
            <div className="dash-stat-icon" style={{ background: 'rgba(109,184,154,0.12)' }}><span className="material-icons" style={{ color: 'var(--color-sucesso)' }}>calendar_today</span></div>
          </div>
          <div className="dash-stat-card">
            <div className="dash-stat-info"><span className="dash-stat-label">Em Andamento</span><span className="dash-stat-value">{emAndamento}</span></div>
            <div className="dash-stat-icon" style={{ background: 'rgba(232,197,122,0.12)' }}><span className="material-icons" style={{ color: 'var(--color-alerta)' }}>play_arrow</span></div>
          </div>
          <div className="dash-stat-card">
            <div className="dash-stat-info"><span className="dash-stat-label">Freq. Média</span><span className="dash-stat-value">{dashboard.frequenciaMedia}%</span></div>
            <div className="dash-stat-icon" style={{ background: 'rgba(236,163,29,0.12)' }}><span className="material-icons" style={{ color: 'var(--color-primary)' }}>trending_up</span></div>
          </div>
        </div>

        {/* Gráfico Frequência Semanal */}
        <div className="dash-chart-card">
          <div className="dash-chart-header">
            <span className="dash-chart-title">Frequência de Aulas (Weekly)</span>
            <span className="dash-chart-date">{mesAnoAtual()}</span>
          </div>
          <div className="dash-chart-bars">
            {frequenciaSemana.map((item, i) => (
              <div key={i} className="dash-bar-col" onClick={() => setSelectedDay(i)}>
                <div className={`dash-bar ${i === selectedDay ? 'dash-bar--active' : ''}`} style={{ height: `${Math.max(item.value, 8)}px` }} />
                <span className="dash-bar-label">{item.day}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Aulas de Hoje */}
        <div className="dash-section-header">
          <span className="dash-section-title">Aulas de Hoje</span>
          <button className="dash-section-link" onClick={() => navigate('/aulas')}>Ver todas</button>
        </div>
        {todayClassesReal.length === 0 ? (
          <p style={{ color: 'var(--color-text-secondary)', textAlign: 'center', padding: 'var(--sp-xl)' }}>Nenhuma aula hoje</p>
        ) : (
          todayClassesReal.map((item) => (
            <div key={item.id} className="dash-class-card" onClick={() => navigate(`/aulas/${item.id}`)}>
              <div className="dash-class-icon" style={{ background: `${statusColor(item.status)}1F` }}>
                <span className="material-icons" style={{ color: statusColor(item.status) }}>access_time</span>
              </div>
              <div className="dash-class-info">
                <span className="dash-class-name">{item.title}</span>
                <span className="dash-class-meta">{item.teacher} • {item.time}</span>
              </div>
              <div className="dash-class-right">
                <span className="dash-class-students">{item.students}</span>
                <div className="dash-class-dot" style={{ background: statusColor(item.status) }} />
              </div>
            </div>
          ))
        )}

        {/* Ações Rápidas */}
        <span className="dash-section-title" style={{ marginTop: 'var(--sp-lg)' }}>Ações Rápidas</span>
        <div className="dash-quick-actions">
          <div className="dash-quick-card" onClick={() => navigate('/frequencia')}>
            <div className="dash-quick-icon"><span className="material-icons">analytics</span></div>
            <span className="dash-quick-label">Frequência</span>
          </div>
          <div className="dash-quick-card" onClick={() => navigate('/alunos')}>
            <div className="dash-quick-icon"><span className="material-icons">groups</span></div>
            <span className="dash-quick-label">Alunos</span>
          </div>
          <div className="dash-quick-card" onClick={() => navigate('/aulas')}>
            <div className="dash-quick-icon"><span className="material-icons">event_note</span></div>
            <span className="dash-quick-label">Aulas</span>
          </div>
        </div>
      </div>
    </AppLayout>
  );
}

