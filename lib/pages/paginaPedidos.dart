import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart';

class PedidosPage extends StatefulWidget {
  final String userId;

  const PedidosPage({super.key, required this.userId});

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  late Future<List<Map<String, dynamic>>> _pedidosFuture;

  @override
  void initState() {
    super.initState();
    _pedidosFuture = _fetchPedidos();
  }

  Future<List<Map<String, dynamic>>> _fetchPedidos() async {
    try {
      return await ApiService().getPedidos(widget.userId);
    } catch (e) {
      throw Exception('Erro ao carregar os pedidos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _pedidosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum pedido encontrado.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pedido = snapshot.data![index];
                return ListTile(
                  title: Text('Pedido #${pedido['_id']}'),
                  subtitle: Text('Total: R\$ ${pedido['total'].toStringAsFixed(2)}'),
                  onTap: () {
                    // Navegar para detalhes do pedido, se necessário
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
