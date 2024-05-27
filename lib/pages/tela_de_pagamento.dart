import 'package:flutter/material.dart';

class TelaDePagamento extends StatefulWidget {
  final double total;
  final int totalItens;

  TelaDePagamento({required this.total, required this.totalItens});

  @override
  _TelaDePagamentoState createState() => _TelaDePagamentoState();
}

class _TelaDePagamentoState extends State<TelaDePagamento> {
  String metodoPagamento = 'PIX';
  String tipoCartao = 'Crédito';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmação e Pagamento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: R\$ ${widget.total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Itens: ${widget.totalItens}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('Selecione o método de pagamento:',
                style: TextStyle(fontSize: 16)),
            ListTile(
              title: Text('PIX'),
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
              title: Text('Cartão'),
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
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (metodoPagamento == 'PIX') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Pagamento realizado com sucesso!'),
                      ),
                    );
                  } else if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Pagamento realizado com sucesso!'),
                      ),
                    );
                  }
                },
                child: Text('Confirmar Pagamento'),
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
        Text('Código PIX:', style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.grey[200],
          child: Text(
            '00020126360014BR.GOV.BCB.PIX0114+5511999999995204000053039865802BR5913FULANO DE TAL6009SÃO PAULO61080540900062070503***63041D3D',
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Container(
            width: 200,
            height: 200,
            color: Colors.grey[300],
            child: Center(child: Text('QR Code')),
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
          Text('Tipo de Cartão:', style: TextStyle(fontSize: 16)),
          ListTile(
            title: Text('Crédito'),
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
            title: Text('Débito'),
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
          SizedBox(height: 16),
          Text('Número do Cartão:', style: TextStyle(fontSize: 16)),
          TextFormField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o número do cartão';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Text('Nome no Cartão:', style: TextStyle(fontSize: 16)),
          TextFormField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o nome no cartão';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Text('Data de Validade:', style: TextStyle(fontSize: 16)),
          TextFormField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.datetime,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a data de validade';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Text('CVV:', style: TextStyle(fontSize: 16)),
          TextFormField(
            decoration: InputDecoration(border: OutlineInputBorder()),
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
