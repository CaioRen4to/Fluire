import logoIcon from '../../assets/images/logo-icon.png';
import './Loading.css';

export default function Loading({ texto = 'Aguarde...', visivel = true }) {
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

