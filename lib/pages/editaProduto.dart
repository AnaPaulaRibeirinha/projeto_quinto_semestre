import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart';

class ProdutoEdicaoPage extends StatefulWidget {
  final Map<String, dynamic> produto;

  const ProdutoEdicaoPage({Key? key, required this.produto}) : super(key: key);

  @override
  _ProdutoEdicaoPageState createState() => _ProdutoEdicaoPageState();
}

class _ProdutoEdicaoPageState extends State<ProdutoEdicaoPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _precoController;
  late TextEditingController _descricaoController;
  late TextEditingController _imageUrlController;
  
  

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.produto['nome']);
    final preco = widget.produto['preco'] is Map
    ? (widget.produto['preco'] as Map<String, dynamic>).containsKey('\$numberDecimal')
        ? double.tryParse((widget.produto['preco'] as Map<String, dynamic>)['\$numberDecimal']) ?? 0.0
        : 0.0
    : double.tryParse(widget.produto['preco'].toString()) ?? 0.0;
    _precoController = TextEditingController(text: preco.toString());
    _descricaoController = TextEditingController(text: widget.produto['descricao']);
    _imageUrlController = TextEditingController(text: widget.produto['imageUrl']);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _descricaoController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _atualizarProduto() async {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text;
      final preco = double.parse(_precoController.text);
      final descricao = _descricaoController.text;
      final imageUrl = _imageUrlController.text;

      final produtoAtualizado = {
        'id': widget.produto['_id'],
        'nome': nome,
        'preco': preco,
        'descricao': descricao,
        'imageUrl': imageUrl,
      };

      try {
        await ApiService().atualizarProduto(produtoAtualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto atualizado com sucesso')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar produto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precoController,
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a URL da imagem';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _atualizarProduto,
                child: Text('Atualizar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
