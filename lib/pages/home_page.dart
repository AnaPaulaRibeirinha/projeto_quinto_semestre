import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/pages/conta.dart';
import 'package:projeto_quinto_semestre/pages/salvos.dart';

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

    // Navegar para a página correspondente ao item selecionado
    switch (_selectedIndex) {
      case 0:
        // Navegar para a página de "Início"
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
            builder: (context) => const salvos(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Conta(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                color: Colors.grey.withOpacity(0.2), // Cor da sombra
                spreadRadius: 1, // Espalhamento da sombra
                blurRadius: 2, // Desfoque da sombra
                offset: const Offset(0, 2), // Deslocamento da sombra
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
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 16), // Espaçamento entre a AppBar e o texto "Início"
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'INÍCIO',
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.bold,
              ),
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
            icon: Icon(Icons.heart_broken),
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
}
