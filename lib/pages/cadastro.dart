import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool _isLogin = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String _genero = 'Masculino';

  final ApiService _apiService = ApiService();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_isLogin) {
        // Lógica de cadastro
        Map<String, dynamic> usuario = {
          'nome': _nomeController.text,
          'sobrenome': _sobrenomeController.text,
          'email': _emailController.text,
          'genero': _genero,
          'senha': _senhaController.text,
        };
        _apiService.addUsuario(usuario).then((response) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuário cadastrado com sucesso!')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao cadastrar usuário: $error')),
          );
        });
      } else {
        // Lógica de login
      }
    }
  }

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
        child: Form(
          key: _formKey,
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
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _sobrenomeController,
                  decoration: const InputDecoration(labelText: 'Sobrenome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu sobrenome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
              ],
              if (!_isLogin)
                DropdownButtonFormField<String>(
                  value: _genero,
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  items: ['Masculino', 'Feminino', 'Outro'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: !_isLogin ? (String? value) {
                    setState(() {
                      _genero = value!;
                    });
                  } : null,
                ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 40.0,
                width: 150.0, // Define a largura do botão como 150.0
                child: ElevatedButton(
                  onPressed: _submitForm,
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
