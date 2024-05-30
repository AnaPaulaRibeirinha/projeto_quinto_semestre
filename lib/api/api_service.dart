import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'http://127.0.0.1:3000'; // Use o IP da sua máquina ou o domínio configurado

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
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(credentials),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao efetuar login');
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

  Future<List<dynamic>> fetchProducts() async {
  final response = await http.get(Uri.parse('$baseUrl/produtos'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Falha ao carregar produtos');
  }
}

}
