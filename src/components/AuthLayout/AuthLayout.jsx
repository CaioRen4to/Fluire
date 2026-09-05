import logoFluire from '../../assets/images/logo-fluire.png';
import './AuthLayout.css';

export default function AuthLayout({ titulo, subtitulo, children, rodape }) {
  return (
    <div className="auth-layout">
      <div className="auth-layout__card fade-slide-up">
        <div className="auth-layout__logo">
          <img src={logoFluire} alt="Fluirê Studio de Pilates" className="auth-layout__logo-img" />
        </div>
        <h1 className="auth-layout__titulo">{titulo}</h1>
        <p className="auth-layout__subtitulo">{subtitulo}</p>
        <div className="auth-layout__form">
          {children}
        </div>
        {rodape && <div className="auth-layout__rodape">{rodape}</div>}
      </div>
    </div>
  );
}
