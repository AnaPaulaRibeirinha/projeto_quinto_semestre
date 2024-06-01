import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart';
import 'package:projeto_quinto_semestre/api/token_storage.dart';
import 'package:projeto_quinto_semestre/pages/home_page.dart';
import 'package:projeto_quinto_semestre/pages/login.dart';
import 'package:projeto_quinto_semestre/pages/paginaPedidos.dart';
import 'package:projeto_quinto_semestre/pages/salvos.dart';

class Conta extends StatefulWidget {
  const Conta({super.key, required this.userInfo});

  final Map<String, dynamic> userInfo;

  @override
  _ContaState createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  late Map<String, dynamic> _userInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userInfo = widget.userInfo;
    _checkUserInfo();
  }

  Future<void> _checkUserInfo() async {
    String? token = await TokenStorage.getToken();
    if (token == "" || token == null || token.isEmpty) {
      _redirectToLogin();
    } else {
      try {
        final userInfo = await ApiService().getUserInfo(token);
        setState(() {
          _userInfo = userInfo ?? {};
          _isLoading = false;
        });
      } catch (e) {
        _redirectToLogin();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          backgroundImage:
                              NetworkImage(_userInfo['avatarUrl'] ?? ''),
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
                    leading: const Icon(Icons.list),
                    title: const Text('Pedidos'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PedidosPage(userId: _userInfo['_id']),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sair'),
                    onTap: () {
                      _logout();
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 236, 236, 236),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 107, 7, 0)),
            label: 'Ínicio',
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
        currentIndex: 2,
        selectedItemColor: const Color.fromARGB(255, 107, 7, 0),
        unselectedItemColor: const Color.fromARGB(255, 107, 7, 0),
        onTap: (index) {
          setState(() {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/');
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
                //
                break;
            }
          });
        },
      ),
    );
  }

  void _logout() async {
    await TokenStorage.setToken('');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }
}
