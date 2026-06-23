import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import AppLayout from '../components/AppLayout';
import CardAula from '../components/CardAula';
import { EstadoCarregando, EstadoErro, EstadoVazio } from '../components/EstadoVisual';
import ModalFormulario from '../components/ModalFormulario';
import InputPadrao from '../components/InputPadrao';
import BotaoPrimario from '../components/BotaoPrimario';
import * as aulasService from '../services/aulasService';
import * as aulaAlunoService from '../services/aulaAlunoService';
import * as alunosService from '../services/alunosService';
import * as usuariosService from '../services/usuariosService';
import { getUserId } from '../services/api';
import { diaSemanaAtual } from '../utils/helpers';
import './AulasPage.css';

const DIAS = [
  { dia: 'Seg', nome: 'segunda-feira' }, { dia: 'Ter', nome: 'terça-feira' },
  { dia: 'Qua', nome: 'quarta-feira' }, { dia: 'Qui', nome: 'quinta-feira' },
  { dia: 'Sex', nome: 'sexta-feira' }, { dia: 'Sáb', nome: 'sábado' },
  { dia: 'Dom', nome: 'domingo' },
];

export default function AulasPage() {
  const [aulas, setAulas] = useState([]);
  const [estado, setEstado] = useState('carregando');
  const [erro, setErro] = useState(null);
  const [diaSelecionado, setDiaSelecionado] = useState(diaSemanaAtual());
  const [busca, setBusca] = useState('');
  const [modalOpen, setModalOpen] = useState(false);
  const [editAula, setEditAula] = useState(null);
  const [form, setForm] = useState({ nome: '', horarioInicio: '', horarioFim: '', diaSemana: 'segunda-feira', frequencia: 'Semanal', usuarioId: '' });
  const [professores, setProfessores] = useState([]);
  const [alunos, setAlunos] = useState([]);
  const [alunosSelecionados, setAlunosSelecionados] = useState([]);
  const [salvando, setSalvando] = useState(false);
  const navigate = useNavigate();

  const carregar = async () => {
    setEstado('carregando');
    try {
      const [aulasData, assocData, usersData, alunosData] = await Promise.all([
        aulasService.listar(),
        aulaAlunoService.listar().catch(() => []),
        usuariosService.listar().catch(() => []),
        alunosService.listar().catch(() => [])
      ]);
      
      setProfessores(usersData);
      setAlunos(alunosData);

      const mapAssoc = {};
      for (const a of assocData) {
        const k = a.aulaId.toString();
        if (!mapAssoc[k]) mapAssoc[k] = [];
        mapAssoc[k].push(a.alunoId.toString());
      }

      const mappedAulas = aulasData.map((a) => {
        const prof = usersData.find((u) => u.id?.toString() === a.usuarioId?.toString());
        return {
          ...a,
          alunoIds: mapAssoc[a.id] || a.alunoIds || [],
          professorNome: prof ? prof.nome : 'Professor não atribuído'
        };
      });

      setAulas(mappedAulas);
      setEstado(mappedAulas.length === 0 ? 'vazio' : 'sucesso');
    } catch (e) {
      setErro(e.message);
      setEstado('erro');
    }
  };

  useEffect(() => { carregar(); }, []);

  const filtradas = aulas
    .filter((a) => a.diaSemana.toLowerCase().trim() === diaSelecionado.toLowerCase().trim())
    .filter((a) => !busca.trim() || a.nome.toLowerCase().includes(busca.toLowerCase()) || (a.professorNome || '').toLowerCase().includes(busca.toLowerCase()));

  const hoje = new Date();
  const inicioSemana = new Date(hoje);
  inicioSemana.setDate(hoje.getDate() - (hoje.getDay() === 0 ? 6 : hoje.getDay() - 1));

  const openModal = (aula = null) => {
    if (aula) {
      setEditAula(aula);
      setForm({
        nome: aula.nome,
        horarioInicio: aula.horarioInicio,
        horarioFim: aula.horarioFim,
        diaSemana: aula.diaSemana,
        frequencia: aula.frequencia,
        usuarioId: aula.usuarioId?.toString() || ''
      });
      setAlunosSelecionados(aula.alunoIds || []);
    } else {
      setEditAula(null);
      setForm({
        nome: '',
        horarioInicio: '',
        horarioFim: '',
        diaSemana: diaSelecionado,
        frequencia: 'Semanal',
        usuarioId: ''
      });
      setAlunosSelecionados([]);
    }
    setModalOpen(true);
  };

  const handleSalvar = async (e) => {
    e.preventDefault();
    setSalvando(true);
    try {
      const aulaData = {
        ...form,
        usuarioId: form.usuarioId || '',
        alunoIds: alunosSelecionados
      };
      if (editAula) {
        await aulasService.atualizar({ ...aulaData, id: editAula.id });
        // Sync aluno associations
        const aulaId = parseInt(editAula.id);
        const existentes = await aulaAlunoService.obterAlunosDeUmaAula(aulaId).catch(() => []);
        const idsExistentes = new Set(existentes.map((e) => (e.aluno_id || e.id)?.toString()).filter(Boolean));
        const novos = new Set(alunosSelecionados);
        for (const idExist of idsExistentes) { if (!novos.has(idExist)) await aulaAlunoService.remover(aulaId, parseInt(idExist)).catch(() => {}); }
        for (const idNovo of novos) { if (!idsExistentes.has(idNovo)) await aulaAlunoService.associar(aulaId, parseInt(idNovo)).catch(() => {}); }
      } else {
        const criada = await aulasService.criar(aulaData);
        const aulaId = parseInt(criada.id);
        if (aulaId) { for (const aId of alunosSelecionados) { await aulaAlunoService.associar(aulaId, parseInt(aId)).catch(() => {}); } }
      }
      setModalOpen(false);
      carregar();
    } catch {}
    setSalvando(false);
  };

  const toggleAluno = (aId) => {
    setAlunosSelecionados((prev) => prev.includes(aId) ? prev.filter((x) => x !== aId) : [...prev, aId]);
  };

  return (
    <AppLayout titulo="Aulas">
      {/* Day selector */}
      <div className="aulas-dias">
        {DIAS.map((d, i) => {
          const data = new Date(inicioSemana);
          data.setDate(inicioSemana.getDate() + i);
          const sel = diaSelecionado === d.nome;
          return (
            <div key={d.nome} className={`aulas-dia ${sel ? 'aulas-dia--sel' : ''}`} onClick={() => setDiaSelecionado(d.nome)}>
              <span className="aulas-dia__sigla">{d.dia}</span>
              <span className="aulas-dia__num">{data.getDate()}</span>
            </div>
          );
        })}
      </div>
      <div className="alunos-search" style={{ marginBottom: 'var(--sp-lg)' }}>
        <span className="material-icons alunos-search-icon">search</span>
        <input className="alunos-search-input" placeholder="Buscar aula ou professor" value={busca} onChange={(e) => setBusca(e.target.value)} />
      </div>
      <div style={{ flex: 1, overflowY: 'auto' }}>
        {estado === 'carregando' && <EstadoCarregando mensagem="Carregando aulas..." />}
        {estado === 'erro' && <EstadoErro mensagem={erro} onTentarNovamente={carregar} />}
        {estado === 'vazio' && <EstadoVazio titulo="Nenhuma aula neste dia" subtitulo="Crie uma nova aula" icone="event_busy" onAcao={() => openModal()} textoAcao="Nova aula" />}
        {estado === 'sucesso' && filtradas.length === 0 && <EstadoVazio titulo="Sem aulas para este dia" subtitulo="Selecione outro dia ou crie uma aula" icone="event_note" />}
        {estado === 'sucesso' && filtradas.length > 0 && (
          <div className="aulas-list">
            {filtradas.map((aula, i) => (
              <div key={aula.id} className="fade-slide-up" style={{ animationDelay: `${i * 40}ms` }}>
                <CardAula aula={aula} totalAlunos={aula.alunoIds.length}
                  onDetalhes={() => navigate(`/aulas/${aula.id}`)}
                  onFrequencia={() => navigate(`/frequencia/${aula.id}`)}
                  onEditar={() => openModal(aula)} />
              </div>
            ))}
          </div>
        )}
      </div>
      <div style={{ paddingTop: 'var(--sp-md)' }}>
        <BotaoPrimario texto="Nova aula" icone="add" onClick={() => openModal()} />
      </div>

      <ModalFormulario
        titulo={editAula ? 'Editar Aula' : 'Nova Aula'}
        aberto={modalOpen}
        onFechar={() => setModalOpen(false)}
        rodape={<BotaoPrimario texto="Salvar" tipo="submit" form="form-nova-aula" carregando={salvando} />}
      >
        <form id="form-nova-aula" onSubmit={handleSalvar} style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-md)' }}>
          <InputPadrao label="Nome da aula" value={form.nome} onChange={(e) => setForm({ ...form, nome: e.target.value })} icone="event_note" />
          <InputPadrao label="Horário início" hint="08:00" value={form.horarioInicio} onChange={(e) => setForm({ ...form, horarioInicio: e.target.value })} icone="schedule" />
          <InputPadrao label="Horário fim" hint="09:00" value={form.horarioFim} onChange={(e) => setForm({ ...form, horarioFim: e.target.value })} icone="schedule" />

          {/* Dia da semana — pills visuais */}
          <div className="input-padrao">
            <label className="input-padrao__label">Dia da semana</label>
            <div className="aulas-dias-pills">
              {DIAS.map((d) => (
                <button
                  key={d.nome}
                  type="button"
                  className={`aulas-dia-pill ${form.diaSemana === d.nome ? 'aulas-dia-pill--sel' : ''}`}
                  onClick={() => setForm({ ...form, diaSemana: d.nome })}
                >
                  {d.dia}
                </button>
              ))}
            </div>
          </div>

          {/* Professor */}
          <div className="input-padrao">
            <label className="input-padrao__label">Professor Responsável</label>
            <div className="select-wrapper">
              <span className="material-icons select-wrapper__icon">person</span>
              <select
                className="select-wrapper__select"
                value={form.usuarioId}
                onChange={(e) => setForm({ ...form, usuarioId: e.target.value })}
              >
                <option value="">Selecione um professor...</option>
                {professores.map((p) => (
                  <option key={p.id} value={p.id}>
                    {p.nome}
                  </option>
                ))}
              </select>
              <span className="material-icons select-wrapper__arrow">expand_more</span>
            </div>
          </div>

          {/* Alunos — chips toggle estilizados */}
          {alunos.length > 0 && (
            <div className="input-padrao">
              <label className="input-padrao__label">
                Alunos
                {alunosSelecionados.length > 0 && (
                  <span className="aulas-alunos-badge">{alunosSelecionados.length} selecionado{alunosSelecionados.length > 1 ? 's' : ''}</span>
                )}
              </label>
              <div className="aulas-alunos-chips">
                {alunos.map((a) => {
                  const sel = alunosSelecionados.includes(a.id?.toString());
                  return (
                    <button
                      key={a.id}
                      type="button"
                      className={`aulas-aluno-chip ${sel ? 'aulas-aluno-chip--sel' : ''}`}
                      onClick={() => toggleAluno(a.id?.toString())}
                    >
                      <span className="aulas-aluno-chip__avatar">{(a.nome || '?')[0].toUpperCase()}</span>
                      <span className="aulas-aluno-chip__nome">{a.nome}</span>
                      {sel && <span className="material-icons aulas-aluno-chip__check">check</span>}
                    </button>
                  );
                })}
              </div>
            </div>
          )}

        </form>
      </ModalFormulario>
    </AppLayout>
  );
}
