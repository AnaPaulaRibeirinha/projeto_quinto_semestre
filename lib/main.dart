import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/models/token_model.dart';
import 'package:projeto_quinto_semestre/pages/cadastro.dart';
import 'package:projeto_quinto_semestre/pages/carrinho.dart';
import 'package:projeto_quinto_semestre/pages/conta.dart';
import 'package:projeto_quinto_semestre/pages/home_page.dart';
import 'package:projeto_quinto_semestre/pages/login.dart';
import 'package:projeto_quinto_semestre/pages/salvos.dart';
import 'package:provider/provider.dart';
//import 'package:projeto_quinto_semestre/dbHelper/connection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await MongoDB.connect();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TokenModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inicial',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 139, 13, 30)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/cadastro': (context) => const CadastroPage(),
        '/conta': (context) => const Conta(
              userInfo: {},
            ),
        '/salvos': (context) => const Salvos(),
        '/carrinho': (context) => const Carrinho(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
