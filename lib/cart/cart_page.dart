import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text("Keranjang Belanja")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection('cart')
          .doc(uid)
          .collection('items')
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Keranjang kosong"),);
          }

          List<QueryDocumentSnapshot> cartItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              var item = cartItems[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.shopping_cart),
                ),
                title: Text(item['name']),
                subtitle: Text("Rp. ${item['price'] * item['quantity']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        FirebaseFirestore.instance
                          .collection('cart')
                          .doc(uid)
                          .collection('items')
                          .doc(item.id)
                          .update({'quantity': FieldValue.increment(-1)});
                      },
                    ),
                    Text("${item['quantity']}"),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        FirebaseFirestore.instance
                          .collection('cart')
                          .doc(uid)
                          .collection('items')
                          .doc(item.id)
                          .update({'quantity': FieldValue.increment(1)});
                      },
                    )
                  ],
                ),
              );
            },
          );
        }
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
