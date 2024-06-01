import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart';
import 'package:projeto_quinto_semestre/api/token_storage.dart';
import 'package:projeto_quinto_semestre/models/itemCarrinho.dart';
import 'package:projeto_quinto_semestre/pages/login.dart';
import 'package:projeto_quinto_semestre/provider/carrinhoProvider.dart';
import 'package:provider/provider.dart';

class PaginaProduto extends StatefulWidget {
  final Map<String, dynamic> product;

  const PaginaProduto({super.key, required this.product});

  @override
  _PaginaProdutoState createState() => _PaginaProdutoState();
}

class _PaginaProdutoState extends State<PaginaProduto> {
  final TextEditingController _commentController = TextEditingController();
  int _rating = 1;
  String? _userId;
  late ApiService _apiService;
  late Map<String, dynamic> _userInfo;
  List<Map<String, dynamic>> _comments = [];
  double _productRating = 0.0;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    await _loadComments();
    await _loadProductRating();
  }

  Future<void> _loadComments() async {
    try {
      final comments = await _apiService.loadComments(widget.product['_id']);
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _loadProductRating() async {
    try {
      final rating = await _apiService.loadProductRating(widget.product['_id']);
      setState(() {
        _productRating = rating;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _redirectToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  Future<void> _submitComment() async {
    String? token = await TokenStorage.getToken();
    if (token == "" || token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Você precisa estar logado para comentar.')),
      );
      _redirectToLogin();
    } else {
      try {
        final userInfo = await ApiService().getUserInfo(token);
        setState(() {
          _userInfo = userInfo ?? {};
          _userId = _userInfo['_id'];
        });
      } catch (e) {
        _redirectToLogin();
      }
    }

    final comment = _commentController.text;
    final productId = widget.product['_id'];

    // Salvar o comentário usando ApiService
    await _apiService.submitComment(productId, _userId!, comment, _rating);

    // Atualizar a nota do produto usando ApiService
    await _apiService.updateProductRating(productId, _rating);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comentário e nota enviados com sucesso!')),
    );

    _commentController.clear();
    setState(() {
      _rating = 1;
    });

    await _loadProductDetails(); // Reload comments and rating
  }

  @override
  Widget build(BuildContext context) {
    double preco = 0.0;
    if (widget.product['preco'] is Map) {
      final precoMap = widget.product['preco'] as Map<String, dynamic>;
      if (precoMap.containsKey(r'$numberDecimal')) {
        preco = double.tryParse(precoMap[r'$numberDecimal']) ?? 0.0;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['nome']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  widget.product['imageUrl'],
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.product['nome'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                widget.product['descricao'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Preço: R\$${preco.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final carrinhoProvider =
                        Provider.of<CarrinhoProvider>(context, listen: false);
                    carrinhoProvider.addItem(
                      ItemCarrinho(
                        id: widget.product['_id'],
                        nome: widget.product['nome'],
                        descricao: widget.product['descricao'],
                        imageUrl: widget.product['imageUrl'],
                        preco: preco,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Produto adicionado ao carrinho!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF770624),
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: const Text('Comprar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comentário',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const Text('Nota:', style: TextStyle(fontSize: 18)),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                    ),
                    color: Colors.amber,
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _submitComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF770624),
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: const Text('Enviar Comentário',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Comentários',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _comments.isEmpty
                  ? const Text('Nenhum comentário disponível')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _comments.map<Widget>((comment) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment['comment'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Feito em: ${formatTimestamp(comment['timestamp'])}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              'Nota do usuario: ${comment['nota']}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 16),
              Text(
                'Média de Notas: ${_productRating.toStringAsFixed(1)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
