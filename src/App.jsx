import { AuthProvider } from './contexts/AuthContext';
import RootNavigator from './navigation/RootNavigator';
import './App.css';

export default function App() {
  return (
    <AuthProvider>
      <RootNavigator />
    </AuthProvider>
  );
}
