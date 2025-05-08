import 'package:flutter/material.dart';
import 'package:ppp/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../utils/app_bottom_bar.dart'; // Import custom taskbar
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Silakan login lebih dulu"),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text("Login sekarang"),
            ),
          ],
        ),
      );
    }

    final cartProvider = Provider.of<CartProvider>(context);
    // final totalPrice = cartProvider.getTotalPrice();

    return Scaffold(
      appBar: AppBar(title: Text("Keranjang Belanja")),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('cart')
                .doc(uid)
                .collection('items')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Keranjang kosong"));
          }

          List<QueryDocumentSnapshot> cartItems = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return ListTile(
                      leading: CircleAvatar(child: Icon(Icons.shopping_cart)),
                      title: Text(item['name']),
                      subtitle: Text("Rp. ${item['price'] * item['quantity']}"),
                      trailing: Text("${item['quantity']}"),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, '/payment');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bayar Sekarang"),
                      Text("Rp. ${cartProvider.getTotalPrice()}"),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: AppBottomBar(
        onHomePressed: () {
          Navigator.pushNamed(context, '/menu');
        },
        onCartPressed: () {
          // Tetap di halaman keranjang
        },
        onProfilePressed: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }
}
