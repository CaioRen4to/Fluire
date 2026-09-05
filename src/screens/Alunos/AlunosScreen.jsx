import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import AppLayout from '../../components/AppLayout/AppLayout';
import CardAluno from '../../components/CardAluno/CardAluno';
import { EstadoCarregando, EstadoErro, EstadoVazio } from '../../components/EstadoVisual/EstadoVisual';
import ModalFormulario from '../../components/ModalFormulario/ModalFormulario';
import InputPadrao from '../../components/InputPadrao/InputPadrao';
import BotaoPrimario from '../../components/BotaoPrimario/BotaoPrimario';
import * as alunosService from '../../services/alunosService';
import { getUserId } from '../../services/api';
import './AlunosScreen.css';

export default function AlunosScreen() {
  const [alunos, setAlunos] = useState([]);
  const [estado, setEstado] = useState('carregando');
  const [erro, setErro] = useState(null);
  const [busca, setBusca] = useState('');
  const [modalOpen, setModalOpen] = useState(false);
  const [nome, setNome] = useState('');
  const [email, setEmail] = useState('');
  const [telefone, setTelefone] = useState('');
  const [salvando, setSalvando] = useState(false);
  const navigate = useNavigate();

  const carregar = async () => {
    setEstado('carregando');
    try {
      const data = await alunosService.listar();
      setAlunos(data);
      setEstado(data.length === 0 ? 'vazio' : 'sucesso');
    } catch (e) {
      setErro(e.message);
      setEstado('erro');
    }
  };

  useEffect(() => { carregar(); }, []);

  const filtrados = busca.trim()
    ? alunos.filter((a) => (a.nome || '').toLowerCase().includes(busca.toLowerCase()) || (a.modalidade || '').toLowerCase().includes(busca.toLowerCase()))
    : alunos;

  const total = alunos.length;
  const ativos = alunos.filter((a) => a.ativo === true || a.ativo === 1).length;

  const handleCriar = async (e) => {
    e.preventDefault();
    setSalvando(true);
    try {
      await alunosService.criar({ nome, email, telefone });
      setModalOpen(false);
      setNome(''); setEmail(''); setTelefone('');
      carregar();
    } catch { /* ignore */ }
    setSalvando(false);
  };

  const conteudo = () => {
    if (estado === 'carregando') return <EstadoCarregando mensagem="Carregando alunos..." />;
    if (estado === 'erro') return <EstadoErro mensagem={erro} onTentarNovamente={carregar} />;
    if (estado === 'vazio') return <EstadoVazio titulo="Nenhum aluno cadastrado" subtitulo="Adicione o primeiro aluno pelo botão +" onAcao={() => setModalOpen(true)} textoAcao="Novo aluno" />;
    if (filtrados.length === 0) return <EstadoVazio titulo="Nenhum resultado" subtitulo="Tente outro termo de busca" icone="search_off" />;
    return (
      <div className="alunos-list">
        {filtrados.map((aluno, i) => (
          <div key={aluno.id || i} className="fade-slide-up" style={{ animationDelay: `${i * 30}ms` }}>
            <CardAluno aluno={aluno} onTap={() => navigate(`/alunos/${aluno.id}`)} />
          </div>
        ))}
      </div>
    );
  };

  return (
    <AppLayout titulo="Alunos" acaoFlutuante={<button className="fab-button" onClick={() => setModalOpen(true)}><span className="material-icons">add</span></button>}>
      <div className="alunos-resumo">
        <div className="alunos-resumo-item"><span className="alunos-resumo-val" style={{ color: 'var(--color-primary)' }}>{total}</span><span className="alunos-resumo-label">Total</span></div>
        <div className="alunos-resumo-item"><span className="alunos-resumo-val" style={{ color: 'var(--color-sucesso)' }}>{ativos}</span><span className="alunos-resumo-label">Ativos</span></div>
        <div className="alunos-resumo-item"><span className="alunos-resumo-val" style={{ color: 'var(--color-erro)' }}>{total - ativos}</span><span className="alunos-resumo-label">Inativos</span></div>
      </div>
      <div className="alunos-search">
        <span className="material-icons alunos-search-icon">search</span>
        <input className="alunos-search-input" placeholder="Buscar aluno..." value={busca} onChange={(e) => setBusca(e.target.value)} />
      </div>
      {conteudo()}
      <ModalFormulario
        titulo="Novo Aluno"
        aberto={modalOpen}
        onFechar={() => setModalOpen(false)}
        rodape={<BotaoPrimario texto="Salvar" tipo="submit" form="form-novo-aluno" carregando={salvando} />}
      >
        <form id="form-novo-aluno" onSubmit={handleCriar} style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-md)' }}>
          <InputPadrao label="Nome" value={nome} onChange={(e) => setNome(e.target.value)} icone="person" />
          <InputPadrao label="E-mail" value={email} onChange={(e) => setEmail(e.target.value)} icone="mail" keyboardType="email" />
          <InputPadrao label="Telefone" value={telefone} onChange={(e) => setTelefone(e.target.value)} icone="phone" />
        </form>
      </ModalFormulario>
    </AppLayout>
  );
}

