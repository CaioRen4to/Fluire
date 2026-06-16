import api from './api';
import * as alunosService from './alunosService';
import * as aulasService from './aulasService';
import * as frequenciaService from './frequenciaService';

const DIAS_SEMANA = {
  1: 'segunda-feira', 2: 'terça-feira', 3: 'quarta-feira',
  4: 'quinta-feira', 5: 'sexta-feira', 6: 'sábado', 7: 'domingo',
};

export async function buscarDashboard() {
  try {
    const response = await api.get('/dashboard');
    if (response.status === 200 && response.data) {
      return parseDashboard(response.data);
    }
  } catch {
    // fallback abaixo
  }
  return await montarDashboardLocal();
}

function parseDashboard(json) {
  const data = json.data && typeof json.data === 'object' ? json.data : json;

  const totalAlunos = toInt(data.total_alunos ?? data.totalAlunos ?? 0);
  const totalAulas = toInt(data.total_aulas ?? data.totalAulas ?? 0);
  const alunosComFalta = toInt(data.total_alunos_com_falta ?? data.alunos_com_falta ?? data.alunosComFalta ?? data.faltas ?? 0);
  const alunosPresentes = toInt(data.alunos_presentes ?? data.alunosPresentes ?? 0);
  const alunosPresentesCalc = alunosPresentes > 0 ? alunosPresentes : Math.max(0, totalAlunos - alunosComFalta);
  const aulasHoje = toInt(data.aulas_hoje ?? data.aulasHoje ?? 0);
  const emAndamento = toInt(data.em_andamento ?? data.emAndamento ?? 0);
  const frequenciaMedia = toInt(data.frequencia_media ?? data.frequenciaMedia ?? data.media_frequencia ?? 0);

  return {
    totalAlunos,
    totalAulas,
    alunosPresentes: alunosPresentesCalc,
    aulasHoje,
    emAndamento,
    frequenciaMedia,
    weeklyFrequency: parseWeeklyFrequency(
      data.semana_frequencia ?? data.weekly_frequency ?? data.weeklyFrequency ??
      data.estatisticas_semanais ?? data.estatisticasSemanais ?? []
    ),
    todayClasses: parseTodayClasses(
      data.today_classes ?? data.todayClasses ?? data.proximas_aulas ?? data.proximasAulas ?? []
    ),
    alunosComFalta,
  };
}

function parseWeeklyFrequency(value) {
  if (!Array.isArray(value)) return [];
  return value.map((item) => ({
    day: (item.day || item.dia || '').toString(),
    value: parseFloat(item.value ?? item.valor ?? 0),
  }));
}

function parseTodayClasses(value) {
  if (!Array.isArray(value)) return [];
  return value.map((item) => ({
    title: (item.title || item.nome || 'Aula').toString(),
    teacher: (item.teacher || item.professor || 'Professor').toString(),
    time: (item.time || item.horario_inicio || '').toString(),
    students: item.students?.toString() || `${toInt(item.alunos ?? item.total_alunos)} alunos`,
    status: (item.status || 'ativa').toString(),
  }));
}

async function montarDashboardLocal() {
  const [alunos, aulas] = await Promise.all([
    alunosService.listar(),
    aulasService.listar(),
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

  const totalFreq = frequencias.length;
  const totalPresentes = frequencias.filter((f) => f.presente === 1).length;
  const media = totalFreq === 0 ? 0 : Math.round((totalPresentes / totalFreq) * 100);

  return {
    totalAlunos: alunos.length,
    totalAulas: aulas.length,
    alunosPresentes: presentesHoje,
    aulasHoje: aulasHoje.length,
    emAndamento: aulasHoje.length > 0 ? 1 : 0,
    frequenciaMedia: media,
    weeklyFrequency: frequenciaSemanalDeDados(frequencias),
    todayClasses: aulasHoje.map((a) => ({
      title: a.nome,
      teacher: a.professorNome || 'Professor',
      time: `${a.horarioInicio} - ${a.horarioFim}`,
      students: `${a.alunoIds.length} alunos`,
      status: 'ativa',
    })),
    alunosComFalta: frequencias.filter((f) => f.presente === 0).length,
  };
}

function frequenciaSemanalDeDados(frequencias) {
  const dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
  const contagem = [0, 0, 0, 0, 0, 0, 0];

  for (const f of frequencias) {
    if (f.presente !== 1) continue;
    if (!f.dataPresenca) continue;
    try {
      const data = new Date(f.dataPresenca);
      const idx = data.getDay() === 0 ? 6 : data.getDay() - 1;
      if (idx >= 0 && idx < 7) contagem[idx]++;
    } catch { /* ignore */ }
  }

  const max = Math.max(...contagem, 0);
  return dias.map((day, i) => ({
    day,
    value: max === 0 ? 0 : (contagem[i] / max) * 80 + 20,
  }));
}

function toInt(value) {
  if (value == null) return 0;
  const n = parseInt(value, 10);
  return isNaN(n) ? 0 : n;
}
