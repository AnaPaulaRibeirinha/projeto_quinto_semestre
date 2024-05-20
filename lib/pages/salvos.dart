import 'package:flutter/material.dart';

void main() {
  runApp(const salvos());
}

class salvos extends StatelessWidget {
  const salvos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salvos',
      theme: ThemeData(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color appBarColor = Colors.white;
  Color bottomNavBarColor = const Color(0xFF770624);
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegar para a página correspondente ao item selecionado
    switch (_selectedIndex) {
      case 0:
        // Navegar para a página de "Início"
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/salvos');
        break;
      case 2:
        Navigator.pushNamed(context, '/conta');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salvos'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Produtos Salvos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildProductCard(
                  'Rímel',
                  'https://i.imgur.com/qAMdoeP.png',
                ),
                _buildProductCard(
                  'Batom',
                  'https://i.imgur.com/KoReX3t.png',
                ),
                _buildProductCard(
                  'Gloss',
                  'https://i.imgur.com/a/ZQtlfb7.png',
                ),
              ],
            ),
          ),
        ],
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
        // Add your onTap functionality for bottom navigation items
      ),
    );
  }

  Widget _buildProductCard(String name, String imageUrl) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 100,
            width: 150,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Ação ao clicar no botão
              },
              child: const Text('Comprar'),
            ),
          ),
        ],
      ),
    );
  }
}
