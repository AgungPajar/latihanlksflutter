import 'package:flutter/material.dart';

class AppBottomBar extends StatelessWidget {
  final void Function()? onHomePressed;
  final void Function()? onCartPressed;
  final void Function()? onProfilePressed;

  const AppBottomBar({
    Key? key,
    this.onHomePressed,
    this.onCartPressed,
    this.onProfilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: Icon(Icons.home), onPressed: onHomePressed),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: onCartPressed),
          IconButton(icon: Icon(Icons.person), onPressed: onProfilePressed),
        ],
      ),
    );
  }
}
