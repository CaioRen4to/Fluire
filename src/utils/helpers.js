// Dia da semana em texto
export const DIAS_SEMANA = {
  1: 'segunda-feira', 2: 'terça-feira', 3: 'quarta-feira',
  4: 'quinta-feira', 5: 'sexta-feira', 6: 'sábado', 7: 'domingo',
};

export const DIAS_SIGLAS = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

export const DIAS_NOMES = [
  'Segunda-feira', 'Terça-feira', 'Quarta-feira',
  'Quinta-feira', 'Sexta-feira', 'Sábado', 'Domingo',
];

// Obter dia da semana atual em texto
export function diaSemanaAtual() {
  const dow = new Date().getDay();
  return DIAS_SEMANA[dow === 0 ? 7 : dow];
}

// Formatar data DD/MM/YYYY às HH:MM
export function formatarData(data) {
  if (!data) return '—';
  const d = data instanceof Date ? data : new Date(data);
  if (isNaN(d.getTime())) return '—';
  const dia = String(d.getDate()).padStart(2, '0');
  const mes = String(d.getMonth() + 1).padStart(2, '0');
  const ano = d.getFullYear();
  const hora = String(d.getHours()).padStart(2, '0');
  const min = String(d.getMinutes()).padStart(2, '0');
  return `${dia}/${mes}/${ano} às ${hora}:${min}`;
}

// Data de hoje no formato YYYY-MM-DD
export function hojeISO() {
  const h = new Date();
  return `${h.getFullYear()}-${String(h.getMonth() + 1).padStart(2, '0')}-${String(h.getDate()).padStart(2, '0')}`;
}

// Mês e Ano atual
export function mesAnoAtual() {
  const meses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
  const agora = new Date();
  return `${meses[agora.getMonth()]} ${agora.getFullYear()}`;
}

// Primeira letra maiúscula
export function inicial(nome) {
  return nome && nome.length > 0 ? nome[0].toUpperCase() : '?';
}

// Porcentagem de frequência
export function frequenciaPercentual(presencas, faltas) {
  const total = presencas + faltas;
  if (total === 0) return 0;
  return Math.round((presencas / total) * 100);
}

// Normalizar dia da semana para comparação
export function normalizarDia(dia) {
  return (dia || '').toLowerCase().trim()
    .replace(/á/g, 'a').replace(/é/g, 'e').replace(/í/g, 'i')
    .replace(/ó/g, 'o').replace(/ú/g, 'u').replace(/ç/g, 'c');
}

// Verifica se horário está em andamento
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

// Status label
export function statusLabel(status) {
  const labels = { 0: 'Em andamento', 1: 'Próxima', 2: 'Concluída', 3: 'Cancelada' };
  return labels[status] || 'Próxima';
}
