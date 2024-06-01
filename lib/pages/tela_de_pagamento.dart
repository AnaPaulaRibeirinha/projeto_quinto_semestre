import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart';
import 'package:projeto_quinto_semestre/pages/home_page.dart';
import 'package:projeto_quinto_semestre/provider/carrinhoProvider.dart';
import 'package:provider/provider.dart';

class TelaDePagamento extends StatefulWidget {
  final double total;
  final int totalItens;
  final Map<String, dynamic> userInfo;

  const TelaDePagamento(
      {super.key,
      required this.total,
      required this.totalItens,
      required this.userInfo});

  @override
  _TelaDePagamentoState createState() => _TelaDePagamentoState();
}

class _TelaDePagamentoState extends State<TelaDePagamento> {
  String metodoPagamento = 'PIX';
  String tipoCartao = 'Crédito';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numeroCartaoController = TextEditingController();
  final TextEditingController _nomeUsuarioController = TextEditingController();
  final TextEditingController _dataValidadeController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  void _salvarPedido() async {
    final productIds = Provider.of<CarrinhoProvider>(context, listen: false)
        .getProductIds(); // Obtém a lista de IDs dos produtos do carrinho

    final pedido = {
      'userId': widget.userInfo['_id'], // ajuste conforme os dados do userInfo
      'total': widget.total,
      'totalItens': widget.totalItens,
      'formaPagamento': metodoPagamento == 'PIX' ? 'PIX' : tipoCartao,
      'productIds': productIds,
      if (metodoPagamento == 'PIX')
        'codigoPix':
            '00020126360014BR.GOV.BCB.PIX0114+5511999999995204000053039865802BR5913FULANO DE TAL6009SÃO PAULO61080540900062070503***63041D3D',
      if (metodoPagamento == 'Cartão')
        'informacoesCartao': {
          'numeroCartao': _numeroCartaoController.text,
          'nomeUsuario': _nomeUsuarioController.text,
          'dataValidade': _dataValidadeController.text,
          'cvv': _cvvController.text,
        },
    };

    try {
      await ApiService().createOrder(pedido);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pagamento realizado com sucesso!'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao realizar o pagamento: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação e Pagamento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: R\$ ${widget.total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Itens: ${widget.totalItens}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text('Selecione o método de pagamento:',
                style: TextStyle(fontSize: 16)),
            ListTile(
              title: const Text('PIX'),
              leading: Radio(
                value: 'PIX',
                groupValue: metodoPagamento,
                onChanged: (value) {
                  setState(() {
                    metodoPagamento = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Cartão'),
              leading: Radio(
                value: 'Cartão',
                groupValue: metodoPagamento,
                onChanged: (value) {
                  setState(() {
                    metodoPagamento = value!;
                  });
                },
              ),
            ),
            if (metodoPagamento == 'PIX') _buildPixForm(),
            if (metodoPagamento == 'Cartão') _buildCartaoForm(),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (metodoPagamento == 'PIX') {
                    _salvarPedido();
                  } else if (_formKey.currentState!.validate()) {
                    _salvarPedido();
                  }
                },
                child: const Text('Confirmar Pagamento'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPixForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Código PIX:', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[200],
          child: const Text(
            '00020126360014BR.GOV.BCB.PIX0114+5511999999995204000053039865802BR5913FULANO DE TAL6009SÃO PAULO61080540900062070503***63041D3D',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 200,
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: Text('QR Code')),
          ),
        ),
      ],
    );
  }

  Widget _buildCartaoForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tipo de Cartão:', style: TextStyle(fontSize: 16)),
          ListTile(
            title: const Text('Crédito'),
            leading: Radio(
              value: 'Crédito',
              groupValue: tipoCartao,
              onChanged: (value) {
                setState(() {
                  tipoCartao = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Débito'),
            leading: Radio(
              value: 'Débito',
              groupValue: tipoCartao,
              onChanged: (value) {
                setState(() {
                  tipoCartao = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text('Número do Cartão:', style: TextStyle(fontSize: 16)),
          TextFormField(
            controller: _numeroCartaoController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o número do cartão';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('Nome no Cartão:', style: TextStyle(fontSize: 16)),
          TextFormField(
            controller: _nomeUsuarioController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o nome no cartão';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('Data de Validade:', style: TextStyle(fontSize: 16)),
          TextFormField(
            controller: _dataValidadeController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.datetime,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a data de validade';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('CVV:', style: TextStyle(fontSize: 16)),
          TextFormField(
            controller: _cvvController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o CVV';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
