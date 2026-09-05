import { useState } from 'react';
import './InputPadrao.css';

export default function InputPadrao({
  label,
  hint,
  value,
  onChange,
  icone,
  type = 'text',
  obscureText = false,
  keyboardType,
  validator,
  required = false,
  disabled = false,
  name,
}) {
  const [showPassword, setShowPassword] = useState(false);
  const inputType = obscureText ? (showPassword ? 'text' : 'password') : (keyboardType === 'email' ? 'email' : type);

  return (
    <div className="input-padrao">
      {label && <label className="input-padrao__label">{label}</label>}
      <div className="input-padrao__wrapper">
        {icone && (
          <span className="input-padrao__icon material-icons-outlined">{icone}</span>
        )}
        <input
          className="input-padrao__field"
          type={inputType}
          placeholder={hint}
          value={value}
          onChange={onChange}
          required={required}
          disabled={disabled}
          name={name}
          autoComplete={obscureText ? 'current-password' : 'off'}
        />
        {obscureText && (
          <button
            type="button"
            className="input-padrao__toggle"
            onClick={() => setShowPassword(!showPassword)}
            tabIndex={-1}
          >
            <span className="material-icons-outlined">
              {showPassword ? 'visibility_off' : 'visibility'}
            </span>
          </button>
        )}
      </div>
    </div>
  );
}
