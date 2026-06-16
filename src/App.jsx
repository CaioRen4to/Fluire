import { AuthProvider } from './hooks/useAuth';
import AppRoutes from './routes/AppRoutes';
import './App.css';

export default function App() {
  return (
    <AuthProvider>
      <AppRoutes />
    </AuthProvider>
  );
}
