import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Produk"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Produk tidak ditemukan"));
          }

          final product = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Image.network(
                product['imageUrl'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),

              Text(
                product['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              Text(
                "Rp. ${product['price']}",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  Text("${product['rating']}", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 16),

              // Tombol Tambah/Kurang Barang
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      cartProvider.removeItem(productId);
                    },
                  ),
                  Text(cartProvider.getQuantity(productId).toString()),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      cartProvider.addItem(snapshot.data!);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}