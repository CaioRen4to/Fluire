import './CardAula.css';

export default function CardAula({ aula, totalAlunos, onDetalhes, onFrequencia, onEditar }) {
  return (
    <div className="card-aula">
      <div className="card-aula__top" onClick={onDetalhes}>
        <div className="card-aula__icon-wrap">
          <span className="material-icons">event_note</span>
        </div>
        <div className="card-aula__info">
          <span className="card-aula__nome">{aula.nome}</span>
          <span className="card-aula__horario">{aula.horarioInicio} - {aula.horarioFim}</span>
          {aula.professorNome && (
            <span className="card-aula__professor" style={{ fontSize: '12px', color: 'var(--color-primary)', marginTop: '4px', display: 'flex', alignItems: 'center', gap: '4px' }}>
              <span className="material-icons" style={{ fontSize: '14px' }}>person</span>
              Prof. {aula.professorNome}
            </span>
          )}
        </div>
        <div className="card-aula__right">
          <span className="card-aula__alunos">{totalAlunos} alunos</span>
        </div>
      </div>
      <div className="card-aula__actions">
        <button className="card-aula__btn" onClick={onDetalhes}>
          <span className="material-icons-outlined">visibility</span> Detalhes
        </button>
        <button className="card-aula__btn" onClick={onFrequencia}>
          <span className="material-icons-outlined">fact_check</span> Frequência
        </button>
        <button className="card-aula__btn" onClick={onEditar}>
          <span className="material-icons-outlined">edit</span> Editar
        </button>
      </div>
    </div>
  );
}
