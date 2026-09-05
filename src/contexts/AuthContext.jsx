import { createContext, useState, useEffect, useCallback } from 'react';
import * as authService from '../services/authService';
import { isAuthenticated } from '../services/api';

export const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [usuario, setUsuario] = useState(null);
  const [loading, setLoading] = useState(true);
  const [erro, setErro] = useState(null);

  useEffect(() => {
    const saved = authService.carregarUsuarioSalvo();
    if (saved && isAuthenticated()) {
      setUsuario(saved);
    }
    setLoading(false);
  }, []);

  const login = useCallback(async (email, senha) => {
    setErro(null);
    try {
      const user = await authService.login(email, senha);
      setUsuario(user);
      return true;
    } catch (e) {
      setErro(e.message);
      return false;
    }
  }, []);

  const cadastrar = useCallback(async (nome, email, senha) => {
    setErro(null);
    try {
      const user = await authService.cadastrar(nome, email, senha);
      setUsuario(user);
      return true;
    } catch (e) {
      setErro(e.message);
      return false;
    }
  }, []);

  const recuperarSenha = useCallback(async (email) => {
    setErro(null);
    try {
      await authService.recuperarSenha(email);
      return true;
    } catch (e) {
      setErro(e.message);
      return false;
    }
  }, []);

  const validarCodigoAlterarSenha = useCallback(async (email, codigo, novaSenha) => {
    setErro(null);
    try {
      await authService.validarCodigoAlterarSenha(email, codigo, novaSenha);
      return true;
    } catch (e) {
      setErro(e.message);
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
