/// Dados de autenticação - Preparado para integração com backend
/// Implementar chamadas de API real nos métodos abaixo
class DadosAuth {
  Future<void> _aguardar() => Future.delayed(const Duration(milliseconds: 500));

  /// Realiza login do usuário
  /// TODO: Implementar chamada POST para API de autenticação/login
  Future<bool> login(String email, String senha) async {
    await _aguardar();
    // Implementar validação com backend real
    throw UnimplementedError('Implementar integração com backend para login');
  }

  /// Realiza cadastro de novo usuário
  /// TODO: Implementar chamada POST para API de autenticação/register
  Future<bool> cadastro(String email, String senha) async {
    await _aguardar();
    // Implementar cadastro com backend real
    throw UnimplementedError('Implementar integração com backend para cadastro');
  }

  /// Realiza logout do usuário
  /// TODO: Implementar chamada POST para API de autenticação/logout
  Future<void> logout() async {
    await _aguardar();
    // Implementar logout com backend real
    throw UnimplementedError('Implementar integração com backend para logout');
  }
}
