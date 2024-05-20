import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool _isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLogin ? 'Login' : 'Cadastro',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 102, 0, 0),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.network(
                'https://i.imgur.com/gBQhCJ6.png',
                height: 100,
              ),
            ),
            const SizedBox(height: 20.0),
            if (!_isLogin) ...[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Sobrenome'),
              ),
              const SizedBox(height: 20.0),
            ],
            if (!_isLogin)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gênero'),
                items: ['Masculino', 'Feminino', 'Outro'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: !_isLogin ? (String? value) {} : null,
              ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 40.0,
              width: 150.0, // Define a largura do botão como 150.0
              child: ElevatedButton(
                onPressed: () {
                  if (!_isLogin) {
                    // Lógica de cadastro
                  } else {
                    // Lógica de login
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 102, 0, 0)),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 20.0)),
                ),
                child: Text(
                  _isLogin ? 'Login' : 'Cadastrar',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(
                _isLogin
                    ? 'Ainda não tem cadastro? Cadastre-se aqui!'
                    : 'Já tem cadastro? Faça seu login!',
                style: const TextStyle(color: Color.fromARGB(255, 102, 0, 0)),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Cadastro Page',
    home: const CadastroPage(),
    theme: ThemeData(
      primarySwatch: Colors.red,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}
