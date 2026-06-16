import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import AuthLayout from '../components/AuthLayout';
import InputPadrao from '../components/InputPadrao';
import BotaoPrimario from '../components/BotaoPrimario';
import LoadingOverlay from '../components/LoadingOverlay';

export default function RecuperarSenhaPage() {
  const [email, setEmail] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const { recuperarSenha, erro, limparErro } = useAuth();
  const navigate = useNavigate();
  const [emailEnviado, setEmailEnviado] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!email.trim()) return;
    limparErro();
    setIsLoading(true);
    try {
      const ok = await recuperarSenha(email);
      if (ok) {
        setEmailEnviado(true);
        setTimeout(() => {
          navigate('/validar-codigo', { state: { email } });
        }, 4000);
      }
    } finally {
      setIsLoading(false);
    }
  };

  // Mascarar e-mail: ca***@gmail.com
  const emailMascarado = email
    ? email.replace(/^(.{2})(.*)(@.*)$/, (_, start, mid, domain) => start + '***' + domain)
    : '';

  return (
    <>
      <AuthLayout
        titulo={emailEnviado ? '' : 'Recuperar senha'}
        subtitulo={emailEnviado ? '' : 'Digite seu e-mail para receber o código'}
        rodape={
          emailEnviado ? null : (
            <span className="auth-layout__link" onClick={() => navigate(-1)}>
              Lembrou sua senha? <span className="auth-layout__link-bold">Voltar ao login</span>
            </span>
          )
        }
      >
        {emailEnviado ? (
          /* ===== TELA DE SUCESSO ===== */
          <div className="feedback-card fade-slide-up" role="status" aria-live="polite">
            <div className="feedback-card__icon feedback-card__icon--info">
              <span className="material-icons">mark_email_read</span>
            </div>
            <h2 className="feedback-card__titulo">Código enviado!</h2>
            <p className="feedback-card__descricao">
              Enviamos um código de recuperação para <strong>{emailMascarado}</strong>
            </p>
            <p className="feedback-card__hint">
              Verifique sua caixa de entrada e spam.
            </p>
            <div className="feedback-card__redirect">
              <div className="feedback-card__spinner" />
              <span>Redirecionando...</span>
            </div>
          </div>
        ) : (
          /* ===== FORMULÁRIO ===== */
          <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-lg)' }}>
            <InputPadrao label="E-mail" hint="seu@email.com" value={email} onChange={(e) => setEmail(e.target.value)} icone="mail" keyboardType="email" />
            {erro && <p style={{ color: 'var(--color-erro)', fontSize: 13, textAlign: 'center' }}>{erro}</p>}
            <BotaoPrimario texto="Enviar código" tipo="submit" carregando={isLoading} />
          </form>
        )}
      </AuthLayout>

      <LoadingOverlay visivel={isLoading} texto="Enviando código..." />
    </>
  );
}
