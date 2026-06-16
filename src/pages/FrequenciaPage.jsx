import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import AppLayout from '../components/AppLayout';
import { EstadoCarregando, EstadoErro, EstadoVazio } from '../components/EstadoVisual';
import * as aulasService from '../services/aulasService';
import * as aulaAlunoService from '../services/aulaAlunoService';
import * as frequenciaService from '../services/frequenciaService';
import { hojeISO, diaSemanaAtual, normalizarDia } from '../utils/helpers';
import './FrequenciaPage.css';

export default function FrequenciaPage() {
  const { aulaId } = useParams();
  const navigate = useNavigate();
  const [aulas, setAulas] = useState([]);
  const [aulaSelecionada, setAulaSelecionada] = useState(aulaId || null);
  const [alunosDaAula, setAlunosDaAula] = useState([]);
  const [frequencias, setFrequencias] = useState({});
  const [estado, setEstado] = useState('carregando');
  const [salvando, setSalvando] = useState({});
  const [snack, setSnack] = useState(null);

  const carregar = async () => {
    setEstado('carregando');
    try {
      const aulasData = await aulasService.listar();
      setAulas(aulasData);
      if (aulaId) {
        setAulaSelecionada(aulaId);
        await carregarAlunos(aulaId);
      } else {
        // Auto-select first class of today
        const hoje = diaSemanaAtual();
        const aulaHoje = aulasData.find((a) => normalizarDia(a.diaSemana) === normalizarDia(hoje));
        if (aulaHoje) {
          setAulaSelecionada(aulaHoje.id);
          await carregarAlunos(aulaHoje.id);
        } else {
          setEstado('sucesso');
        }
      }
    } catch (e) { setEstado('erro'); }
  };

  const carregarAlunos = async (id) => {
    try {
      const alunos = await aulaAlunoService.obterAlunosDeUmaAula(parseInt(id));
      setAlunosDaAula(alunos);
      // Load existing freq for today
      const freqs = await frequenciaService.listarPorAula(parseInt(id)).catch(() => []);
      const hoje = hojeISO();
      const map = {};
      for (const f of freqs) {
        if (f.dataPresenca.startsWith(hoje)) {
          map[f.alunoId.toString()] = f.presente;
        }
      }
      setFrequencias(map);
      setEstado('sucesso');
    } catch { setEstado('sucesso'); }
  };

  useEffect(() => { carregar(); }, [aulaId]);

  const handleSelectAula = async (id) => {
    setAulaSelecionada(id);
    await carregarAlunos(id);
  };

  const registrar = async (alunoId, presente) => {
    const key = alunoId.toString();
    setSalvando((p) => ({ ...p, [key]: true }));
    try {
      await frequenciaService.registrar({
        aulaId: parseInt(aulaSelecionada),
        alunoId: parseInt(alunoId),
        presente,
        dataPresenca: hojeISO(),
      });
      setFrequencias((p) => ({ ...p, [key]: presente }));
      setSnack(presente === 1 ? 'Presença registrada ✓' : 'Falta registrada');
      setTimeout(() => setSnack(null), 3000);
    } catch {}
    setSalvando((p) => ({ ...p, [key]: false }));
  };

  if (estado === 'carregando') return <AppLayout titulo="Frequência"><EstadoCarregando mensagem="Carregando..." /></AppLayout>;
  if (estado === 'erro') return <AppLayout titulo="Frequência"><EstadoErro mensagem="Erro ao carregar" onTentarNovamente={carregar} /></AppLayout>;

  return (
    <AppLayout titulo="Frequência">
      <div className="freq-content">
        {/* Seletor de aula */}
        <div className="freq-select-wrap">
          <label className="input-padrao__label">Selecionar Aula</label>
          <select className="aulas-select" value={aulaSelecionada || ''} onChange={(e) => handleSelectAula(e.target.value)}>
            <option value="">— Selecione —</option>
            {aulas.map((a) => <option key={a.id} value={a.id}>{a.nome} ({a.diaSemana})</option>)}
          </select>
        </div>

        {!aulaSelecionada && <EstadoVazio titulo="Selecione uma aula" subtitulo="Escolha a aula para registrar frequência" icone="fact_check" />}

        {aulaSelecionada && alunosDaAula.length === 0 && (
          <EstadoVazio titulo="Nenhum aluno nesta aula" subtitulo="Associe alunos à aula primeiro" icone="person_off" />
        )}

        {aulaSelecionada && alunosDaAula.length > 0 && (
          <div className="freq-alunos">
            <p className="freq-data">Data: {new Date().toLocaleDateString('pt-BR')}</p>
            {alunosDaAula.map((aluno, i) => {
              const id = (aluno.id || aluno.aluno_id)?.toString();
              const nome = aluno.nome || `Aluno #${id}`;
              const status = frequencias[id];
              const isSaving = salvando[id];
              return (
                <div key={id || i} className="freq-aluno-row fade-slide-up" style={{ animationDelay: `${i * 30}ms` }}>
                  <div className="freq-aluno-info">
                    <div className="freq-aluno-avatar">{nome[0]?.toUpperCase() || '?'}</div>
                    <span className="freq-aluno-nome">{nome}</span>
                  </div>
                  <div className="freq-btns">
                    <button
                      className={`freq-btn freq-btn--presente ${status === 1 ? 'freq-btn--active' : ''}`}
                      onClick={() => registrar(id, 1)}
                      disabled={isSaving}
                    >
                      {isSaving && status !== 1 ? '...' : 'P'}
                    </button>
                    <button
                      className={`freq-btn freq-btn--falta ${status === 0 ? 'freq-btn--active' : ''}`}
                      onClick={() => registrar(id, 0)}
                      disabled={isSaving}
                    >
                      {isSaving && status !== 0 ? '...' : 'F'}
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
      {snack && <div className="snackbar">{snack}</div>}
    </AppLayout>
  );
}
