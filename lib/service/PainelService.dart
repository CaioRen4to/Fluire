import 'dart:convert';
import 'package:http/http.dart' as http;

class PainelService {
  static const String _baseUrl = 'http://localhost:8000';

  static Future<Map<String, dynamic>> buscarPainel() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/painel'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Verifica se a resposta tem a estrutura correta
        if (responseData['success'] == true && responseData['data'] != null) {
          return responseData['data'];
        } else {
          throw Exception(responseData['message'] ?? 'Dados inválidos do servidor');
        }
      } else {
        throw Exception('Erro ao buscar dados do painel: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: ${e.toString()}');
    }
  }
}