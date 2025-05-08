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
  final CollectionReference productsRef = FirebaseFirestore.instance.collection(
    'products',
  );

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Jar's Market")),
      body: Column(
        children: [
          // Pencarian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
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
          ),

          // Daftar Produk
          StreamBuilder<QuerySnapshot>(
            stream: productsRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("Tidak ada produk"));
              }

              List<QueryDocumentSnapshot> products = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var product = products[index];
                    final productId = product.id;
                    final productName = product['name'];
                    final productPrice = product['price'];

                    final cartItem = cartProvider.cartItems.firstWhere(
                      (item) => item.id == productId,
                      orElse:
                          () =>
                              CartItem(id: '', name: '', price: 0, quantity: 0),
                    );

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Gambar Produk
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product['imageUrl'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ), // Spasi antara gambar dan informasi produk
                            // Informasi Produk
                            Expanded(
                              child: SizedBox(
                                height: 120, // Atur tinggi maksimum kolom
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        product['name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text("Rp. ${product['price']}"),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            Text(
                                              "${product['rating']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),

                                    // Tombol Tambah/Kurang Barang
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                          onPressed: () {
                                            cartProvider.removeItem(productId);
                                          },
                                        ),
                                        Text(cartItem.quantity.toString()),
                                        IconButton(
                                          icon: Icon(Icons.add_circle_outline),
                                          onPressed: () {
                                            cartProvider.addItem(product);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Footer tombol bayar
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

          // Taskbar
          AppBottomBar(
            onHomePressed: () {
              //asdads
            },
            onCartPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            onProfilePressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}
