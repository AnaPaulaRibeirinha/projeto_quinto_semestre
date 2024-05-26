import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/pages/cadastro.dart';
import 'package:projeto_quinto_semestre/pages/home_page.dart';
import 'package:projeto_quinto_semestre/pages/salvos.dart';

void main() {
  runApp(const Conta());
}

class Conta extends StatelessWidget {
  const Conta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conta',
      theme: ThemeData(
        // Defina as cores da AppBar e do BottomNavigationBar
        appBarTheme: AppBarTheme(
          backgroundColor: appBarColor,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: bottomNavBarColor,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

Color appBarColor = Colors.white;
Color bottomNavBarColor = const Color(0xFF770624);

class _HomePageState extends State<HomePage> {
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
            builder: (context) => const Salvos(),
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
      appBar: AppBar(
        title: const Text('Conta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Faça o cadastro clicando no botão'),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navegue para a página de cadastro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroPage()),
                );
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
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
        selectedItemColor: bottomNavBarColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
