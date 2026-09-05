import { MESES_ABREV } from '../constants/status';

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

export function hojeISO() {
  const h = new Date();
  return `${h.getFullYear()}-${String(h.getMonth() + 1).padStart(2, '0')}-${String(h.getDate()).padStart(2, '0')}`;
}

export function mesAnoAtual() {
  const agora = new Date();
  return `${MESES_ABREV[agora.getMonth()]} ${agora.getFullYear()}`;
}
