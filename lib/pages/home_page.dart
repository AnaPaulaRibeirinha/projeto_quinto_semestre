import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/pages/conta.dart';
import 'package:projeto_quinto_semestre/pages/salvos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color appBarColor = Colors.white;
  Color bottomNavBarColor = const Color(0xFF770624);

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
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
              userInfo: {},
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        'image': 'https://i.imgur.com/qAMdoeP.png',
        'price': 'R\$ 30,00',
        'description': 'Rímel'
      },
      {
        'image': 'https://i.imgur.com/KoReX3t.png',
        'price': 'R\$ 50,00',
        'description': 'Batom'
      },
      {
        'image': 'https://i.imgur.com/huG12VB.png',
        'price': 'R\$ 100,00',
        'description': 'Paleta'
      },
      {
        'image': 'https://i.imgur.com/KoReX3t.png',
        'price': 'R\$ 50',
        'description': 'Batom'
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            border: const Border(
              bottom: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: appBarColor,
            title: Text(
              "TONS DE BELEZA",
              style: TextStyle(
                color: bottomNavBarColor,
                fontSize: 20,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: bottomNavBarColor),
                onPressed: () {
                   Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Carrinho(),
          ),);
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: bottomNavBarColor),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'INÍCIO',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3 - 24,
                    child: Image.network(
                      'https://i.imgur.com/nc5dc1N.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3 - 24,
                    child: Image.network(
                      'https://i.imgur.com/39rOr9o.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3 - 24,
                    child: Image.network(
                      'https://i.imgur.com/8H1kicp.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Produtos',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.network(
                          products[index]['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          products[index]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bottomNavBarColor,
                          textStyle: const TextStyle(
                              color: Colors
                                  .white), // Definindo a cor do texto como branco
                        ),
                        child: const Text('Comprar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Salvos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Conta',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: bottomNavBarColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
