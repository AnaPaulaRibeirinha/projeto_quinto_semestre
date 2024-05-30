import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/models/itemCarrinho.dart';

class CarrinhoProvider with ChangeNotifier {
  final List<ItemCarrinho> _items = [];

  List<ItemCarrinho> get items => _items;

  void addItem(ItemCarrinho item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      _items[index].quantidade++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
