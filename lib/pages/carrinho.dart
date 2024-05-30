import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_quinto_semestre/provider/carrinhoProvider.dart';
import 'tela_de_pagamento.dart';

class Carrinho extends StatelessWidget {
  const Carrinho({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CarrinhoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 133, 1, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return ListTile(
                  leading: Image.network(item.imageUrl),
                  title: Text(item.nome, style: const TextStyle(color: Colors.black)),
                  subtitle: Text("R\$ ${item.preco} x ${item.quantidade}", style: const TextStyle(color: Colors.black)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_shopping_cart),
                        onPressed: () {
                          cartProvider.removeItem(item.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cartProvider.incrementQuantity(item.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          cartProvider.decrementQuantity(item.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (cartProvider.items.isNotEmpty) // Validação para mostrar o total apenas se houver itens no carrinho
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: R\$ ${cartProvider.totalPrice().toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaDePagamento(
                            total: cartProvider.totalPrice(),
                            totalItens: cartProvider.totalItems(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Confirmar e Pagar'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
