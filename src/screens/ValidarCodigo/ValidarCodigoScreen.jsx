import { useState, useEffect, useRef, useCallback } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import AuthLayout from '../../components/AuthLayout/AuthLayout';
import InputPadrao from '../../components/InputPadrao/InputPadrao';
import BotaoPrimario from '../../components/BotaoPrimario/BotaoPrimario';
import Loading from '../../components/Loading/Loading';

const TIMER_DURATION = 120; // 2 minutos em segundos

function formatTimer(seconds) {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}:${s.toString().padStart(2, '0')}`;
}

export default function ValidarCodigoScreen() {
  const location = useLocation();
  const emailFromState = location.state?.email || '';
  const [codigo, setCodigo] = useState('');
  const [senha, setSenha] = useState('');
  const [confirm, setConfirm] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const { validarCodigoAlterarSenha, recuperarSenha, erro, limparErro } = useAuth();
  const navigate = useNavigate();
  const [showToast, setShowToast] = useState(false);
  const [toastExit, setToastExit] = useState(false);

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
    if (!emailFromState || reenviando || showToast) return;
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
    if (senha !== confirm || showToast) return;
    limparErro();
    setIsLoading(true);
    try {
      const ok = await validarCodigoAlterarSenha(emailFromState, codigo, senha);
      if (ok) {
        if (intervalRef.current) clearInterval(intervalRef.current);
        setShowToast(true);
        // Inicia a animação de saída um pouco antes de redirecionar
        setTimeout(() => {
          setToastExit(true);
        }, 3200);
        // Redireciona após ~3.6 segundos (dentro do intervalo de 3 a 4s)
        setTimeout(() => {
          navigate('/login', { replace: true });
        }, 3600);
        return;
      }
    } finally {
      setIsLoading(false);
    }
  };

  const timerPercent = (timer / TIMER_DURATION) * 100;

  return (
    <>
      {showToast && (
        <div className={`toast-sucesso ${toastExit ? 'toast-sucesso--hide' : ''}`} role="status" aria-live="polite">
          <span className="material-icons toast-sucesso__icone">check_circle</span>
          <span className="toast-sucesso__texto">Senha alterada com sucesso!</span>
        </div>
      )}

      <AuthLayout
        titulo="Alterar senha"
        subtitulo="Digite o código e nova senha"
        rodape={
          timerExpirado ? (
            <span
              className="auth-layout__link"
              onClick={handleReenviar}
              style={{ opacity: (reenviando || showToast) ? 0.5 : 1 }}
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
        }
      >
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
          <InputPadrao
            label="Código de 6 dígitos"
            hint="123456"
            value={codigo}
            onChange={(e) => setCodigo(e.target.value)}
            icone="security"
            type="text"
            disabled={showToast}
          />
          <InputPadrao
            label="Nova senha"
            hint="••••••••"
            value={senha}
            onChange={(e) => setSenha(e.target.value)}
            icone="lock"
            obscureText
            disabled={showToast}
          />
          <InputPadrao
            label="Confirmar senha"
            hint="••••••••"
            value={confirm}
            onChange={(e) => setConfirm(e.target.value)}
            icone="lock"
            obscureText
            disabled={showToast}
          />
          {erro && <p style={{ color: 'var(--color-erro)', fontSize: 13, textAlign: 'center' }}>{erro}</p>}
          <BotaoPrimario texto="Alterar senha" tipo="submit" carregando={isLoading} disabled={timerExpirado || showToast} />
        </form>
      </AuthLayout>

      <Loading visivel={isLoading} texto="Alterando senha..." />
    </>
  );
}

