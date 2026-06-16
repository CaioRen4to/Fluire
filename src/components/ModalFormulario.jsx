import { useEffect } from 'react';
import './ModalFormulario.css';

export default function ModalFormulario({ titulo, aberto, onFechar, children }) {
  useEffect(() => {
    if (aberto) document.body.style.overflow = 'hidden';
    else document.body.style.overflow = '';
    return () => { document.body.style.overflow = ''; };
  }, [aberto]);

  if (!aberto) return null;

  return (
    <div className="modal-overlay" onClick={onFechar}>
      <div className="modal-content fade-slide-up" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h2 className="modal-titulo">{titulo}</h2>
          <button className="modal-fechar" onClick={onFechar}>
            <span className="material-icons">close</span>
          </button>
        </div>
        <div className="modal-body">{children}</div>
      </div>
    </div>
  );
}
