import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_quinto_semestre/provider/carrinhoProvider.dart';
import 'package:projeto_quinto_semestre/models/itemCarrinho.dart';

class PaginaProduto extends StatelessWidget {
  final Map<String, dynamic> product;

  const PaginaProduto({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double preco = 0.0;
    if (product['preco'] is Map) {
      final precoMap = product['preco'] as Map<String, dynamic>;
      if (precoMap.containsKey(r'$numberDecimal')) {
        preco = double.tryParse(precoMap[r'$numberDecimal']) ?? 0.0;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product['nome']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product['imageUrl'],
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 16),
            Text(
              product['nome'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              product['descricao'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Preço: R\$${preco.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final carrinhoProvider = Provider.of<CarrinhoProvider>(context, listen: false);
                  carrinhoProvider.addItem(
                    ItemCarrinho(
                      id: product['_id'],
                      nome: product['nome'],
                      descricao: product['descricao'],
                      imageUrl: product['imageUrl'],
                      preco: preco,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produto adicionado ao carrinho!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF770624),
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: const Text('Comprar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
