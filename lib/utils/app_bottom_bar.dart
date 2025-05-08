import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home), 
            onPressed: onHomePressed
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart), 
                onPressed: onCartPressed,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: userId != null
                  ? FirebaseFirestore.instance
                    .collection("cart")
                    .doc(userId)
                    .collection("items")
                    .snapshots()
                  : const Stream<QuerySnapshot>.empty(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData){
                    int count = snapshot.data!.docs.length;
                      return Positioned(
                        top: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            "$count",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Container();
                    }

                    return Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          "0",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    );
                  },
              )
            ],
          ),
          IconButton(icon: Icon(Icons.person), onPressed: onProfilePressed),
        ],
      ),
    );
  }
}
