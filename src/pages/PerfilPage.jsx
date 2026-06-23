import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import AppLayout from '../components/AppLayout';
import { EstadoCarregando } from '../components/EstadoVisual';
import { BotaoTexto } from '../components/BotaoPrimario';
import * as usuariosService from '../services/usuariosService';
import './PerfilPage.css';

export default function PerfilPage() {
  const { usuario, logout } = useAuth();
  const navigate = useNavigate();

  // Estado do modal de exclusão de conta
  const [confirmaOpen, setConfirmaOpen] = useState(false);
  const [confirmaTxt, setConfirmaTxt] = useState('');
  const [excluindo, setExcluindo] = useState(false);
  const [erroExclusao, setErroExclusao] = useState('');

  const handleLogout = () => {
    logout();
    navigate('/login', { replace: true });
  };

  // Abre o modal de confirmação e limpa estado anterior
  const abrirConfirma = () => {
    setConfirmaTxt('');
    setErroExclusao('');
    setConfirmaOpen(true);
  };

  const fecharConfirma = () => {
    if (excluindo) return; // impede fechar durante requisição
    setConfirmaOpen(false);
  };

  const handleExcluirConta = async () => {
    if (confirmaTxt.trim().toLowerCase() !== 'excluir') {
      setErroExclusao('Digite "excluir" para confirmar.');
      return;
    }
    setExcluindo(true);
    setErroExclusao('');
    try {
      await usuariosService.remover(usuario.id);
      logout();
      navigate('/login', { replace: true });
    } catch (e) {
      setErroExclusao(e.message || 'Não foi possível excluir a conta.');
      setExcluindo(false);
    }
  };

  if (!usuario) return <AppLayout titulo="Meu Perfil"><EstadoCarregando mensagem="Carregando perfil..." /></AppLayout>;

  const tipoLabel = () => {
    const t = usuario.tipo_usuario || usuario.tipoUsuario;
    if (t === 1 || t === '1') return 'Administrador';
    if (t === 2 || t === '2') return 'Professor';
    return 'Usuário';
  };

  return (
    <AppLayout titulo="Meu Perfil">
      <div className="perfil-content">

        {/* Card do avatar e nome */}
        <div className="perfil-card fade-slide-up">
          <div className="perfil-avatar">
            <span className="material-icons">person</span>
          </div>
          <h2 className="perfil-nome">{usuario.nome}</h2>
          <span className="perfil-email">{usuario.email}</span>
          <div className="perfil-badge">{tipoLabel()}</div>
        </div>

        {/* Informações da conta */}
        <div className="perfil-info fade-slide-up" style={{ animationDelay: '50ms' }}>
          <h3>Informações da Conta</h3>
          <div className="perfil-row">
            <span className="material-icons-outlined">badge</span>
            <div><small>ID</small><span>{usuario.id}</span></div>
          </div>
          <div className="perfil-row">
            <span className="material-icons-outlined">mail</span>
            <div><small>E-mail</small><span>{usuario.email}</span></div>
          </div>
          <div className="perfil-row">
            <span className="material-icons-outlined">person</span>
            <div><small>Nome</small><span>{usuario.nome}</span></div>
          </div>
        </div>

        {/* Ações normais */}
        <div className="perfil-actions fade-slide-up" style={{ animationDelay: '100ms' }}>
          <BotaoTexto texto="Sair da conta" cor="erro" onClick={handleLogout} />
        </div>

        {/* ===== Zona de Perigo ===== */}
        <div className="perfil-danger-zone fade-slide-up" style={{ animationDelay: '150ms' }}>
          <div className="perfil-danger-header">
            <span className="material-icons perfil-danger-icon">warning</span>
            <span className="perfil-danger-title">Zona de Perigo</span>
          </div>
          <p className="perfil-danger-desc">
            A exclusão remove <strong>seus dados de cadastro e acesso</strong> (nome, e-mail e senha) permanentemente. O histórico de ações realizadas por você será mantido no sistema para fins de registro e auditoria.
          </p>
          <button className="perfil-danger-btn" onClick={abrirConfirma}>
            <span className="material-icons">delete_forever</span>
            Excluir minha conta
          </button>
        </div>

      </div>

      {/* ===== Modal de Confirmação de Exclusão ===== */}
      {confirmaOpen && (
        <div className="perfil-modal-overlay" onClick={fecharConfirma}>
          <div className="perfil-modal-sheet fade-slide-up" onClick={(e) => e.stopPropagation()}>
            {/* Handle bar */}
            <div className="perfil-modal-handle" />

            {/* Ícone de alerta */}
            <div className="perfil-modal-alert-icon">
              <span className="material-icons">delete_forever</span>
            </div>

            <h2 className="perfil-modal-titulo">Excluir conta?</h2>
            <p className="perfil-modal-desc">
              Seus dados de <strong>cadastro e acesso serão apagados</strong> do banco de dados. O histórico de atividades permanece registrado no sistema para outros usuários consultarem.
            </p>

            <div className="perfil-modal-confirm-field">
              <label className="perfil-modal-confirm-label">
                Para confirmar, digite <strong>excluir</strong> abaixo:
              </label>
              <input
                className={`perfil-modal-confirm-input ${erroExclusao ? 'perfil-modal-confirm-input--erro' : ''}`}
                type="text"
                value={confirmaTxt}
                onChange={(e) => { setConfirmaTxt(e.target.value); setErroExclusao(''); }}
                placeholder="excluir"
                autoFocus
                disabled={excluindo}
              />
              {erroExclusao && (
                <span className="perfil-modal-erro">
                  <span className="material-icons" style={{ fontSize: 15 }}>error</span>
                  {erroExclusao}
                </span>
              )}
            </div>

            <div className="perfil-modal-actions">
              <button className="perfil-modal-cancel" onClick={fecharConfirma} disabled={excluindo}>
                Cancelar
              </button>
              <button
                className={`perfil-modal-delete ${excluindo ? 'perfil-modal-delete--loading' : ''}`}
                onClick={handleExcluirConta}
                disabled={excluindo || confirmaTxt.trim().toLowerCase() !== 'excluir'}
              >
                {excluindo
                  ? <><span className="perfil-spinner" />Excluindo...</>
                  : <><span className="material-icons">delete_forever</span>Excluir conta</>
                }
              </button>
            </div>
          </div>
        </div>
      )}
    </AppLayout>
  );
}
