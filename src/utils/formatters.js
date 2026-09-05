import { DIAS_SEMANA } from '../constants/diasSemana';
import { STATUS_AULA } from '../constants/status';

export function diaSemanaAtual() {
  const dow = new Date().getDay();
  return DIAS_SEMANA[dow === 0 ? 7 : dow];
}

export function inicial(nome) {
  return nome && nome.length > 0 ? nome[0].toUpperCase() : '?';
}

export function frequenciaPercentual(presencas, faltas) {
  const total = presencas + faltas;
  if (total === 0) return 0;
  return Math.round((presencas / total) * 100);
}

export function normalizarDia(dia) {
  return (dia || '').toLowerCase().trim()
    .replace(/á/g, 'a').replace(/é/g, 'e').replace(/í/g, 'i')
    .replace(/ó/g, 'o').replace(/ú/g, 'u').replace(/ç/g, 'c');
}

export function isHorarioEmAndamento(inicio, fim) {
  if (!inicio || !fim) return false;
  try {
    const parseTime = (timeStr) => {
      const parts = timeStr.trim().split(':').map(Number);
      return (parts[0] || 0) * 60 + (parts[1] || 0);
    };
    const startMin = parseTime(inicio);
    const endMin = parseTime(fim);
    const now = new Date();
    const currentMin = now.getHours() * 60 + now.getMinutes();
    return currentMin >= startMin && currentMin <= endMin;
  } catch {
    return false;
  }
}

export function statusLabel(status) {
  return STATUS_AULA[status] || 'Próxima';
}
