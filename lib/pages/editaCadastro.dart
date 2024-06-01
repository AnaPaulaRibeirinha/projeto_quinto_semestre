import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart';
import 'package:projeto_quinto_semestre/api/token_storage.dart';
import 'package:projeto_quinto_semestre/pages/conta.dart';
import 'package:projeto_quinto_semestre/pages/login.dart';

class EditarCadastroPage extends StatefulWidget {
  const EditarCadastroPage({super.key, required userId});

  @override
  _EditarCadastroPageState createState() => _EditarCadastroPageState();
}

class _EditarCadastroPageState extends State<EditarCadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String _genero = 'Masculino';
  late Map<String, dynamic> _userInfo;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? token = await TokenStorage.getToken();
    if (token == "" || token == null || token.isEmpty) {
      _redirectToLogin();
    } else {
      try {
        final userInfo = await ApiService().getUserInfo(token);
        setState(() {
          _userInfo = userInfo ?? {};
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Lógica de atualização
      Map<String, dynamic> usuario = {
        'id': _userInfo['_id'],
        'nome': _nomeController.text,
        'sobrenome': _sobrenomeController.text,
        'email': _emailController.text,
        'genero': _genero,
        'senha': _senhaController.text,
      };
      _apiService.updateUsuario(usuario).then((response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Conta(
              userInfo: {}, // Você precisa fornecer os dados do userInfo aqui
            ),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar dados: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Cadastro',
          style: TextStyle(color: Colors.white),
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
              DropdownButtonFormField<String>(
                value: _genero,
                decoration: const InputDecoration(labelText: 'Gênero'),
                items: ['Masculino', 'Feminino', 'Outro'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _genero = value!;
                  });
                },
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
                  child: const Text(
                    'Atualizar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
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
