import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../invoice/invoice_page.dart';
import '../utils/app_bottom_bar.dart';

class MenuPage extends StatefulWidget {
  final String? token;

  const MenuPage({super.key, this.token});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<dynamic> products = [];
  bool _isLoading = true;

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://lks.makeredu.id/products'), 
        headers: {
          "Authorization": "Bearer ${widget.token}",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'];
        setState(() {
          products = responseData;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat produk")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LKS Mart")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(hintText: "Cari Item"),
                      onChanged: (value) {
                        // Logika pencarian bisa ditambahkan di sini
                      },
                    ),
                  ),
                  IconButton(icon: Icon(Icons.search), onPressed: () {}),
                ],
              ),

              SizedBox(height: 16),

              // Daftar Produk
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else if (products.isEmpty)
                Center(child: Text("Tidak ada produk"))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(product['image']),
                          ),
                          title: Text(product['name']),
                          subtitle: Text("Rp. ${product['price']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Text("${product['rating']}", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          onTap: () {
                            final cart = Provider.of<CartProvider>(context, listen: false);

                            cart.addItem(
                              product['id'].toString(),
                              product['name'],
                              product['price'], // Harus bertipe int
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Ditambahkan ke keranjang")),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

              // Tombol Bayar Sekarang
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    final cart = Provider.of<CartProvider>(context, listen: false);

                    if (cart.cartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Silakan pilih produk terlebih dahulu")),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InvoicePage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bayar Sekarang"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        onHomePressed: () {},
        onCartPressed: () {
          final cart = Provider.of<CartProvider>(context, listen: false);
          if (cart.cartItems.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InvoicePage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Keranjang kosong")),
            );
          }
        },
        onProfilePressed: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }
}