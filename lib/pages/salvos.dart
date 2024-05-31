import 'dart:core';

import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/pages/home_page.dart';
import 'package:projeto_quinto_semestre/pages/conta.dart';

class Salvos extends StatefulWidget {
  const Salvos({Key? key}) : super(key: key);

  @override
  _SalvosState createState() => _SalvosState();
}

class _SalvosState extends State<Salvos> {
  List<bool> savedProducts = [true, true, true];

  final List<String> imageList = [
    'https://i.imgur.com/qAMdoeP.png',
    'https://i.imgur.com/KoReX3t.png',
    'https://i.imgur.com/huG12VB.png',
  ];

  final List<String> productNames = [
    'Rímel',
    'Batom',
    'Paleta',
  ];

  final List<String> productPrices = [
    'R\$ 30,00',
    'R\$ 50,00',
    'R\$ 100,00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Salvos',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold), // Definindo o texto "Salvos" em negrito
        ),
        backgroundColor: const Color.fromARGB(255, 133, 1, 1),
      ),
      body: SingleChildScrollView(
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
                children: List.generate(imageList.length, (index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15)),
                          child: Image.network(
                            imageList[index],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
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
                                    productNames[index],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        savedProducts[index] =
                                            !savedProducts[index];
                                      });
                                    },
                                    icon: Icon(
                                      savedProducts[index]
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: savedProducts[index]
                                          ? Colors.red
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                productPrices[index],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 105, 4, 4),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 133, 1, 1),
                                  textStyle: const TextStyle(
                                      color: Colors.white), // Definindo a cor do texto para branco
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  'Comprar',
                                  style: TextStyle(color: Colors.white), // Definindo a cor do texto para branco
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
        backgroundColor: Color.fromARGB(255, 236, 236, 236),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 107, 7, 0)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Color.fromARGB(255, 107, 7, 0)),
            label: 'Salvos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Color.fromARGB(255, 107, 7, 0)),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(), 
                  ),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Salvos(),
                  ),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Conta(
                      userInfo: {}, // You need to provide userInfo data here
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
