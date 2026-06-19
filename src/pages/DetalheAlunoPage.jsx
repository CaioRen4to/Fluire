import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import AppLayout from '../components/AppLayout';
import { EstadoCarregando, EstadoErro } from '../components/EstadoVisual';
import ModalFormulario from '../components/ModalFormulario';
import InputPadrao from '../components/InputPadrao';
import BotaoPrimario, { BotaoTexto } from '../components/BotaoPrimario';
import * as alunosService from '../services/alunosService';
import * as aulaAlunoService from '../services/aulaAlunoService';
import { inicial, frequenciaPercentual } from '../utils/helpers';
import './DetalheAlunoPage.css';

export default function DetalheAlunoPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [aluno, setAluno] = useState(null);
  const [aulas, setAulas] = useState([]);
  const [estado, setEstado] = useState('carregando');
  const [erro, setErro] = useState(null);
  const [editOpen, setEditOpen] = useState(false);
  const [nome, setNome] = useState('');
  const [email, setEmail] = useState('');
  const [telefone, setTelefone] = useState('');
  const [modalidade, setModalidade] = useState('');
  const [salvando, setSalvando] = useState(false);

  const carregar = async () => {
    setEstado('carregando');
    try {
      const data = await alunosService.buscarPorId(id);
      if (!data) { setEstado('erro'); setErro('Aluno não encontrado'); return; }
      setAluno(data);
      setNome(data.nome || ''); setEmail(data.email || ''); setTelefone(data.telefone || ''); setModalidade(data.modalidade || '');
      try { const a = await aulaAlunoService.obterAulasDeUmAluno(parseInt(id)); setAulas(a); } catch {}
      setEstado('sucesso');
    } catch (e) { setErro(e.message); setEstado('erro'); }
  };

  useEffect(() => { carregar(); }, [id]);

  const handleEditar = async (e) => {
    e.preventDefault();
    setSalvando(true);
    try {
      await alunosService.atualizar({ ...aluno, nome, email, telefone, modalidade });
      setEditOpen(false);
      navigate('/alunos', { replace: true });
    } catch {
      // Se houver erro, ignora silenciosamente como antes ou adicione lógica de erro se necessário
    } finally {
      setSalvando(false);
    }
  };

  const handleExcluir = async () => {
    if (!window.confirm('Tem certeza que deseja excluir este aluno?')) return;
    try { await alunosService.remover(id); navigate('/alunos', { replace: true }); } catch {}
  };

  if (estado === 'carregando') return <AppLayout titulo="Detalhes do Aluno"><EstadoCarregando /></AppLayout>;
  if (estado === 'erro') return <AppLayout titulo="Detalhes do Aluno"><EstadoErro mensagem={erro} onTentarNovamente={carregar} /></AppLayout>;

  const pct = frequenciaPercentual(aluno.presencas || 0, aluno.faltas || 0);

  return (
    <AppLayout titulo="Detalhes do Aluno">
      <div className="detalhe-aluno">
        <div className="detalhe-aluno__card fade-slide-up">
          <div className="detalhe-aluno__avatar">{inicial(aluno.nome)}</div>
          <h2 className="detalhe-aluno__nome">{aluno.nome}</h2>
          <span className="detalhe-aluno__sub">{aluno.modalidade || aluno.email}</span>
          <div className={`detalhe-aluno__badge ${aluno.ativo === false || aluno.ativo === 0 ? 'detalhe-aluno__badge--inativo' : ''}`}>
            {aluno.ativo === false || aluno.ativo === 0 ? 'Inativo' : 'Ativo'}
          </div>
        </div>
        <div className="detalhe-aluno__stats fade-slide-up" style={{ animationDelay: '50ms' }}>
          <div className="detalhe-aluno__stat"><span className="detalhe-aluno__stat-val" style={{ color: 'var(--color-sucesso)' }}>{aluno.presencas || 0}</span><span className="detalhe-aluno__stat-label">Presenças</span></div>
          <div className="detalhe-aluno__stat"><span className="detalhe-aluno__stat-val" style={{ color: 'var(--color-erro)' }}>{aluno.faltas || 0}</span><span className="detalhe-aluno__stat-label">Faltas</span></div>
          <div className="detalhe-aluno__stat"><span className="detalhe-aluno__stat-val" style={{ color: 'var(--color-primary)' }}>{pct}%</span><span className="detalhe-aluno__stat-label">Frequência</span></div>
        </div>
        <div className="detalhe-aluno__info fade-slide-up" style={{ animationDelay: '100ms' }}>
          <h3>Informações</h3>
          <div className="detalhe-aluno__row"><span className="material-icons-outlined">mail</span><div><small>E-mail</small><span>{aluno.email || '—'}</span></div></div>
          <div className="detalhe-aluno__row"><span className="material-icons-outlined">phone</span><div><small>Telefone</small><span>{aluno.telefone || '—'}</span></div></div>
          <div className="detalhe-aluno__row"><span className="material-icons-outlined">category</span><div><small>Modalidade</small><span>{aluno.modalidade || '—'}</span></div></div>
        </div>
        {aulas.length > 0 && (
          <div className="detalhe-aluno__info fade-slide-up" style={{ animationDelay: '150ms' }}>
            <h3>Aulas ({aulas.length})</h3>
            {aulas.map((a, i) => (
              <div key={i} className="detalhe-aluno__row" onClick={() => navigate(`/aulas/${a.id || a.aula_id}`)} style={{ cursor: 'pointer' }}>
                <span className="material-icons-outlined">event_note</span>
                <div><span>{a.nome || `Aula #${a.aula_id || a.id}`}</span></div>
              </div>
            ))}
          </div>
        )}
        <div className="detalhe-aluno__actions fade-slide-up" style={{ animationDelay: '200ms' }}>
          <BotaoPrimario texto="Editar" icone="edit" onClick={() => setEditOpen(true)} />
          <BotaoTexto texto="Excluir aluno" cor="erro" onClick={handleExcluir} />
        </div>
      </div>
      <ModalFormulario titulo="Editar Aluno" aberto={editOpen} onFechar={() => setEditOpen(false)}>
        <form onSubmit={handleEditar} style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-md)' }}>
          <InputPadrao label="Nome" value={nome} onChange={(e) => setNome(e.target.value)} icone="person" />
          <InputPadrao label="E-mail" value={email} onChange={(e) => setEmail(e.target.value)} icone="mail" />
          <InputPadrao label="Telefone" value={telefone} onChange={(e) => setTelefone(e.target.value)} icone="phone" />
          <InputPadrao label="Modalidade" value={modalidade} onChange={(e) => setModalidade(e.target.value)} icone="category" />
          <BotaoPrimario texto="Salvar" tipo="submit" carregando={salvando} />
        </form>
      </ModalFormulario>
    </AppLayout>
  );
}
