import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../menu/menu_page.dart';
import '../auth/login.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // if (!context.mounted) return Container();

        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user != null) {
            return MenuPage();
          } else {
            return LoginPage();
          }
        }

        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
