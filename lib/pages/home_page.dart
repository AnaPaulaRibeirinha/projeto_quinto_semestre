import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/pages/conta.dart';
import 'package:projeto_quinto_semestre/pages/salvos.dart';

void main() {
  runApp(MyApp());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
            builder: (context) => Home(),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Salvos(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Conta(
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
                onPressed: () {},
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
            SizedBox(height: 16),
            Center(
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
            SizedBox(height: 16),
            Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 480,
                    child: Image.network(
                      'https://i.imgur.com/nc5dc1N.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 480,
                    child: Image.network(
                      'https://i.imgur.com/39rOr9o.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 480,
                    child: Image.network(
                      'https://i.imgur.com/8H1kicp.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(8),
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para comprar o produto
                        },
                        child: Text('Comprar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bottomNavBarColor,
                          textStyle: TextStyle(
                              color: Colors
                                  .white), // Definindo a cor do texto como branco
                        ),
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
