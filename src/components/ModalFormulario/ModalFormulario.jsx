import { useEffect } from 'react';
import './ModalFormulario.css';

/**
 * ModalFormulario
 * 
 * Props:
 *  - titulo: string
 *  - aberto: boolean
 *  - onFechar: () => void
 *  - children: conteúdo rolável do formulário (sem o botão de submit)
 *  - rodape: ReactNode — botão de submit ou ações fixas no rodapé (SEMPRE visíveis)
 */
export default function ModalFormulario({ titulo, aberto, onFechar, children, rodape }) {
  useEffect(() => {
    if (aberto) document.body.style.overflow = 'hidden';
    else document.body.style.overflow = '';
    return () => { document.body.style.overflow = ''; };
  }, [aberto]);

  if (!aberto) return null;

  return (
    <div className="modal-overlay" onClick={onFechar}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h2 className="modal-titulo">{titulo}</h2>
          <button className="modal-fechar" onClick={onFechar}>
            <span className="material-icons">close</span>
          </button>
        </div>

        {/* Região rolável — apenas o body */}
        <div className="modal-body">
          {children}
        </div>

        {/* Footer fixo — botão de submit sempre visível */}
        {rodape && (
          <div className="modal-footer">
            {rodape}
          </div>
        )}
      </div>
    </div>
  );
}
