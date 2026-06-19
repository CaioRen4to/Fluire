import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import AppLayout from '../components/AppLayout';
import { EstadoCarregando, EstadoErro } from '../components/EstadoVisual';
import BotaoPrimario, { BotaoTexto, BotaoOutline } from '../components/BotaoPrimario';
import ModalFormulario from '../components/ModalFormulario';
import InputPadrao from '../components/InputPadrao';
import * as aulasService from '../services/aulasService';
import * as aulaAlunoService from '../services/aulaAlunoService';
import * as alunosService from '../services/alunosService';
import * as usuariosService from '../services/usuariosService';
import './DetalheAulaPage.css';

const DIAS = [
  { dia: 'Seg', nome: 'segunda-feira' }, { dia: 'Ter', nome: 'terça-feira' },
  { dia: 'Qua', nome: 'quarta-feira' }, { dia: 'Qui', nome: 'quinta-feira' },
  { dia: 'Sex', nome: 'sexta-feira' }, { dia: 'Sáb', nome: 'sábado' },
  { dia: 'Dom', nome: 'domingo' },
];

export default function DetalheAulaPage() {
  const { id } = useParams();
  const idNumerico = parseInt(id, 10);
  const navigate = useNavigate();
  const [aula, setAula] = useState(null);
  const [alunosDaAula, setAlunosDaAula] = useState([]);
  const [alunos, setAlunos] = useState([]);
  const [alunosSelecionados, setAlunosSelecionados] = useState([]);
  const [estado, setEstado] = useState('carregando');
  const [erro, setErro] = useState(null);

  const [editOpen, setEditOpen] = useState(false);
  const [form, setForm] = useState({ nome: '', horarioInicio: '', horarioFim: '', diaSemana: 'segunda-feira', frequencia: 'Semanal', usuarioId: '' });
  const [professores, setProfessores] = useState([]);
  const [salvando, setSalvando] = useState(false);

  const carregar = async () => {
    if (isNaN(idNumerico)) {
      setErro('Identificador de aula inválido.');
      setEstado('erro');
      return;
    }
    setEstado('carregando');
    setErro(null);
    try {
      let data = null;
      try {
        // Chamada direta ao endpoint GET /aulas/:id do backend
        data = await aulasService.buscarPorId(idNumerico);
      } catch (err) {
        // Fallback defensivo: se falhar (ex: 405 do servidor não reiniciado), busca todas e filtra
        console.warn('Falha na busca direta da aula. Usando fallback por listagem:', err);
        const todasAulas = await aulasService.listar();
        data = todasAulas.find((a) => parseInt(a?.id, 10) === idNumerico);
      }

      // Tratamento de Array defensivo: extrai a primeira posição se por algum motivo vier envelopado
      if (Array.isArray(data)) {
        data = data[0];
      }

      if (!data) {
        setEstado('erro');
        setErro('Aula não encontrada.');
        return;
      }

      // Busca os usuários/professores para resolver o nome
      let users = [];
      try {
        users = await usuariosService.listar().catch(() => []);
        setProfessores(users);
      } catch (err) {
        console.error('Falha ao buscar professores:', err);
      }

      const prof = users.find((u) => u.id?.toString() === data.usuarioId?.toString());
      data.professorNome = prof ? prof.nome : 'Professor não atribuído';

      setAula(data);

      try {
        const al = await aulaAlunoService.obterAlunosDeUmaAula(idNumerico);
        setAlunosDaAula(Array.isArray(al) ? al : []);
        setAlunosSelecionados(Array.isArray(al) ? al.map((a) => (a.aluno_id || a.id).toString()) : []);
      } catch (err) {
        console.error('Falha silenciosa ao buscar alunos da aula:', err);
      }

      try {
        const todosAlunos = await alunosService.listar();
        setAlunos(Array.isArray(todosAlunos) ? todosAlunos : []);
      } catch (err) {
        console.error('Falha silenciosa ao buscar alunos gerais:', err);
      }

      setEstado('sucesso');
    } catch (e) {
      setErro(e.message || 'Erro ao processar requisição dos detalhes da aula');
      setEstado('erro');
    }
  };

  useEffect(() => {
    carregar();
  }, [id]);

  const handleExcluir = async () => {
    if (isNaN(idNumerico)) return;
    if (!window.confirm('Tem certeza que deseja excluir esta aula?')) return;
    try {
      await aulasService.remover(idNumerico);
      navigate('/aulas', { replace: true });
    } catch (err) {
      console.error('Erro ao excluir aula:', err);
      alert('Não foi possível excluir a aula.');
    }
  };

  const openEdit = () => {
    if (!aula) return;
    setForm({
      nome: aula.nome || '',
      horarioInicio: aula.horarioInicio || '',
      horarioFim: aula.horarioFim || '',
      diaSemana: aula.diaSemana || 'segunda-feira',
      frequencia: aula.frequencia || 'Semanal',
      usuarioId: aula.usuarioId?.toString() || ''
    });
    setAlunosSelecionados(alunosDaAula.map((a) => (a.aluno_id || a.id).toString()));
    setEditOpen(true);
  };

  const handleEditar = async (e) => {
    e.preventDefault();
    setSalvando(true);
    try {
      const aulaData = {
        ...form,
        usuarioId: form.usuarioId || '',
        id: idNumerico
      };
      
      // 1. PUT request para atualizar dados da aula
      await aulasService.atualizar(aulaData);

      // 2. Sincronização de alunos
      const existentes = await aulaAlunoService.obterAlunosDeUmaAula(idNumerico).catch(() => []);
      const idsExistentes = new Set(existentes.map((x) => (x.aluno_id || x.id)?.toString()).filter(Boolean));
      const novos = new Set(alunosSelecionados);

      // Remove associações antigas que foram desmarcadas
      for (const idExist of idsExistentes) {
        if (!novos.has(idExist)) {
          await aulaAlunoService.remover(idNumerico, parseInt(idExist, 10)).catch(() => {});
        }
      }

      // Adiciona novas associações marcadas
      for (const idNovo of novos) {
        if (!idsExistentes.has(idNovo)) {
          await aulaAlunoService.associar(idNumerico, parseInt(idNovo, 10)).catch(() => {});
        }
      }

      setEditOpen(false);
      await carregar();
    } catch (err) {
      console.error('Erro ao editar aula:', err);
      alert('Não foi possível atualizar os dados da aula.');
    } finally {
      setSalvando(false);
    }
  };

  const toggleAluno = (aId) => {
    setAlunosSelecionados((prev) =>
      prev.includes(aId) ? prev.filter((x) => x !== aId) : [...prev, aId]
    );
  };

  if (estado === 'carregando') {
    return (
      <AppLayout titulo="Detalhes da Aula">
        <EstadoCarregando />
      </AppLayout>
    );
  }

  // Proteção contra aula nula/indefinida
  if (estado === 'erro' || !aula) {
    return (
      <AppLayout titulo="Detalhes da Aula">
        <EstadoErro mensagem={erro || 'Nenhuma informação da aula pôde ser exibida.'} onTentarNovamente={carregar} />
      </AppLayout>
    );
  }

  return (
    <AppLayout titulo="Detalhes da Aula">
      <div className="detalhe-aula fade-slide-up">
        <div className="detalhe-aula__card">
          <div className="detalhe-aula__icon">
            <span className="material-icons">event_note</span>
          </div>
          <h2>{aula?.nome}</h2>
          <span className="detalhe-aula__sub">{aula?.diaSemana}</span>
        </div>
        <div className="detalhe-aula__info">
          <h3>Informações</h3>
          <div className="detalhe-aula__row">
            <span className="material-icons-outlined">schedule</span>
            <div>
              <small>Horário</small>
              <span>{aula?.horarioInicio} - {aula?.horarioFim}</span>
            </div>
          </div>
          <div className="detalhe-aula__row">
            <span className="material-icons-outlined">repeat</span>
            <div>
              <small>Frequência</small>
              <span>{aula?.frequencia}</span>
            </div>
          </div>
          <div className="detalhe-aula__row">
            <span className="material-icons-outlined">person</span>
            <div>
              <small>Professor</small>
              <span>{aula?.professorNome || `Professor #${aula?.usuarioId}`}</span>
            </div>
          </div>
        </div>
        {alunosDaAula.length > 0 && (
          <div className="detalhe-aula__info">
            <h3>Alunos ({alunosDaAula.length})</h3>
            {alunosDaAula.map((a, i) => (
              <div
                key={i}
                className="detalhe-aula__row"
                onClick={() => navigate(`/alunos/${a.id || a.aluno_id}`)}
                style={{ cursor: 'pointer' }}
              >
                <span className="material-icons-outlined">person</span>
                <div>
                  <span>{a.nome || `Aluno #${a.aluno_id || a.id}`}</span>
                </div>
              </div>
            ))}
          </div>
        )}
        <div className="detalhe-aula__actions">
          <BotaoPrimario
            texto="Frequência"
            icone="fact_check"
            onClick={() => navigate(`/frequencia/${idNumerico}`)}
          />
          <BotaoOutline
            texto="Editar"
            icone="edit"
            onClick={openEdit}
          />
          <BotaoTexto texto="Excluir aula" cor="erro" onClick={handleExcluir} />
        </div>
      </div>

      <ModalFormulario titulo="Editar Aula" aberto={editOpen} onFechar={() => setEditOpen(false)}>
        <form onSubmit={handleEditar} style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-md)' }}>
          <InputPadrao
            label="Nome da aula"
            value={form.nome}
            onChange={(e) => setForm({ ...form, nome: e.target.value })}
            icone="event_note"
          />
          <InputPadrao
            label="Horário início"
            hint="08:00"
            value={form.horarioInicio}
            onChange={(e) => setForm({ ...form, horarioInicio: e.target.value })}
            icone="schedule"
          />
          <InputPadrao
            label="Horário fim"
            hint="09:00"
            value={form.horarioFim}
            onChange={(e) => setForm({ ...form, horarioFim: e.target.value })}
            icone="schedule"
          />
          <div className="input-padrao">
            <label className="input-padrao__label">Dia da semana</label>
            <select
              className="aulas-select"
              value={form.diaSemana}
              onChange={(e) => setForm({ ...form, diaSemana: e.target.value })}
            >
              {DIAS.map((d) => (
                <option key={d.nome} value={d.nome}>
                  {d.dia} - {d.nome}
                </option>
              ))}
            </select>
          </div>
          <div className="input-padrao">
            <label className="input-padrao__label">Professor Responsável</label>
            <select
              className="aulas-select"
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
          </div>
          <InputPadrao
            label="Frequência"
            value={form.frequencia}
            onChange={(e) => setForm({ ...form, frequencia: e.target.value })}
            icone="repeat"
          />
          {alunos.length > 0 && (
            <div className="input-padrao">
              <label className="input-padrao__label">Alunos ({alunosSelecionados.length})</label>
              <div className="aulas-alunos-list">
                {alunos.map((a) => (
                  <label key={a.id} className="aulas-aluno-check">
                    <input
                      type="checkbox"
                      checked={alunosSelecionados.includes(a.id?.toString())}
                      onChange={() => toggleAluno(a.id?.toString())}
                    />
                    <span>{a.nome}</span>
                  </label>
                ))}
              </div>
            </div>
          )}
          <BotaoPrimario texto="Salvar" tipo="submit" carregando={salvando} />
        </form>
      </ModalFormulario>
    </AppLayout>
  );
}
