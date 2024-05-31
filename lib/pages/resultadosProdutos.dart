import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart'; 
import 'package:projeto_quinto_semestre/pages/paginaProduto.dart'; 

class ResultadoProdutos extends StatefulWidget {
  @override
  _ResultadoProdutosState createState() => _ResultadoProdutosState();
}

class _ResultadoProdutosState extends State<ResultadoProdutos> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  Future<void> searchProducts(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await ApiService().searchProducts(query);
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao buscar produtos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados da Pesquisa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar produtos...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchProducts(_searchController.text);
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: searchResults.isEmpty
                        ? Center(child: Text('Nenhum produto encontrado'))
                        : GridView.builder(
                            itemCount: searchResults.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              final product = searchResults[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaginaProduto(product: product),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  color: Colors.grey[100],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          product['imageUrl'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: Text(
                                          product['descricao'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
