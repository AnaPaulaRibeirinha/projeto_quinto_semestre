import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/pages/cadastro.dart';
import 'package:projeto_quinto_semestre/pages/conta.dart';
import 'package:projeto_quinto_semestre/pages/home_page.dart';
import 'package:projeto_quinto_semestre/pages/salvos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inicial',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        
      ),
      // home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/': (context) => const MyHomePage(),
        '/cadastro': (context) => CadastroPage(),
        '/conta': (context) => const Conta(),
        '/home': (context) => const MyHomePage(),
        '/salvos': (context) => const salvos(),
      },
    );
  }
}
