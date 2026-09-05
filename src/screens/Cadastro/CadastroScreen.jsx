import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import AuthLayout from '../../components/AuthLayout/AuthLayout';
import InputPadrao from '../../components/InputPadrao/InputPadrao';
import BotaoPrimario from '../../components/BotaoPrimario/BotaoPrimario';
import Loading from '../../components/Loading/Loading';

export default function CadastroScreen() {
  const [nome, setNome] = useState('');
  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const [confirm, setConfirm] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const { cadastrar, erro, limparErro } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    limparErro();
    if (senha !== confirm) return;
    setIsLoading(true);
    try {
      const ok = await cadastrar(nome, email, senha);
      if (ok) {
        navigate('/dashboard', { replace: true });
        return;
      }
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <>
      <AuthLayout
        titulo="Criar sua conta"
        subtitulo="Preencha os dados para começar"
        rodape={
          <span className="auth-layout__link" onClick={() => navigate('/login', { replace: true })}>
            Já tem conta? <span className="auth-layout__link-bold">Entrar</span>
          </span>
        }
      >
        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-lg)' }}>
          <InputPadrao label="Nome completo" value={nome} onChange={(e) => setNome(e.target.value)} icone="person" />
          <InputPadrao label="E-mail" value={email} onChange={(e) => setEmail(e.target.value)} icone="mail" keyboardType="email" />
          <InputPadrao label="Senha" value={senha} onChange={(e) => setSenha(e.target.value)} icone="lock" obscureText />
          <InputPadrao label="Confirmar senha" value={confirm} onChange={(e) => setConfirm(e.target.value)} icone="lock" obscureText />
          {erro && <p style={{ color: 'var(--color-erro)', fontSize: 13, textAlign: 'center' }}>{erro}</p>}
          <BotaoPrimario texto="Criar conta" tipo="submit" carregando={isLoading} />
        </form>
      </AuthLayout>

      <Loading visivel={isLoading} texto="Criando conta..." />
    </>
  );
}

