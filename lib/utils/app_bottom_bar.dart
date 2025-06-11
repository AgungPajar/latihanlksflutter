import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../../providers/cart_provider.dart';

class AppBottomBar extends StatelessWidget {
  final void Function()? onHomePressed;
  final void Function()? onCartPressed;
  final void Function()? onProfilePressed;

  const AppBottomBar({
    super.key,
    this.onHomePressed,
    this.onCartPressed,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Garis pembatas
        Container(
          height: 1,
          color: Colors.grey[300],
        ),

        // Taskbar bawah
        BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: Icon(Icons.home), onPressed: onHomePressed),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: onCartPressed,
                  ),
                  if (cart.totalItem > 0)
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        "${cart.totalItem}",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                ],
              ),
              IconButton(icon: Icon(Icons.person), onPressed: onProfilePressed),
            ],
          ),
        ),
      ],
    );
  }
}