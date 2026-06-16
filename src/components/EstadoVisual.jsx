import './EstadoVisual.css';

export function EstadoCarregando({ mensagem = 'Carregando...' }) {
  return (
    <div className="estado-visual estado-carregando fade-in">
      <div className="estado-spinner" />
      <p className="estado-msg">{mensagem}</p>
    </div>
  );
}

export function EstadoErro({ mensagem = 'Ocorreu um erro', onTentarNovamente }) {
  return (
    <div className="estado-visual estado-erro fade-slide-up">
      <span className="material-icons estado-icone" style={{ color: 'var(--color-erro)' }}>error_outline</span>
      <p className="estado-msg">{mensagem}</p>
      {onTentarNovamente && (
        <button className="estado-btn" onClick={onTentarNovamente}>
          Tentar novamente
        </button>
      )}
    </div>
  );
}

export function EstadoVazio({ titulo, subtitulo, icone = 'inbox', onAcao, textoAcao }) {
  return (
    <div className="estado-visual estado-vazio fade-slide-up">
      <span className="material-icons estado-icone">{icone}</span>
      <p className="estado-titulo">{titulo}</p>
      {subtitulo && <p className="estado-subtitulo">{subtitulo}</p>}
      {onAcao && textoAcao && (
        <button className="estado-btn" onClick={onAcao}>
          {textoAcao}
        </button>
      )}
    </div>
  );
}
