class ItemCarrinho {
  final String id;
  final String nome;
  final String descricao;
  final String imageUrl;
  final double preco;
  int quantidade;

  ItemCarrinho({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.imageUrl,
    required this.preco,
    this.quantidade = 1,
  });
}