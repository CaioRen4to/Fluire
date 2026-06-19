import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import LoadingOverlay from '../components/LoadingOverlay';
import LoginPage from '../pages/LoginPage';
import CadastroPage from '../pages/CadastroPage';
import RecuperarSenhaPage from '../pages/RecuperarSenhaPage';
import ValidarCodigoPage from '../pages/ValidarCodigoPage';
import DashboardPage from '../pages/DashboardPage';
import AlunosPage from '../pages/AlunosPage';
import DetalheAlunoPage from '../pages/DetalheAlunoPage';
import AulasPage from '../pages/AulasPage';
import DetalheAulaPage from '../pages/DetalheAulaPage';
import FrequenciaPage from '../pages/FrequenciaPage';
import HistoricoPage from '../pages/HistoricoPage';
import PerfilPage from '../pages/PerfilPage';
import ProfessoresPage from '../pages/ProfessoresPage';

function ProtectedRoute({ children }) {
  const { autenticado, loading } = useAuth();

  if (loading) {
    return <LoadingOverlay visivel texto="Carregando..." />;
  }

  if (!autenticado) {
    return <Navigate to="/login" replace />;
  }

  return children;
}

function PublicRoute({ children }) {
  const { loading } = useAuth();

  if (loading) return null;

  return children;
}

export default function AppRoutes() {
  return (
    <BrowserRouter>
      <Routes>
        {/* Rotas Públicas */}
        <Route path="/login" element={<PublicRoute><LoginPage /></PublicRoute>} />
        <Route path="/cadastro" element={<PublicRoute><CadastroPage /></PublicRoute>} />
        <Route path="/recuperar-senha" element={<PublicRoute><RecuperarSenhaPage /></PublicRoute>} />
        <Route path="/validar-codigo" element={<PublicRoute><ValidarCodigoPage /></PublicRoute>} />

        {/* Rotas Protegidas */}
        <Route path="/dashboard" element={<ProtectedRoute><DashboardPage /></ProtectedRoute>} />
        <Route path="/alunos" element={<ProtectedRoute><AlunosPage /></ProtectedRoute>} />
        <Route path="/alunos/:id" element={<ProtectedRoute><DetalheAlunoPage /></ProtectedRoute>} />
        <Route path="/aulas" element={<ProtectedRoute><AulasPage /></ProtectedRoute>} />
        <Route path="/aulas/:id" element={<ProtectedRoute><DetalheAulaPage /></ProtectedRoute>} />
        <Route path="/frequencia" element={<ProtectedRoute><FrequenciaPage /></ProtectedRoute>} />
        <Route path="/frequencia/:aulaId" element={<ProtectedRoute><FrequenciaPage /></ProtectedRoute>} />
        <Route path="/historico" element={<ProtectedRoute><HistoricoPage /></ProtectedRoute>} />
        <Route path="/perfil" element={<ProtectedRoute><PerfilPage /></ProtectedRoute>} />
        <Route path="/professores" element={<ProtectedRoute><ProfessoresPage /></ProtectedRoute>} />

        {/* Fallback */}
        <Route path="*" element={<Navigate to="/login" replace />} />
      </Routes>
    </BrowserRouter>
  );
}
