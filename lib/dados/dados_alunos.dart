import 'package:fluire/modelos/aluno.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

/// Dados de alunos - Preparado para integração com backend
/// Implementar chamadas de API real nos métodos abaixo
class DadosAlunos {
  final List<Aluno> vAlunos = [];

  /// Lista todos os alunos
  /// TODO: Implementar chamada GET para API de alunos
  Future<List<Aluno>> listar() async {
    try {
      // GET para buscar todos os alunos
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/alunos'),
      ).timeout(const Duration(seconds: 10));

      // Verifica se a requisição foi bem sucedida
      if (response.statusCode == 200) {
        // Decodifica o JSON
        dynamic jsonData = json.decode(response.body);

        // Se for lista vazia, retorna lista vazia
        if (jsonData is List && jsonData.isEmpty) {
          return [];
        }

        // Se for lista, converte para Aluno
        if (jsonData is List) {
          final alunos = <Aluno>[];
          for (var item in jsonData) {
            try {
              alunos.add(Aluno.fromJson(item));
            } catch (e) {
              // Ignora itens que não podem ser convertidos
              continue;
            }
          }
          return alunos;
        }

        // Se não for lista, retorna lista vazia
        return [];
      } else {
        throw Exception('Erro ao carregar alunos: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Timeout: O servidor não respondeu em 10 segundos');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Busca aluno por ID
  /// TODO: Implementar chamada GET para API de alunos/{id}
  Future<Aluno?> buscarPorId(String id) async {
    try {
      // Converte ID de String para int para o backend
      final idInt = int.tryParse(id);
      if (idInt == null) {
        throw Exception('ID inválido: $id');
      }
      
      // GET para buscar aluno específico pelo ID
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/alunos/$idInt'),
      );
      
      // Verifica se encontrou o aluno
      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        return Aluno.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null; // Aluno não encontrado
      } else {
        throw Exception('Erro ao carregar aluno: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Cria um novo aluno
  /// POST para API de alunos
  Future<Aluno> criar(Aluno aluno) async {
    try {
      // Prepara o corpo da requisição com os dados do aluno
      final body = jsonEncode({
        'nome': aluno.nome,
        'email': aluno.email,
        'telefone': aluno.telefone,
      });

      // Configura os headers para enviar JSON
      final headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // POST para criar novo aluno
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/alunos'),
        headers: headers,
        body: body,
      );

      // Verifica se a requisição foi bem sucedida
      if (response.statusCode == 201) {
        // Extrai o ID retornado pelo backend
        final responseData = json.decode(response.body);
        final alunoId = responseData['id']?.toString() ?? aluno.id;
        // Retorna o aluno com o ID correto do backend
        return aluno.copyWith(id: alunoId);
      } else {
        throw Exception('Erro ao criar aluno: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Atualiza um aluno existente
  /// PUT para API de alunos/{id}
  Future<Aluno> atualizar(Aluno aluno) async {
    try {
      // Converte ID de String para int para o backend
      final idInt = int.tryParse(aluno.id);
      if (idInt == null) {
        throw Exception('ID inválido: ${aluno.id}');
      }

      // Prepara o corpo da requisição com os dados do aluno
      final body = jsonEncode({
        'nome': aluno.nome,
        'email': aluno.email,
        'telefone': aluno.telefone,
      });

      // Configura os headers para enviar JSON
      final headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // PUT para atualizar aluno existente
      final response = await http.put(
        Uri.parse('http://127.0.0.1:5000/alunos/$idInt'),
        headers: headers,
        body: body,
      );

      // Verifica se a requisição foi bem sucedida
      if (response.statusCode == 200) {
        return aluno;
      } else {
        throw Exception('Erro ao atualizar aluno: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Remove aluno
  /// TODO: Implementar chamada DELETE para API de alunos/{id}
  Future<void> remover(String id) async {
    try {
      // Converte ID de String para int para o backend
      final idInt = int.tryParse(id);
      if (idInt == null) {
        throw Exception('ID inválido: $id');
      }
      
      // DELETE para remover aluno pelo ID
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:5000/alunos/$idInt'),
      );

      // Verifica se a remoção foi bem sucedida
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Erro ao remover aluno: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Busca aluno por nome
  /// TODO: Implementar chamada GET para API de alunos/nome/{nome}
  Future<List<Aluno>> buscarPorNome(String nome) async {
    try {
      // GET para buscar alunos por nome
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/alunos/nome/$nome'),
      );

      // Verifica se encontrou alunos
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Aluno.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return []; // Nenhum aluno encontrado
      } else {
        throw Exception('Erro ao buscar alunos por nome: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
