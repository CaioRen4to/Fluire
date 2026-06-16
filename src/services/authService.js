import api, { extrairErro, setSession, clearSession, getUserId } from './api';

// --- Login ---
export async function login(email, senha) {
  try {
    const response = await api.post('/login', {
      email: email.trim(),
      senha,
    });

    const { usuario, token } = response.data;
    if (!usuario || !token) {
      throw new Error('Resposta de login inválida');
    }

    setSession(token, parseInt(usuario.id, 10));
    localStorage.setItem('api_usuario', JSON.stringify(usuario));

    return usuario;
  } catch (error) {
    throw new Error(extrairErro(error, 'Email ou senha incorretos'));
  }
}

// --- Cadastrar ---
export async function cadastrar(nome, email, senha) {
  try {
    await api.post('/usuarios', {
      nome: nome.trim(),
      email: email.trim(),
      senha,
    });

    // Auto-login após cadastro
    return await login(email, senha);
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao criar conta'));
  }
}

// --- Recuperar Senha ---
export async function recuperarSenha(email) {
  try {
    await api.post('/recuperar-senha', {
      email: email.trim(),
    });
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao recuperar senha'));
  }
}

// --- Validar Código e Alterar Senha ---
export async function validarCodigoAlterarSenha(email, codigo, novaSenha) {
  try {
    await api.post('/validar-codigo-alterar-senha', {
      email: email.trim(),
      codigo: codigo.trim(),
      nova_senha: novaSenha,
    });
  } catch (error) {
    throw new Error(extrairErro(error, 'Erro ao alterar senha'));
  }
}

// --- Logout ---
export function logout() {
  clearSession();
}

// --- Carregar sessão salva ---
export function carregarUsuarioSalvo() {
  try {
    const json = localStorage.getItem('api_usuario');
    if (json) {
      return JSON.parse(json);
    }
  } catch {
    // ignora
  }
  return null;
}
