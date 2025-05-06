import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'menu_item.dart';
import 'invoice.dart';

class MenuPage extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(name: "Coca-Cola", price: 7000, image: "assets/marjan.png"),
    MenuItem(name: "Fanta", price: 7000, image: "assets/marjan.png"),
    MenuItem(name: "Oreo", price: 2000, image: "assets/marjan.png"),
  ];

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Menu Food XYZ")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(decoration: InputDecoration(hintText: "Cari item")),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return ListTile(
                  leading: Image.asset(item.image, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text("Rp. ${item.price}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => cart.removeItem(item),
                      ),
                      Text("${item.quantity}"),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => cart.addItem(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          cart.addItem(item);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InvoicePage()),
                );
              },
              child: Text("Bayar Sekarang - Rp. ${cart.totalPrice}"),
            ),
          ),
        ],
      ),
    );
  }
}
