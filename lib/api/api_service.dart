import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'http://127.0.0.1:3001'; // Use o IP da sua máquina ou o domínio configurado

  Future<void> addUsuario(Map<String, dynamic> usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(usuario),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add user');
    }
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> credentials) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(credentials),
    );
    print('Resposta do servidor: ${response.body}'); // Log da resposta

    if (response.statusCode == 200) {
      return jsonDecode(
          response.body); // Supondo que a resposta contenha o token
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> fetchProtectedData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/protected'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch protected data');
    }
  }

  Future<Map<String, dynamic>?> getUserInfo(
      Map<String, dynamic> credentials) async {
    final String email = credentials['email'];
    final String senha = credentials['senha'];

    final response = await http.post(
      Uri.parse('$baseUrl/recuperaUsuario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao obter dados cliente: ${response.statusCode}');
    }
  }
}
