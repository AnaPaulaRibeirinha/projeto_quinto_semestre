import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_quinto_semestre/provider/carrinhoProvider.dart';

class Carrinho extends StatelessWidget {
  const Carrinho({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CarrinhoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
      ),
      body: ListView.builder(
        itemCount: cartProvider.items.length,
        itemBuilder: (context, index) {
          final item = cartProvider.items[index];
          return ListTile(
            leading: Image.network(item.imageUrl),
            title: Text(item.nome),
            subtitle: Text("R\$ ${item.preco} x ${item.quantidade}"),
            trailing: IconButton(
              icon: const Icon(Icons.remove_shopping_cart),
              onPressed: () {
                cartProvider.removeItem(item.id);
              },
            ),
          );
        },
      ),
    );
  }
}
