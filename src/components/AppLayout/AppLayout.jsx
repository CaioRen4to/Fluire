import { useState, useEffect } from 'react';
import BottomNav from '../BottomNav/BottomNav';
import SideMenu from '../SideMenu/SideMenu';
import './AppLayout.css';

export default function AppLayout({ titulo, children, mostrarBottomNav = true, acaoFlutuante }) {
  const [menuOpen, setMenuOpen] = useState(false);
  const [isDesktop, setIsDesktop] = useState(window.innerWidth >= 900);

  useEffect(() => {
    const handler = () => setIsDesktop(window.innerWidth >= 900);
    window.addEventListener('resize', handler);
    return () => window.removeEventListener('resize', handler);
  }, []);

  return (
    <div className={`app-layout ${isDesktop ? 'app-layout--desktop' : ''}`}>
      {/* Sidebar permanente no desktop */}
      {isDesktop && mostrarBottomNav && (
        <SideMenu permanente open />
      )}

      {/* Sidebar drawer no mobile */}
      {!isDesktop && mostrarBottomNav && (
        <SideMenu open={menuOpen} onClose={() => setMenuOpen(false)} />
      )}

      <div className="app-layout__main">
        {/* Header */}
        <header className="app-layout__header">
          {!isDesktop && mostrarBottomNav && (
            <button className="app-layout__menu-btn" onClick={() => setMenuOpen(true)}>
              <span className="material-icons">menu</span>
            </button>
          )}
          <h1 className="app-layout__title">{titulo}</h1>
          <div className="app-layout__header-spacer" />
        </header>

        {/* Content */}
        <main className="app-layout__content">
          {children}
        </main>

        {/* FAB */}
        {acaoFlutuante && (
          <div className="app-layout__fab">
            {acaoFlutuante}
          </div>
        )}
      </div>

      {/* Bottom Nav mobile */}
      {mostrarBottomNav && <BottomNav />}
    </div>
  );
}
