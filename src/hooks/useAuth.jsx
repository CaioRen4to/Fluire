import { createContext, useContext, useState, useEffect, useCallback } from 'react';
import * as authService from '../services/authService';
import { isAuthenticated } from '../services/api';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [usuario, setUsuario] = useState(null);
  const [loading, setLoading] = useState(true);
  const [erro, setErro] = useState(null);

  // Carrega sessão salva ao inicializar
  useEffect(() => {
    const saved = authService.carregarUsuarioSalvo();
    if (saved && isAuthenticated()) {
      setUsuario(saved);
    }
    setLoading(false);
  }, []);

  const login = useCallback(async (email, senha) => {
    setLoading(true);
    setErro(null);
    try {
      const user = await authService.login(email, senha);
      setUsuario(user);
      setLoading(false);
      return true;
    } catch (e) {
      setErro(e.message);
      setLoading(false);
      return false;
    }
  }, []);

  const cadastrar = useCallback(async (nome, email, senha) => {
    setLoading(true);
    setErro(null);
    try {
      const user = await authService.cadastrar(nome, email, senha);
      setUsuario(user);
      setLoading(false);
      return true;
    } catch (e) {
      setErro(e.message);
      setLoading(false);
      return false;
    }
  }, []);

  const recuperarSenha = useCallback(async (email) => {
    setLoading(true);
    setErro(null);
    try {
      await authService.recuperarSenha(email);
      setLoading(false);
      return true;
    } catch (e) {
      setErro(e.message);
      setLoading(false);
      return false;
    }
  }, []);

  const validarCodigoAlterarSenha = useCallback(async (email, codigo, novaSenha) => {
    setLoading(true);
    setErro(null);
    try {
      await authService.validarCodigoAlterarSenha(email, codigo, novaSenha);
      setLoading(false);
      return true;
    } catch (e) {
      setErro(e.message);
      setLoading(false);
      return false;
    }
  }, []);

  const logout = useCallback(() => {
    authService.logout();
    setUsuario(null);
    setErro(null);
  }, []);

  const limparErro = useCallback(() => {
    setErro(null);
  }, []);

  const value = {
    usuario,
    loading,
    erro,
    autenticado: !!usuario,
    login,
    cadastrar,
    recuperarSenha,
    validarCodigoAlterarSenha,
    logout,
    limparErro,
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth deve ser usado dentro de um AuthProvider');
  }
  return context;
}

export default AuthContext;
