import 'package:flutter/material.dart';
import '../utils/app_bottom_bar.dart'; // Import custom taskbar

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Keranjang Belanja")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Dummy 3 item
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(child: Icon(Icons.fastfood)),
                      title: Text("Coca-Cola"),
                      subtitle: Text("Rp. 7000 x 2"),
                      trailing: Text("Rp. 14000"),
                    ),
                  );
                },
              ),
            ),

            // Tombol Checkout
            ElevatedButton.icon(
              onPressed: null,
              icon: Icon(Icons.payment),
              label: Text("Lanjutkan ke Pembayaran"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
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
