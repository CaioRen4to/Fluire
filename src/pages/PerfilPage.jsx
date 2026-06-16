import { useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import AppLayout from '../components/AppLayout';
import { EstadoCarregando } from '../components/EstadoVisual';
import { BotaoTexto } from '../components/BotaoPrimario';
import './PerfilPage.css';

export default function PerfilPage() {
  const { usuario, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login', { replace: true });
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
        <div className="perfil-card fade-slide-up">
          <div className="perfil-avatar">
            <span className="material-icons">person</span>
          </div>
          <h2 className="perfil-nome">{usuario.nome}</h2>
          <span className="perfil-email">{usuario.email}</span>
          <div className="perfil-badge">{tipoLabel()}</div>
        </div>

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

        <div className="perfil-actions fade-slide-up" style={{ animationDelay: '100ms' }}>
          <BotaoTexto texto="Sair" cor="erro" onClick={handleLogout} />
        </div>
      </div>
    </AppLayout>
  );
}
