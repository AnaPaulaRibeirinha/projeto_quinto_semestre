import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/pages/login.dart'; // Importa a página Login

class Conta extends StatefulWidget {
  const Conta({super.key, required this.userInfo});

  final Map<String, dynamic> userInfo;

  @override
  _ContaState createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  late Map<String, dynamic> _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = widget.userInfo;
    _checkUserInfo();
  }

  void _checkUserInfo() {
    if (_userInfo.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userInfo.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_userInfo['avatarUrl'] ?? ''),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_userInfo['nome'] ?? ''} ${_userInfo['sobrenome'] ?? ''}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _userInfo['email'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                // Navegar para a tela de configurações
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Formas de pagamento'),
              onTap: () {
                // Navegar para a tela de formas de pagamento
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favoritos'),
              onTap: () {
                // Navegar para a tela de favoritos
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                // Implementar a lógica de logout
              },
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
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    // Navegue para a página correspondente ao item selecionado
    switch (index) {
      case 0:
        // Navegar para a página de "Início"
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        // Navegar para a página de "Salvos"
        Navigator.pushReplacementNamed(context, '/salvos');
        break;
      case 2:
        // Nenhuma ação necessária, já estamos na página de Conta
        break;
    }
  }
}
