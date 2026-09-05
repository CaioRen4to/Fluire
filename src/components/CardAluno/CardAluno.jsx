import { inicial, frequenciaPercentual } from '../../utils';
import './CardAluno.css';

export default function CardAluno({ aluno, onTap }) {
  const pct = frequenciaPercentual(aluno.presencas || 0, aluno.faltas || 0);

  return (
    <div className="card-aluno" onClick={onTap}>
      <div className="card-aluno__avatar">{inicial(aluno.nome)}</div>
      <div className="card-aluno__info">
        <span className="card-aluno__nome">{aluno.nome}</span>
        <span className="card-aluno__detalhe">
          {aluno.modalidade || aluno.email || aluno.telefone || '—'}
        </span>
      </div>
      <div className="card-aluno__freq">
        <span className="card-aluno__pct">{pct}%</span>
        <div className={`card-aluno__status ${aluno.ativo === false || aluno.ativo === 0 ? 'card-aluno__status--inativo' : ''}`}>
          {aluno.ativo === false || aluno.ativo === 0 ? 'Inativo' : 'Ativo'}
        </div>
      </div>
    </div>
  );
}
