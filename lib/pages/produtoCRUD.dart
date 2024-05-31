import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/pages/paginaProduto.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart';
import 'package:projeto_quinto_semestre/pages/editaProduto.dart';

class ProdutoCRUDPage extends StatefulWidget {
  @override
  _ProdutoCRUDPageState createState() => _ProdutoCRUDPageState();
}

class _ProdutoCRUDPageState extends State<ProdutoCRUDPage> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final fetchedProducts = await ApiService().fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Print the error for debugging
      print('Erro ao carregar produtos: $e');
    }
  }

  void desativaProduto(String id) async {
    try {
      await ApiService().desativaProduto(id);
      loadProducts(); // Recarrega a lista de produtos após a desativação
    } catch (e) {
      print('Erro ao desativar produto: $e');
    }
  }

  void ativaProduto(String id) async {
    try {
      await ApiService().ativaProduto(id);
      loadProducts(); // Recarrega a lista de produtos após a ativação
    } catch (e) {
      print('Erro ao ativar produto: $e');
    }
  }

  void desativaDestaqueProduto(String id) async {
    try {
      await ApiService().desativaDestaqueProduto(id);
      loadProducts(); // Recarrega a lista de produtos após a desativação
    } catch (e) {
      print('Erro ao desativar produto: $e');
    }
  }

  void ativaDestaqueProduto(String id) async {
    try {
      await ApiService().ativaDestaqueProduto(id);
      loadProducts(); // Recarrega a lista de produtos após a ativação
    } catch (e) {
      print('Erro ao ativar produto: $e');
    }
  }

  void _showDesativarDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Desativar Produto'),
        content: Text('Você tem certeza que quer desativar esse produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              desativaProduto(id);
            },
            child: Text('Desativar'),
          ),
        ],
      ),
    );
  }

  void _showAtivarDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ativar Produto'),
        content: Text('Você tem certeza que quer ativar esse produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ativaProduto(id);
            },
            child: Text('Ativar'),
          ),
        ],
      ),
    );
  }

  void _showAtivarDestaqueDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Produto Destaque'),
        content: Text('Você tem certeza que quer destacar esse produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ativaDestaqueProduto(id);
            },
            child: Text('Destacar'),
          ),
        ],
      ),
    );
  }

  void _showDesativarDestaqueDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Produto Destaque'),
        content: Text('Você tem certeza que quer remover o destaque desse produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              desativaDestaqueProduto(id);
            },
            child: Text('Remover'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atualização de Produtos'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(child: Text("Sem produtos"))
              : GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final isInactive = products[index]['inativo'] == true;
                    final isDestaque = products[index]['destaque'] == true;
                    return GestureDetector(
                      onTap: () {
                        //
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        color: Colors.grey[100],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Image.network(
                                    products[index]['imageUrl'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                  if (isInactive)
                                    Container(
                                      color: Colors.black54,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Desativado',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                products[index]['descricao']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProdutoEdicaoPage(produto: products[index]),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                      isInactive ? Icons.check : Icons.not_interested),
                                  onPressed: () {
                                    if (isInactive) {
                                      _showAtivarDialog(products[index]['_id'].toString());
                                    } else {
                                      _showDesativarDialog(products[index]['_id'].toString());
                                    }
                                  },
                                ),
                                !isInactive ?
                                IconButton(
                                  icon: Icon(!isDestaque ? Icons.star_border_sharp : Icons.star_outlined),
                                  onPressed: () {
                                    if(!isDestaque) {
                                      _showAtivarDestaqueDialog(products[index]['_id'].toString());
                                    } else {
                                      _showDesativarDestaqueDialog(products[index]['_id'].toString());
                                    }
                                  },
                                ) : Container(width: 44),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
