/**
 * @typedef {Object} Usuario
 * @property {number} id
 * @property {string} nome
 * @property {string} email
 */

/**
 * @typedef {Object} Aluno
 * @property {number} id
 * @property {string} nome
 * @property {string} [email]
 * @property {number} [presencas]
 * @property {number} [faltas]
 */

/**
 * @typedef {Object} Aula
 * @property {number} id
 * @property {string} nome
 * @property {string} dia_semana
 * @property {string} horario_inicio
 * @property {string} horario_fim
 * @property {number} [status]
 */

/**
 * @typedef {Object} ApiError
 * @property {string} [erro]
 * @property {string} [error]
 * @property {string} [message]
 * @property {string} [mensagem]
 */

export {};
