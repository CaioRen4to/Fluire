import logoIcon from '../assets/logo-icon.png';
import logoWordmark from '../assets/logo-wordmark.png';
import './LoadingOverlay.css';

export default function LoadingOverlay({ texto = 'Aguarde...', visivel = true }) {
  if (!visivel) return null;

  return (
    <div className="loading-overlay" role="status" aria-label="Carregando">
      <div className="loading-overlay__content">
        <div className="loading-overlay__icon-wrap">
          <img src={logoIcon} alt="" className="loading-overlay__icon" />
          <div className="loading-overlay__ring" />
        </div>
        <img src={logoWordmark} alt="Fluirê" className="loading-overlay__wordmark" />
        <p className="loading-overlay__texto">{texto}</p>
      </div>
    </div>
  );
}
