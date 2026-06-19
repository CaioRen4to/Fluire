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
  const [showToast, setShowToast] = useState(false);
  const [toastExit, setToastExit] = useState(false);
  const { recuperarSenha, erro, limparErro } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!email.trim() || showToast) return;
    limparErro();
    setIsLoading(true);
    try {
      const ok = await recuperarSenha(email);
      if (ok) {
        setShowToast(true);
        // Inicia a animação de saída um pouco antes de redirecionar
        setTimeout(() => {
          setToastExit(true);
        }, 3200);
        // Redireciona após ~3.6 segundos (dentro do intervalo de 3 a 4s)
        setTimeout(() => {
          navigate('/validar-codigo', { state: { email } });
        }, 3600);
      }
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <>
      {showToast && (
        <div className={`toast-sucesso ${toastExit ? 'toast-sucesso--hide' : ''}`} role="status" aria-live="polite">
          <span className="material-icons toast-sucesso__icone">check_circle</span>
          <span className="toast-sucesso__texto">E-mail enviado com sucesso!</span>
        </div>
      )}

      <AuthLayout
        titulo="Recuperar senha"
        subtitulo="Digite seu e-mail para receber o código"
        rodape={
          <span className="auth-layout__link" onClick={() => navigate(-1)}>
            Lembrou sua senha? <span className="auth-layout__link-bold">Voltar ao login</span>
          </span>
        }
      >
        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-lg)' }}>
          <InputPadrao
            label="E-mail"
            hint="seu@email.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            icone="mail"
            keyboardType="email"
            disabled={showToast}
          />
          {erro && <p style={{ color: 'var(--color-erro)', fontSize: 13, textAlign: 'center' }}>{erro}</p>}
          <BotaoPrimario texto="Enviar código" tipo="submit" carregando={isLoading} disabled={showToast} />
        </form>
      </AuthLayout>

      <LoadingOverlay visivel={isLoading} texto="Enviando código..." />
    </>
  );
}
