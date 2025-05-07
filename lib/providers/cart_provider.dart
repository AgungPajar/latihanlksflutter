import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String name;
  final int price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Menyimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(String id, Map<String, dynamic> map) {
    return CartItem(
      id: id,
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }

  void incrementQuantity() {
    quantity++;
  }
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];
  final CollectionReference cartRef = FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('items');

  List<CartItem> get cartItems => _cartItems;

  CartProvider() {
    loadFromFirestore();
  }

  void addItem(DocumentSnapshot product) {
    final productId = product.id;
    final productName = product['name'];
    final productPrice = product['price'];

    // Cek apakah produk sudah ada di keranjang
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.id == productId,
    );

    if (existingItemIndex >= 0) {
      final existingItem = _cartItems[existingItemIndex];
      existingItem.incrementQuantity();
    } else {
      final newItem = CartItem(
        id: productId,
        name: productName,
        price: productPrice,
        quantity: 1,
      );
    }
    notifyListeners();
    saveToFirestore();
  }

  void removeItem(String productId) {
    _cartItems.removeWhere((item) => item.id == productId);
    notifyListeners();
    saveToFirestore();
  }

  Future<void> saveToFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final batch = FirebaseFirestore.instance.batch();

    // menghapus item lama
    final snapshot = await cartRef.get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    for (var item in _cartItems) {
      batch.set(cartRef.doc(item.id), item.toMap());
    }

    await batch.commit();
  }

  Future<void> loadFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // menghapus item lama
    final snapshot = await cartRef.get();
    _cartItems.clear();

    for (var doc in snapshot.docs) {
      final item = CartItem.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      _cartItems.add(item);
    }

    notifyListeners();
  }

  int getTotalPrice() {
    return _cartItems.fold(
      0,
      (total, cartItem) => total + (cartItem.price * cartItem.quantity),
    );
  }
}
