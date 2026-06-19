import api from './api';
import * as alunosService from './alunosService';
import * as aulasService from './aulasService';
import * as frequenciaService from './frequenciaService';

const DIAS_SEMANA = {
  1: 'segunda-feira', 2: 'terça-feira', 3: 'quarta-feira',
  4: 'quinta-feira', 5: 'sexta-feira', 6: 'sábado', 7: 'domingo',
};

export async function buscarDashboard() {
  // Ignora o endpoint /dashboard do backend (conforme Regra de Ouro) e faz o cálculo 100% no front-end
  return await montarDashboardLocal();
}

function getInicioFimDaSemanaAtual() {
  const now = new Date();
  // Considerando a semana de Segunda a Domingo
  const dayOfWeek = now.getDay() === 0 ? 6 : now.getDay() - 1; // Seg=0, Dom=6
  const inicioSemana = new Date(now);
  inicioSemana.setDate(now.getDate() - dayOfWeek);
  inicioSemana.setHours(0, 0, 0, 0);

  const fimSemana = new Date(inicioSemana);
  fimSemana.setDate(inicioSemana.getDate() + 6);
  fimSemana.setHours(23, 59, 59, 999);

  return { inicioSemana, fimSemana };
}

async function montarDashboardLocal() {
  const [alunos, aulas] = await Promise.all([
    alunosService.listar().catch(() => []),
    aulasService.listar().catch(() => []),
  ]);

  let frequencias = [];
  try {
    frequencias = await frequenciaService.listar();
  } catch { /* ignore */ }

  const hoje = new Date();
  const diaSemanaTexto = DIAS_SEMANA[hoje.getDay() === 0 ? 7 : hoje.getDay()];
  const aulasHoje = aulas.filter((a) =>
    a.diaSemana.toLowerCase().trim() === diaSemanaTexto
  );

  const hojeStr = `${hoje.getFullYear()}-${String(hoje.getMonth() + 1).padStart(2, '0')}-${String(hoje.getDate()).padStart(2, '0')}`;
  const presentesHoje = frequencias.filter((f) =>
    f.dataPresenca.startsWith(hojeStr) && f.presente === 1
  ).length;

  // Lógica da Média Semanal Real (apenas da semana atual)
  const { inicioSemana, fimSemana } = getInicioFimDaSemanaAtual();
  
  const frequenciasDaSemana = frequencias.filter((f) => {
    if (!f.dataPresenca) return false;
    const d = new Date(f.dataPresenca + 'T00:00:00');
    return d >= inicioSemana && d <= fimSemana;
  });

  const totalMarcacoesNaSemana = frequenciasDaSemana.length;
  const presencasNaSemana = frequenciasDaSemana.filter((f) => f.presente === 1).length;
  const faltasNaSemana = frequenciasDaSemana.filter((f) => f.presente === 0).length;
  const frequenciaMedia = totalMarcacoesNaSemana === 0 ? 0 : Math.round((presencasNaSemana / totalMarcacoesNaSemana) * 100);

  return {
    totalAlunos: alunos.length,
    totalAulas: aulas.length,
    alunosPresentes: presentesHoje,
    aulasHoje: aulasHoje.length,
    emAndamento: 0, // Será calculado precisamente no DashboardPage.jsx
    frequenciaMedia: frequenciaMedia,
    weeklyFrequency: frequenciaSemanalDeAulas(aulas),
    todayClasses: aulasHoje.map((a) => ({
      id: a.id,
      title: a.nome,
      teacher: a.professorNome || 'Professor',
      time: `${a.horarioInicio} - ${a.horarioFim}`,
      horarioInicio: a.horarioInicio,
      horarioFim: a.horarioFim,
      alunoIds: a.alunoIds || [],
      students: `${(a.alunoIds || []).length} alunos`,
      status: 'ativa',
    })),
    alunosComFalta: faltasNaSemana,
  };
}

function frequenciaSemanalDeAulas(aulas) {
  const diasNomes = ['segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', 'sexta-feira', 'sábado', 'domingo'];
  const diasSiglas = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
  const contagemSemana = [0, 0, 0, 0, 0, 0, 0];

  for (const aula of aulas) {
    const diaNorm = (aula.diaSemana || '').toLowerCase().trim();
    const idx = diasNomes.indexOf(diaNorm);
    if (idx !== -1) {
      contagemSemana[idx]++;
    }
  }

  const max = Math.max(...contagemSemana, 0);
  return diasSiglas.map((day, i) => ({
    day,
    value: max === 0 ? 0 : (contagemSemana[i] / max) * 80 + 20, // Altura visual da barra (20% a 100%)
    count: contagemSemana[i] // Valor matemático real da quantidade de aulas no dia
  }));
}
