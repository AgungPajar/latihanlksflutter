import 'package:flutter/material.dart';
import 'menu_item.dart';

class CartProvider with ChangeNotifier {
  List<MenuItem> _items = [];
  List<MenuItem> get items => _items;

  void addItem(MenuItem item) {
    if (_items.contains(item)) {
      item.quantity++;
    } else {
      _items.add(item);
      item.quantity = 1;
    }
    notifyListeners();
  }

  void removeItem(MenuItem item) {
    if (_items.contains(item)) {
      item.quantity++;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
}
