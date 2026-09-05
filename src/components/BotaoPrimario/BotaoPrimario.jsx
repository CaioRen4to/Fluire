import './BotaoPrimario.css';

export default function BotaoPrimario({ texto, onClick, carregando = false, icone, disabled = false, tipo = 'button', cor }) {
  return (
    <button
      type={tipo}
      className={`botao-primario ${cor === 'erro' ? 'botao-primario--erro' : ''}`}
      onClick={onClick}
      disabled={carregando || disabled}
    >
      {carregando ? (
        <span className="botao-primario__spinner" />
      ) : (
        <>
          {icone && <span className="material-icons-outlined botao-primario__icone">{icone}</span>}
          {texto}
        </>
      )}
    </button>
  );
}

export function BotaoTexto({ texto, onClick, cor, disabled = false }) {
  return (
    <button
      type="button"
      className={`botao-texto ${cor === 'erro' ? 'botao-texto--erro' : ''}`}
      onClick={onClick}
      disabled={disabled}
    >
      {texto}
    </button>
  );
}

export function BotaoOutline({ texto, onClick, icone, disabled = false }) {
  return (
    <button
      type="button"
      className="botao-outline"
      onClick={onClick}
      disabled={disabled}
    >
      {icone && <span className="material-icons-outlined botao-outline__icone">{icone}</span>}
      {texto}
    </button>
  );
}
