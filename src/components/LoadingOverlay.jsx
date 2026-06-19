import logoIcon from '../assets/logo-icon.png';
import './LoadingOverlay.css';

export default function LoadingOverlay({ texto = 'Aguarde...', visivel = true }) {
  if (!visivel) return null;

  return (
    <div className="loading-overlay" role="status" aria-label="Carregando">
      <div className="loading-overlay__content">
        <div className="loading-overlay__icon-wrap">
          <img src={logoIcon} alt="Fluirê" className="loading-overlay__icon" />
        </div>
        {texto && <p className="loading-overlay__texto">{texto}</p>}
      </div>
    </div>
  );
}

