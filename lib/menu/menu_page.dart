import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_bottom_bar.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final CollectionReference productsRef = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Pencarian
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Cari Item",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.search), onPressed: () {}),
                ],
              ),

              // Spasi antara pencarian dan daftar produk
              SizedBox(height: 16),

              // Daftar Produk
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: productsRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("Tidak ada produk"));
                    }

                    List<QueryDocumentSnapshot> products = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        var product = products[index];
                        final productId = product.id;
                        final productName = product['name'];
                        final productPrice = product['price'];

                        final cartItem = cartProvider.cartItems.firstWhere(
                          (item) => item.id == productId,
                          orElse: () => CartItem(id: '', name: '', price: 0, quantity: 0),
                        );

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 1),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(product['imageUrl'] ?? ''),
                            ),
                            title: Text(productName),
                            subtitle: Text("Rp. ${productPrice}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                Text("${product['rating']}", style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Footer tombol bayar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/cart');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("CheckOut"),
                      Text("Rp. ${cartProvider.getTotalPrice()}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        onHomePressed: () {
          // Tetap di halaman ini
        },
        onCartPressed: () {
          Navigator.pushReplacementNamed(context, '/cart');
        },
        onProfilePressed: () {
          Navigator.pushReplacementNamed(context, '/profile');
        },
      ),
    );
  }
}