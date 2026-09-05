import DashboardScreen from '../screens/Dashboard/DashboardScreen';
import AlunosScreen from '../screens/Alunos/AlunosScreen';
import DetalheAlunoScreen from '../screens/DetalheAluno/DetalheAlunoScreen';
import AulasScreen from '../screens/Aulas/AulasScreen';
import DetalheAulaScreen from '../screens/DetalheAula/DetalheAulaScreen';
import FrequenciaScreen from '../screens/Frequencia/FrequenciaScreen';
import HistoricoScreen from '../screens/Historico/HistoricoScreen';
import PerfilScreen from '../screens/Perfil/PerfilScreen';
import ProfessoresScreen from '../screens/Professores/ProfessoresScreen';

export const appRoutes = [
  { path: '/dashboard', Screen: DashboardScreen },
  { path: '/alunos', Screen: AlunosScreen },
  { path: '/alunos/:id', Screen: DetalheAlunoScreen },
  { path: '/aulas', Screen: AulasScreen },
  { path: '/aulas/:id', Screen: DetalheAulaScreen },
  { path: '/frequencia', Screen: FrequenciaScreen },
  { path: '/frequencia/:aulaId', Screen: FrequenciaScreen },
  { path: '/historico', Screen: HistoricoScreen },
  { path: '/perfil', Screen: PerfilScreen },
  { path: '/professores', Screen: ProfessoresScreen },
];
