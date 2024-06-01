import 'dart:core';

import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart';
import 'package:projeto_quinto_semestre/api/token_storage.dart';
import 'package:projeto_quinto_semestre/pages/conta.dart';
import 'package:projeto_quinto_semestre/pages/login.dart';
import 'package:projeto_quinto_semestre/pages/paginaProduto.dart';
// Certifique-se de que a página do produto está importada

class Salvos extends StatefulWidget {
  const Salvos({super.key});

  @override
  _SalvosState createState() => _SalvosState();
}

class _SalvosState extends State<Salvos> {
  List<dynamic> savedProducts = [];
  String? _userId;
  late Map<String, dynamic> _userInfo;

  @override
  void initState() {
    super.initState();
    _loadSavedProducts();
  }

  Future<void> _loadSavedProducts() async {
    String? token = await TokenStorage.getToken();
    if (token == "" || token == null || token.isEmpty) {
      _redirectToLogin();
    } else {
      final userInfo = await ApiService().getUserInfo(token);
      setState(() {
        _userInfo = userInfo ?? {};
        _userId = _userInfo['_id'];
      });

      try {
        List<dynamic> products = await ApiService().getSavedProducts(_userId!);
        setState(() {
          savedProducts = products;
        });
      } catch (e) {
        print('Erro ao carregar os produtos salvos: $e');
      }
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

  double extractPreco(Map<String, dynamic> precoMap) {
    if (precoMap.containsKey(r'$numberDecimal')) {
      return double.tryParse(precoMap[r'$numberDecimal']) ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Salvos',
          style: TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.bold), // Definindo o texto "Salvos" em negrito
        ),
        backgroundColor: const Color.fromARGB(255, 133, 1, 1),
      ),
      body: savedProducts.isEmpty
          ? const Center(
              child: Text('Nenhum produto salvo'),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Produtos em Destaque',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: List.generate(savedProducts.length, (index) {
                        final product = savedProducts[index];
                        final double preco = product['preco'] is Map
                            ? extractPreco(product['preco'])
                            : 0.0;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaginaProduto(
                                        product: product,
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: Image.network(
                                    product['imageUrl'],
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          product['nome'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              savedProducts.removeAt(index);
                                              // Adicione aqui a lógica para remover o produto da coleção 'salvos'
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'R\$ $preco',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 105, 4, 4),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 133, 1, 1),
                                        textStyle: const TextStyle(
                                            color: Colors
                                                .white), // Definindo a cor do texto para branco
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        'Comprar',
                                        style: TextStyle(
                                            color: Colors
                                                .white), // Definindo a cor do texto para branco
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 236, 236, 236),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 107, 7, 0)),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Color.fromARGB(255, 107, 7, 0)),
            label: 'Salvos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,
                color: Color.fromARGB(255, 107, 7, 0)),
            label: 'Conta',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: const Color.fromARGB(255, 107, 7, 0),
        unselectedItemColor: const Color.fromARGB(255, 107, 7, 0),
        onTap: (index) {
          setState(() {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/');
                break;
              case 1:
                // Navega para esta página novamente
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Conta(
                      userInfo: {}, // Você precisa fornecer os dados do userInfo aqui
                    ),
                  ),
                );
                break;
            }
          });
        },
      ),
    );
  }
}
