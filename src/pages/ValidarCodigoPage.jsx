import { useState, useEffect, useRef, useCallback } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import AuthLayout from '../components/AuthLayout';
import InputPadrao from '../components/InputPadrao';
import BotaoPrimario from '../components/BotaoPrimario';
import LoadingOverlay from '../components/LoadingOverlay';

const TIMER_DURATION = 120; // 2 minutos em segundos

function formatTimer(seconds) {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}:${s.toString().padStart(2, '0')}`;
}

export default function ValidarCodigoPage() {
  const location = useLocation();
  const emailFromState = location.state?.email || '';
  const [codigo, setCodigo] = useState('');
  const [senha, setSenha] = useState('');
  const [confirm, setConfirm] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const { validarCodigoAlterarSenha, recuperarSenha, erro, limparErro } = useAuth();
  const navigate = useNavigate();
  const [sucesso, setSucesso] = useState(false);

  // Timer de 2 minutos
  const [timer, setTimer] = useState(TIMER_DURATION);
  const [timerExpirado, setTimerExpirado] = useState(false);
  const [reenviando, setReenviando] = useState(false);
  const intervalRef = useRef(null);

  const startTimer = useCallback(() => {
    setTimer(TIMER_DURATION);
    setTimerExpirado(false);
    if (intervalRef.current) clearInterval(intervalRef.current);
    intervalRef.current = setInterval(() => {
      setTimer((prev) => {
        if (prev <= 1) {
          clearInterval(intervalRef.current);
          intervalRef.current = null;
          setTimerExpirado(true);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
  }, []);

  useEffect(() => {
    startTimer();
    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current);
    };
  }, [startTimer]);

  const handleReenviar = async () => {
    if (!emailFromState || reenviando) return;
    limparErro();
    setReenviando(true);
    try {
      const ok = await recuperarSenha(emailFromState);
      if (ok) {
        startTimer();
      }
    } finally {
      setReenviando(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (senha !== confirm) return;
    limparErro();
    setIsLoading(true);
    try {
      const ok = await validarCodigoAlterarSenha(emailFromState, codigo, senha);
      if (ok) {
        if (intervalRef.current) clearInterval(intervalRef.current);
        setSucesso(true);
        setTimeout(() => {
          navigate('/login', { replace: true });
        }, 4000);
        return;
      }
    } finally {
      setIsLoading(false);
    }
  };

  const timerPercent = (timer / TIMER_DURATION) * 100;

  return (
    <>
      <AuthLayout
        titulo={sucesso ? '' : 'Alterar senha'}
        subtitulo={sucesso ? '' : 'Digite o código e nova senha'}
        rodape={
          sucesso ? null : (
            timerExpirado ? (
              <span
                className="auth-layout__link"
                onClick={handleReenviar}
                style={{ opacity: reenviando ? 0.5 : 1 }}
              >
                Código expirado. <span className="auth-layout__link-bold">
                  {reenviando ? 'Reenviando...' : 'Reenviar código'}
                </span>
              </span>
            ) : (
              <span className="auth-layout__link" onClick={() => navigate(-1)}>
                Não recebeu o código? <span className="auth-layout__link-bold">Solicitar novamente</span>
              </span>
            )
          )
        }
      >
        {sucesso ? (
          /* ===== TELA DE SUCESSO ===== */
          <div className="feedback-card fade-slide-up" role="alert" aria-live="assertive">
            <div className="feedback-card__icon feedback-card__icon--sucesso">
              <span className="material-icons">check_circle</span>
            </div>
            <h2 className="feedback-card__titulo">Senha alterada!</h2>
            <p className="feedback-card__descricao">
              Sua senha foi alterada com sucesso.
            </p>
            <div className="feedback-card__divider" />
            <div className="feedback-card__info-row">
              <span className="material-icons feedback-card__info-icon">mail</span>
              <p className="feedback-card__info-text">
                Um e-mail de confirmação foi enviado.
              </p>
            </div>
            <div className="feedback-card__redirect">
              <div className="feedback-card__spinner" />
              <span>Redirecionando para o login...</span>
            </div>
          </div>
        ) : (
          /* ===== FORMULÁRIO ===== */
          <>
            {/* Timer visual */}
            <div className="timer-container" aria-label={`Tempo restante: ${formatTimer(timer)}`}>
              <div className="timer-bar">
                <div
                  className={`timer-bar__fill ${timerExpirado ? 'timer-bar__fill--expired' : ''}`}
                  style={{ width: `${timerPercent}%` }}
                />
              </div>
              <div className={`timer-text ${timerExpirado ? 'timer-text--expired' : ''}`}>
                <span className="material-icons" style={{ fontSize: 16 }}>
                  {timerExpirado ? 'timer_off' : 'timer'}
                </span>
                <span>
                  {timerExpirado ? 'Código expirado' : `Código válido por ${formatTimer(timer)}`}
                </span>
              </div>
            </div>

            <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-lg)', marginTop: 'var(--sp-lg)' }}>
              <InputPadrao label="Código de 6 dígitos" hint="123456" value={codigo} onChange={(e) => setCodigo(e.target.value)} icone="security" type="text" />
              <InputPadrao label="Nova senha" hint="••••••••" value={senha} onChange={(e) => setSenha(e.target.value)} icone="lock" obscureText />
              <InputPadrao label="Confirmar senha" hint="••••••••" value={confirm} onChange={(e) => setConfirm(e.target.value)} icone="lock" obscureText />
              {erro && <p style={{ color: 'var(--color-erro)', fontSize: 13, textAlign: 'center' }}>{erro}</p>}
              <BotaoPrimario texto="Alterar senha" tipo="submit" carregando={isLoading} disabled={timerExpirado} />
            </form>
          </>
        )}
      </AuthLayout>

      <LoadingOverlay visivel={isLoading} texto="Alterando senha..." />
    </>
  );
}
