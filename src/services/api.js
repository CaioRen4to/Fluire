import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://127.0.0.1:5000',
  timeout: 30000,
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
});

// --- Helpers de sessão ---

export function getToken() {
  return localStorage.getItem('api_token');
}

export function getUserId() {
  const id = localStorage.getItem('api_user_id');
  return id ? parseInt(id, 10) : null;
}

export function setSession(token, userId) {
  localStorage.setItem('api_token', token);
  localStorage.setItem('api_user_id', String(userId));
}

export function clearSession() {
  localStorage.removeItem('api_token');
  localStorage.removeItem('api_user_id');
  localStorage.removeItem('api_usuario');
}

export function isAuthenticated() {
  return !!getToken();
}

// --- Interceptor de request: injeta Bearer token ---

api.interceptors.request.use((config) => {
  const token = getToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// --- Interceptor de response: trata erros ---

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      clearSession();
      // Redireciona para login se não estiver lá
      if (window.location.pathname !== '/login') {
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

// --- Helper para extrair mensagem de erro ---

export function extrairErro(error, fallback = 'Erro na requisição') {
  if (error.response?.data) {
    const data = error.response.data;
    if (typeof data === 'object') {
      return data.erro || data.error || data.message || data.mensagem || fallback;
    }
    if (typeof data === 'string' && data.trim()) {
      // Remove tags HTML se houver
      const semTags = data.replace(/<[^>]*>/g, '').trim();
      return semTags || fallback;
    }
  }
  if (error.message) {
    return error.message;
  }
  return fallback;
}

export default api;
