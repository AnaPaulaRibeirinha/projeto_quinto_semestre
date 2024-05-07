class Produto {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final String imageUrl;
  bool eFavorito;

  // Construtor
  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imageUrl,
    this.eFavorito = false,
  });

  // Método para alternar o estado de favorito
  void toggleFavorite() {
    eFavorito = !eFavorito;
  }
}
