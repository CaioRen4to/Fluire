import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import AppLayout from '../../components/AppLayout/AppLayout';
import { EstadoCarregando, EstadoErro, EstadoVazio } from '../../components/EstadoVisual/EstadoVisual';
import BotaoPrimario, { BotaoOutline } from '../../components/BotaoPrimario/BotaoPrimario';
import * as aulasService from '../../services/aulasService';
import * as aulaAlunoService from '../../services/aulaAlunoService';
import * as frequenciaService from '../../services/frequenciaService';
import * as usuariosService from '../../services/usuariosService';
import api from '../../services/api';
import { hojeISO, diaSemanaAtual, normalizarDia } from '../../utils';
import './FrequenciaScreen.css';

export default function FrequenciaScreen() {
  const { aulaId } = useParams();
  const navigate = useNavigate();
  const [aulas, setAulas] = useState([]);
  const [aulaSelecionada, setAulaSelecionada] = useState(aulaId || null);
  const [alunosDaAula, setAlunosDaAula] = useState([]);
  const [frequencias, setFrequencias] = useState({}); // Frequência baseline carregada do banco
  const [frequenciasTemporarias, setFrequenciasTemporarias] = useState({}); // Frequência em alteração no lote (Totem)
  const [frequenciaDbIds, setFrequenciaDbIds] = useState({}); // Mapeia alunoId para ID do registro de frequência
  const [professores, setProfessores] = useState([]); // Lista de professores (usuários)
  const [estado, setEstado] = useState('carregando');
  const [salvandoGeral, setSalvandoGeral] = useState(false);
  const [snack, setSnack] = useState(null);

  const carregar = async () => {
    setEstado('carregando');
    try {
      const [aulasData, usersData] = await Promise.all([
        aulasService.listar(),
        usuariosService.listar().catch(() => [])
      ]);
      setAulas(aulasData);
      setProfessores(usersData);
      if (aulaId) {
        setAulaSelecionada(aulaId);
        await carregarAlunos(aulaId);
      } else {
        // Auto-seleciona a primeira aula de hoje
        const hoje = diaSemanaAtual();
        const aulaHoje = aulasData.find((a) => normalizarDia(a.diaSemana) === normalizarDia(hoje));
        if (aulaHoje) {
          setAulaSelecionada(aulaHoje.id);
          await carregarAlunos(aulaHoje.id);
        } else {
          setEstado('sucesso');
        }
      }
    } catch (e) {
      setEstado('erro');
    }
  };

  const carregarAlunos = async (id) => {
    try {
      const idAulaInt = parseInt(id, 10);
      if (isNaN(idAulaInt)) return;

      const alunos = await aulaAlunoService.obterAlunosDeUmaAula(idAulaInt);
      setAlunosDaAula(alunos);

      // Carrega frequência existente (o backend suporta apenas 1 registro por aluno/aula)
      const freqs = await frequenciaService.listarPorAula(idAulaInt).catch(() => []);
      const map = {};
      const dbIdsMap = {};
      for (const f of freqs) {
        // Ignora a data para evitar conflito de POST, pois o banco não permite duplicatas
        map[f.alunoId.toString()] = f.presente;
        dbIdsMap[f.alunoId.toString()] = f.id;
      }
      setFrequencias(map);
      setFrequenciasTemporarias({ ...map });
      setFrequenciaDbIds(dbIdsMap);
      setEstado('sucesso');
    } catch {
      setEstado('sucesso');
    }
  };

  useEffect(() => {
    carregar();
  }, [aulaId]);

  // Efeito para gerenciar auto-limpeza do snackbar/toast de forma limpa
  useEffect(() => {
    if (snack) {
      const t = setTimeout(() => setSnack(null), 2500);
      return () => clearTimeout(t);
    }
  }, [snack]);

  const handleSelectAula = async (id) => {
    setAulaSelecionada(id);
    if (id) {
      await carregarAlunos(id);
    } else {
      setAlunosDaAula([]);
      setFrequencias({});
      setFrequenciasTemporarias({});
    }
  };

  // Marca status localmente no lote (sem fazer requisição imediata)
  const marcarFrequenciaLocal = (alunoId, presente) => {
    const key = alunoId.toString();
    setFrequenciasTemporarias((prev) => ({
      ...prev,
      [key]: presente
    }));
  };

  // Reseta as marcações do totem de volta para as que estão salvas no banco
  const resetarFrequenciaGeral = () => {
    setFrequenciasTemporarias({ ...frequencias });
    setSnack('Marcações redefinidas ✓');
  };

  // Salva toda a frequência do lote de uma vez (PUT/POST no backend em lote)
  const salvarFrequenciaGeral = async () => {
    const idAulaInt = parseInt(aulaSelecionada, 10);
    if (isNaN(idAulaInt)) return;

    setSalvandoGeral(true);
    try {
      const registros = [];
      // Passa por todos os alunos marcados no lote
      for (const aluno of alunosDaAula) {
        const idAlunoInt = parseInt(aluno.aluno_id || aluno.id, 10);
        const key = idAlunoInt.toString();
        const presente = frequenciasTemporarias[key];
        const originalPresente = frequencias[key];
        const dbId = frequenciaDbIds[key];

        if (presente !== undefined && presente !== null) {
          if (dbId) {
            // Sempre envia PUT se já existe no banco, mesmo que o status não tenha mudado visualmente
            // Isso garante que qualquer metadado (ex: updated_at) seja atualizado no banco
            registros.push(
              api.put(`/frequencias/${dbId}`, {
                aula_id: idAulaInt,
                aluno_id: idAlunoInt,
                presente,
              })
            );
          } else {
            // Não existe no banco, envia POST para registrar
            registros.push(
              frequenciaService.registrar({
                aulaId: idAulaInt,
                alunoId: idAlunoInt,
                presente,
                dataPresenca: hojeISO(),
              })
            );
          }
        }
      }

      // Envia as requisições em lote/paralelo
      if (registros.length > 0) {
        await Promise.all(registros);
      }

      // Recarrega do banco para sincronizar os dados e obter os IDs corretos dos registros inseridos
      await carregarAlunos(aulaSelecionada);
      setSnack('Frequência salva com sucesso! ✓');
    } catch (err) {
      console.error('Erro ao salvar frequência geral:', err);
      setSnack('Erro ao salvar frequência.');
    } finally {
      setSalvandoGeral(false);
    }
  };

  if (estado === 'carregando') {
    return (
      <AppLayout titulo="Frequência">
        <EstadoCarregando mensagem="Carregando..." />
      </AppLayout>
    );
  }

  if (estado === 'erro') {
    return (
      <AppLayout titulo="Frequência">
        <EstadoErro mensagem="Erro ao carregar dados de frequência." onTentarNovamente={carregar} />
      </AppLayout>
    );
  }

  // Localiza detalhes da aula selecionada para exibir no painel do topo
  const aulaInfo = aulas.find((a) => a.id.toString() === aulaSelecionada?.toString());
  const prof = aulaInfo ? professores.find((u) => u.id?.toString() === aulaInfo.usuarioId?.toString()) : null;
  const professorNome = prof ? prof.nome : 'Professor não atribuído';

  return (
    <AppLayout titulo="Frequência">
      <div className="freq-content">
        {/* Seletor de Aula */}
        <div className="freq-select-wrap" style={{ marginBottom: 'var(--sp-md)' }}>
          <label className="input-padrao__label">Selecione a Aula</label>
          <div className="select-wrapper">
            <span className="material-icons select-wrapper__icon">school</span>
            <select
              className="select-wrapper__select"
              value={aulaSelecionada || ''}
              onChange={(e) => handleSelectAula(e.target.value)}
            >
              <option value="">Selecione uma aula...</option>
              {aulas.map((aula) => {
                const p = professores.find((u) => u.id?.toString() === aula.usuarioId?.toString());
                const pNome = p ? p.nome : 'Professor não atribuído';
                return (
                  <option key={aula.id} value={aula.id}>
                    {aula.nome} - Prof. {pNome} ({aula.diaSemana})
                  </option>
                );
              })}
            </select>
            <span className="material-icons select-wrapper__arrow">expand_more</span>
          </div>
        </div>

        {/* Professor Responsável Elegante */}
        {aulaSelecionada && (
          <div className="freq-prof-res-badge" style={{ display: 'flex', alignItems: 'center', gap: '8px', padding: '10px 16px', borderRadius: 'var(--radius-md)', background: 'rgba(236, 163, 29, 0.08)', color: 'var(--color-primary)', marginBottom: 'var(--sp-md)', fontSize: 'var(--fs-body-sm)', fontWeight: 'var(--fw-medium)', border: '1px solid rgba(236, 163, 29, 0.15)' }}>
            <span className="material-icons" style={{ fontSize: '18px' }}>verified_user</span>
            <span>Professor Responsável: <strong>{professorNome}</strong></span>
          </div>
        )}

        {/* Detalhes da Aula (Painel do Topo) */}
        {aulaSelecionada && aulaInfo && (
          <div className="freq-aula-info-card fade-slide-up">
            <h3>{aulaInfo.nome}</h3>
            <div className="freq-aula-info-grid">
              <div className="freq-aula-info-item">
                <span className="material-icons">person</span>
                <span>{professorNome}</span>
              </div>
              <div className="freq-aula-info-item">
                <span className="material-icons">schedule</span>
                <span>{aulaInfo.horarioInicio} - {aulaInfo.horarioFim}</span>
              </div>
              <div className="freq-aula-info-item">
                <span className="material-icons">calendar_today</span>
                <span>{new Date().toLocaleDateString('pt-BR')}</span>
              </div>
            </div>
          </div>
        )}

        {!aulaSelecionada && (
          <EstadoVazio
            titulo="Selecione uma aula"
            subtitulo="Escolha a aula para registrar frequência"
            icone="fact_check"
          />
        )}

        {aulaSelecionada && alunosDaAula.length === 0 && (
          <EstadoVazio
            titulo="Nenhum aluno nesta aula"
            subtitulo="Associe alunos à aula primeiro"
            icone="person_off"
          />
        )}

        {aulaSelecionada && alunosDaAula.length > 0 && (
          <div className="freq-alunos">
            <p className="freq-data">Alunos Matriculados</p>
            {alunosDaAula.map((aluno, i) => {
              const id = (aluno.aluno_id || aluno.id)?.toString();
              const nome = aluno.nome || `Aluno #${id}`;
              const status = frequenciasTemporarias[id]; // Estado local do lote (1 ou 0 ou undefined)
              
              // Determina as classes para efeito de inatividade (desbotado)
              let classPresente = 'freq-action-btn freq-action-btn--presente';
              let classFalta = 'freq-action-btn freq-action-btn--falta';

              if (status === 1) {
                classPresente += ' freq-action-btn--presente-active';
                classFalta += ' freq-action-btn--inactive';
              } else if (status === 0) {
                classPresente += ' freq-action-btn--inactive';
                classFalta += ' freq-action-btn--falta-active';
              }

              return (
                <div
                  key={id || i}
                  className={`freq-aluno-card fade-slide-up${status === 1 ? ' freq-aluno-card--presente' : status === 0 ? ' freq-aluno-card--falta' : ''}`}
                  style={{ animationDelay: `${i * 30}ms` }}
                >
                  <div className="freq-aluno-header">
                    <div className="freq-aluno-avatar">{nome[0]?.toUpperCase() || '?'}</div>
                    <span className="freq-aluno-nome">{nome}</span>
                  </div>
                  <div className="freq-actions">
                    <button
                      className={classPresente}
                      onClick={() => marcarFrequenciaLocal(id, 1)}
                      disabled={salvandoGeral}
                    >
                      <span className="material-icons">check_circle</span>
                      <span>Presente</span>
                    </button>
                    <button
                      className={classFalta}
                      onClick={() => marcarFrequenciaLocal(id, 0)}
                      disabled={salvandoGeral}
                    >
                      <span className="material-icons">cancel</span>
                      <span>Falta</span>
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        )}

        {/* Botões do Rodapé (Lote) */}
        {aulaSelecionada && alunosDaAula.length > 0 && (
          <div className="freq-bottom-actions fade-slide-up">
            <BotaoPrimario
              texto="Salvar Frequência"
              icone="save"
              carregando={salvandoGeral}
              onClick={salvarFrequenciaGeral}
            />
            <BotaoOutline
              texto="Resetar Frequência"
              icone="restart_alt"
              onClick={resetarFrequenciaGeral}
              disabled={salvandoGeral}
            />
          </div>
        )}
      </div>

      {snack && (
        <div className="freq-toast" role="status" aria-live="polite">
          <span className="material-icons">check_circle</span>
          <span>{snack}</span>
        </div>
      )}
    </AppLayout>
  );
}

