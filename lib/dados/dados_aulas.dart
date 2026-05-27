import 'package:fluire/modelos/aula.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

/// Dados de aulas - Integração com backend Flask
class DadosAulas {
  /// Lista todas as aulas
  /// GET para buscar todas as aulas
  Future<List<Aula>> listar() async {
    try {
      // GET para buscar todas as aulas
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/aulas'),
      ).timeout(const Duration(seconds: 10));

      // Verifica se a requisição foi bem sucedida
      if (response.statusCode == 200) {
        // Decodifica o JSON
        dynamic jsonData = json.decode(response.body);

        // Se for lista vazia, retorna lista vazia
        if (jsonData is List && jsonData.isEmpty) {
          return [];
        }

        // Se for lista, converte para Aula
        if (jsonData is List) {
          final aulas = <Aula>[];
          for (var item in jsonData) {
            try {
              aulas.add(Aula.fromJson(item));
            } catch (e) {
              // Ignora itens que não podem ser convertidos
              continue;
            }
          }
          return aulas;
        }

        // Se não for lista, retorna lista vazia
        return [];
      } else {
        throw Exception('Erro ao carregar aulas: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Timeout: O servidor não respondeu em 10 segundos');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Busca aula por ID
  /// GET para buscar aula específica
  Future<Aula?> buscarPorId(String id) async {
    try {
      // Converte ID de String para int para o backend
      final idInt = int.tryParse(id);
      if (idInt == null) {
        throw Exception('ID inválido: $id');
      }

      // GET para buscar aula por ID
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/aulas/$idInt'),
      ).timeout(const Duration(seconds: 10));

      // Verifica se a requisição foi bem sucedida
      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        return Aula.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null; // Aula não encontrada
      } else {
        throw Exception('Erro ao buscar aula: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Timeout: O servidor não respondeu em 10 segundos');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Cria nova aula
  /// POST para criar aula
  Future<Aula> criar(Aula aula) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode(aula.toJson());

      // POST para criar nova aula
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/aulas'),
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 10));

      // Verifica se a requisição foi bem sucedida
      if (response.statusCode == 201) {
        dynamic jsonData = json.decode(response.body);
        // Backend retorna o ID da aula criada
        final novoId = jsonData['id'].toString();
        return aula.copyWith(id: novoId);
      } else {
        throw Exception('Erro ao criar aula: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Timeout: O servidor não respondeu em 10 segundos');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Atualiza aula existente
  /// PUT para atualizar aula
  Future<Aula> atualizar(Aula aula) async {
    try {
      // Converte ID de String para int para o backend
      final idInt = int.tryParse(aula.id);
      if (idInt == null) {
        throw Exception('ID inválido: ${aula.id}');
      }

      final headers = {'Content-Type': 'application/json'};
      final body = json.encode(aula.toJson());

      // PUT para atualizar aula existente
      final response = await http.put(
        Uri.parse('http://127.0.0.1:5000/aulas/$idInt'),
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 10));

      // Verifica se a requisição foi bem sucedida
      if (response.statusCode == 200) {
        return aula;
      } else if (response.statusCode == 404) {
        throw Exception('Aula não encontrada');
      } else {
        throw Exception('Erro ao atualizar aula: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Timeout: O servidor não respondeu em 10 segundos');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Remove aula
  /// DELETE para remover aula
  Future<void> remover(String id) async {
    try {
      // Converte ID de String para int para o backend
      final idInt = int.tryParse(id);
      if (idInt == null) {
        throw Exception('ID inválido: $id');
      }

      // DELETE para remover aula
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:5000/aulas/$idInt'),
      ).timeout(const Duration(seconds: 10));

      // Verifica se a requisição foi bem sucedida
      if (response.statusCode == 200) {
        return; // Sucesso
      } else if (response.statusCode == 404) {
        throw Exception('Aula não encontrada');
      } else {
        throw Exception('Erro ao remover aula: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Timeout: O servidor não respondeu em 10 segundos');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
