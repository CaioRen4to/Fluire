/// Configuração central da API do backend Flask.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'http://127.0.0.1:5000';

  static const Duration timeout = Duration(seconds: 10);

  static const Map<String, String> jsonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}
