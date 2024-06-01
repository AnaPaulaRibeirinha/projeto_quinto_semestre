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

  Future<Map<String, dynamic>?> getUserInfo(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/recuperaUsuario'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao obter dados do usuário: ${response.statusCode}');
    }
  }

  // Future<Map<String, dynamic>?> getUserToken(String token) async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/recuperaToken'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Erro ao obter dados do usuário: ${response.statusCode}');
  //   }
  // }

  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      body: json.encode({'token': token}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao efetuar logout');
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

  Future<void> criarProduto(Map<String, dynamic> produto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/criaProdutos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(produto),
    );
    if (response.statusCode == 201) {
      print('Produto criado com sucesso');
    } else {
      print('Erro ao criar produto: ${response.reasonPhrase}');
    }
  }

  Future<void> atualizarProduto(Map<String, dynamic> produto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/atualizaProduto/${produto['id']}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(produto),
    );
    if (response.statusCode == 200) {
      print('Produto atualizado com sucesso');
    } else {
      print('Erro ao atualizar produto: ${response.reasonPhrase}');
    }
  }

  Future<void> desativaProduto(String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/desativaProduto/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      print('Produto desativado com sucesso');
    } else {
      print('Erro ao desativar produto: ${response.reasonPhrase}');
    }
  }

  Future<void> ativaProduto(String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/ativaProduto/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao ativar produto');
    }
  }

  Future<void> ativaDestaqueProduto(String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/ativaDestaqueProduto/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao ativar produto');
    }
  }

  Future<void> desativaDestaqueProduto(String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/desativaDestaqueProduto/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao ativar produto');
    }
  }

  Future<List<dynamic>> fetchActiveProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/produtosAtivos'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar produtos ativos');
    }
  }

  Future<List<dynamic>> fetchActiveDestaqueProducts() async {
    final response =
        await http.get(Uri.parse('$baseUrl/produtosAtivosDestaque'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar produtos ativos');
    }
  }

  Future<List<dynamic>> searchProducts(String query) async {
    final response =
        await http.get(Uri.parse('$baseUrl/produtosPesquisa?search=$query'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data;
    } else {
      throw Exception('Erro ao buscar produtos: ${response.reasonPhrase}');
    }
  }

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse('$baseUrl/orders');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao criar pedido!');
    }
  }

  Future<List<Map<String, dynamic>>> getPedidos(String userId) async {
    final url = Uri.parse('$baseUrl/orders/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> submitComment(
      String productId, String userId, String comment, int nota) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/comentariosProduto'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'productId': productId,
        'userId': userId,
        'comment': comment,
        'nota': nota,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao enviar comentário');
    }
  }

  Future<void> updateProductRating(String productId, int rating) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/notaProduto'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'productId': productId,
        'rating': rating,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar nota do produto');
    }
  }

  Future<List<Map<String, dynamic>>> loadComments(String productId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/comentarios/$productId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Falha ao carregar comentários do produto');
    }
  }

  Future<double> loadProductRating(String productId) async {
    final response = await http.get(Uri.parse('$baseUrl/nota/$productId'));
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Falha ao carregar nota do produto');
    }
  }
}
