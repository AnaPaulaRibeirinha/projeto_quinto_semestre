import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/pages/conta.dart';
import 'package:projeto_quinto_semestre/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/conta': (context) => const Conta(
              userInfo: {},
            ),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final MyHomePage _homePage = const MyHomePage();
  final Salvos _salvosPage = const Salvos();
  final Conta _contaPage = const Conta(
    userInfo: {},
  );

  late Widget _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = _homePage;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          _currentPage = _homePage;
          break;
        case 1:
          _currentPage = _salvosPage;
          break;
        case 2:
          _currentPage = _contaPage;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
        onTap: _onItemTapped,
      ),
    );
  }
}

class Salvos extends StatefulWidget {
  const Salvos({super.key});

  @override
  _SalvosState createState() => _SalvosState();
}

class _SalvosState extends State<Salvos> {
  List<bool> savedProducts = [true, true, true];

  final List<String> imageList = [
    'https://i.imgur.com/qAMdoeP.png',
    'https://i.imgur.com/KoReX3t.png',
    'https://i.imgur.com/qAMdoeP.png',
  ];

  final List<String> productNames = [
    'Rímel',
    'Batom',
    'Rímel',
  ];

  final List<String> productPrices = [
    'R\$ 20,00',
    'R\$ 50,00',
    'R\$ 25,00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Salvos',
          style: TextStyle(color: Colors.white),
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
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 133, 1, 1),
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text('Comprar'),
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
    );
  }
}
