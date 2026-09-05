import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import Loading from '../components/Loading/Loading';
import { authRoutes } from './AuthNavigator';
import { appRoutes } from './AppNavigator';

export function ProtectedRoute({ children }) {
  const { autenticado, loading } = useAuth();

  if (loading) {
    return <Loading visivel texto="Carregando..." />;
  }

  if (!autenticado) {
    return <Navigate to="/login" replace />;
  }

  return children;
}

export function PublicRoute({ children }) {
  const { loading } = useAuth();

  if (loading) return null;

  return children;
}

export default function RootNavigator() {
  return (
    <BrowserRouter>
      <Routes>
        {authRoutes.map(({ path, Screen }) => (
          <Route
            key={path}
            path={path}
            element={<PublicRoute><Screen /></PublicRoute>}
          />
        ))}

        {appRoutes.map(({ path, Screen }) => (
          <Route
            key={path}
            path={path}
            element={<ProtectedRoute><Screen /></ProtectedRoute>}
          />
        ))}

        <Route path="*" element={<Navigate to="/login" replace />} />
      </Routes>
    </BrowserRouter>
  );
}
