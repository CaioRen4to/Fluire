import LoginScreen from '../screens/Login/LoginScreen';
import CadastroScreen from '../screens/Cadastro/CadastroScreen';
import RecuperarSenhaScreen from '../screens/RecuperarSenha/RecuperarSenhaScreen';
import ValidarCodigoScreen from '../screens/ValidarCodigo/ValidarCodigoScreen';

export const authRoutes = [
  { path: '/login', Screen: LoginScreen },
  { path: '/cadastro', Screen: CadastroScreen },
  { path: '/recuperar-senha', Screen: RecuperarSenhaScreen },
  { path: '/validar-codigo', Screen: ValidarCodigoScreen },
];
