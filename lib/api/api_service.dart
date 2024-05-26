import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'http://192.168.0.69:3000'; // Use o IP da sua máquina ou o domínio configurado

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

  Future<void> login(Map<String, dynamic> credentials) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cadastro'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(credentials),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao efetuar login');
    }
  }
}
