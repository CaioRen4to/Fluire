import { NavLink, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import logoFluire from '../../assets/images/logo-fluire.png';
import './SideMenu.css';

const ITEMS = [
  { path: '/dashboard', icon: 'dashboard', label: 'Dashboard' },
  { path: '/alunos', icon: 'people_outline', label: 'Alunos' },
  { path: '/aulas', icon: 'event_note', label: 'Aulas' },
  { path: '/historico', icon: 'history', label: 'Histórico' },
  { path: '/professores', icon: 'school', label: 'Professores' },
  { path: '/perfil', icon: 'person_outline', label: 'Perfil' },
];

export default function SideMenu({ open, onClose, permanente = false }) {
  const { logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const handleLogout = () => {
    logout();
    navigate('/login', { replace: true });
  };

  const handleNav = () => {
    if (!permanente && onClose) onClose();
  };

  return (
    <>
      {!permanente && open && <div className="side-menu-overlay" onClick={onClose} />}
      <aside className={`side-menu ${permanente ? 'side-menu--permanente' : ''} ${open ? 'side-menu--open' : ''}`}>
        <div className="side-menu__header">
          <div className="side-menu__logo">
            <img src={logoFluire} alt="Fluirê" className="side-menu__logo-img" />
          </div>
          <span className="side-menu__title">Fluirê</span>
        </div>
        <div className="side-menu__divider" />
        <nav className="side-menu__nav">
          {ITEMS.map((item) => {
            const active = location.pathname === item.path;
            return (
              <NavLink
                key={item.path}
                to={item.path}
                className={`side-menu__item ${active ? 'side-menu__item--active' : ''}`}
                onClick={handleNav}
              >
                <span className="material-icons-outlined">{item.icon}</span>
                <span>{item.label}</span>
              </NavLink>
            );
          })}
        </nav>
        <div className="side-menu__spacer" />
        <div className="side-menu__divider" />
        <button className="side-menu__item side-menu__logout" onClick={handleLogout}>
          <span className="material-icons">logout</span>
          <span>Sair</span>
        </button>
      </aside>
    </>
  );
}
