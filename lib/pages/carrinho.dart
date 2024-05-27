import 'package:flutter/material.dart';

import 'tela_de_pagamento.dart';

class Carrinho extends StatefulWidget {
  const Carrinho({super.key});

  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  final List<Produto> produtos = [
    Produto(
        nome: 'Batom Vermelho',
        preco: 49.99,
        imagem: 'https://i.imgur.com/KoReX3t.png',
        quantidade: 1),
    Produto(
        nome: 'Base Líquida',
        preco: 29.99,
        imagem: 'https://i.imgur.com/KoReX3t.png',
        quantidade: 1),
    Produto(
        nome: 'Máscara de Cílios',
        preco: 19.99,
        imagem: 'https://i.imgur.com/qAMdoeP.png',
        quantidade: 1),
  ];

  void aumentarQuantidade(Produto produto) {
    setState(() {
      produto.quantidade++;
    });
  }

  void diminuirQuantidade(Produto produto) {
    setState(() {
      if (produto.quantidade > 1) {
        produto.quantidade--;
      } else {
        produtos.remove(produto);
      }
    });
  }

  double calcularTotal() {
    return produtos.fold(
        0.0, (total, produto) => total + produto.preco * produto.quantidade);
  }

  int calcularTotalItens() {
    return produtos.fold(0, (total, produto) => total + produto.quantidade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrinho',
          style: TextStyle(color: Colors.white),
        ),
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
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(produtos[index].imagem,
                      width: 50, height: 50),
                  title: Text(produtos[index].nome,
                      style: const TextStyle(color: Colors.black)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'R\$ ${produtos[index].preco.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.black),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () =>
                                diminuirQuantidade(produtos[index]),
                          ),
                          Text('${produtos[index].quantidade}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () =>
                                aumentarQuantidade(produtos[index]),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total: R\$ ${calcularTotal().toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      'Itens: ${calcularTotalItens()}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    double total = calcularTotal();
                    int totalItens = calcularTotalItens();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaDePagamento(
                            total: total, totalItens: totalItens),
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

class Produto {
  final String nome;
  final double preco;
  final String imagem;
  int quantidade;

  Produto(
      {required this.nome,
      required this.preco,
      required this.imagem,
      this.quantidade = 1});
}
