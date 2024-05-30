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

  void incrementQuantity(String itemId) {
    final itemIndex = _items.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      _items[itemIndex].quantidade++;
      notifyListeners();
    }
  }

  void decrementQuantity(String itemId) {
    final itemIndex = _items.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1 && _items[itemIndex].quantidade > 1) {
      _items[itemIndex].quantidade--;
      notifyListeners();
    }
  }

  double totalPrice() {
    double total = 0;
    for (var item in _items) {
      total += item.preco * item.quantidade;
    }
    return total;
  }

  int totalItems() {
    int totalItems = 0;
    for (var item in _items) {
      totalItems += item.quantidade;
    }
    return totalItems;
  }
}
