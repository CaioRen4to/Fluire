import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import AuthLayout from '../components/AuthLayout';
import InputPadrao from '../components/InputPadrao';
import BotaoPrimario from '../components/BotaoPrimario';
import LoadingOverlay from '../components/LoadingOverlay';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const { login, erro, limparErro } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    limparErro();
    setIsLoading(true);
    try {
      const ok = await login(email, senha);
      if (ok) {
        navigate('/dashboard', { replace: true });
        return;
      }
      setIsLoading(false);
    } catch (error) {
      setIsLoading(false);
    }
  };

  return (
    <>
      <AuthLayout
        titulo="Bem-vindo ao Fluirê"
        subtitulo="Entre para continuar"
        rodape={
          <span className="auth-layout__link" onClick={() => navigate('/cadastro')}>
            Não tem conta? <span className="auth-layout__link-bold">Cadastre-se</span>
          </span>
        }
      >
        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-lg)' }}>
          <InputPadrao label="E-mail" hint="seu@email.com" value={email} onChange={(e) => setEmail(e.target.value)} icone="mail" keyboardType="email" />
          <InputPadrao label="Senha" hint="••••••••" value={senha} onChange={(e) => setSenha(e.target.value)} icone="lock" obscureText />
          <div style={{ textAlign: 'right' }}>
            <span className="auth-layout__link" onClick={() => navigate('/recuperar-senha')} style={{ fontSize: 13, color: '#999', fontWeight: 500, cursor: 'pointer' }}>
              Esqueceu a senha?
            </span>
          </div>
          {erro && <p style={{ color: 'var(--color-erro)', fontSize: 13, textAlign: 'center' }}>{erro}</p>}
          <BotaoPrimario texto="Entrar" tipo="submit" carregando={isLoading} />
        </form>
      </AuthLayout>

      <LoadingOverlay visivel={isLoading} texto="Entrando..." />
    </>
  );
}
