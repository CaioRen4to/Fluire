import { NavLink, useLocation } from 'react-router-dom';
import './BottomNav.css';

const ITEMS = [
  { path: '/dashboard', icon: 'dashboard', iconActive: 'dashboard', label: 'Dashboard' },
  { path: '/alunos', icon: 'people_outline', iconActive: 'people', label: 'Alunos' },
  { path: '/aulas', icon: 'event_note', iconActive: 'event_note', label: 'Aulas' },
  { path: '/historico', icon: 'history', iconActive: 'history', label: 'Histórico' },
  { path: '/perfil', icon: 'person_outline', iconActive: 'person', label: 'Perfil' },
];

export default function BottomNav() {
  const location = useLocation();

  return (
    <nav className="bottom-nav">
      {ITEMS.map((item) => {
        const active = location.pathname === item.path;
        return (
          <NavLink key={item.path} to={item.path} className={`bottom-nav__item ${active ? 'bottom-nav__item--active' : ''}`}>
            <span className="material-icons">{active ? item.iconActive : item.icon}</span>
            <span className="bottom-nav__label">{item.label}</span>
          </NavLink>
        );
      })}
    </nav>
  );
}
