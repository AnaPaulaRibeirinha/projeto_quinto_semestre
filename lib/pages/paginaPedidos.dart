import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart';
import 'package:projeto_quinto_semestre/models/itemCarrinho.dart'; // Supondo que você tenha um modelo para o pedido
import 'package:projeto_quinto_semestre/provider/carrinhoProvider.dart';
import 'package:provider/provider.dart';

class PedidosPage extends StatefulWidget {
  final String userId;

  const PedidosPage({super.key, required this.userId});

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  late Future<List<Map<String, dynamic>>> _pedidosFuture;

  @override
  void initState() {
    super.initState();
    _pedidosFuture = _fetchPedidos();
  }

  Future<List<Map<String, dynamic>>> _fetchPedidos() async {
    try {
      return await ApiService().getPedidos(widget.userId);
    } catch (e) {
      throw Exception('Erro ao carregar os pedidos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _pedidosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum pedido encontrado.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pedido = snapshot.data![index];
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Pedido #${pedido['_id']}'),
                        subtitle: Text('Total: R\$ ${pedido['total']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () =>
                              _reorderProducts(pedido['productIds']),
                          child: const Text('Adicionar ao Carrinho'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _reorderProducts(List<dynamic> produtos) async {
    final carrinhoProvider =
        Provider.of<CarrinhoProvider>(context, listen: false);
    for (final produtoId in produtos) {
      final produto = await ApiService().getProductById(produtoId);
      carrinhoProvider.addItem(ItemCarrinho(
        id: produto['_id'],
        nome: produto['nome'],
        descricao: produto['descricao'],
        imageUrl: produto['imageUrl'],
        preco: produto['preco'] is Map
            ? (produto['preco'] as Map<String, dynamic>)
                    .containsKey('\$numberDecimal')
                ? double.tryParse((produto['preco']
                        as Map<String, dynamic>)['\$numberDecimal']) ??
                    0.0
                : 0.0
            : double.tryParse(produto['preco'].toString()) ?? 0.0,
      ));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produtos adicionados ao carrinho'),
      ),
    );
  }
}
