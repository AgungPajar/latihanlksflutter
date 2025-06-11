import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final int price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  int getTotalPrice() => price * quantity;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => [..._cartItems];

  double get totalHarga {
    return _cartItems.fold(0, (sum, item) => sum + item.getTotalPrice());
  }

  int get totalItem {
    return _cartItems.length;
  }

  void addItem(String id, String name, int price) {
    final existingIndex = _cartItems.indexWhere((item) => item.id == id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(CartItem(id: id, name: name, price: price));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _cartItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}