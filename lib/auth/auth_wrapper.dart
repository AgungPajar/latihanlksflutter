import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../auth/login.dart';
import '../menu/menu_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isAuthenticated) {
      return MenuPage(); // Arahkan ke menu utama jika sudah login
    } else {
      return LoginPage(); // Jika belum login, arahkan ke halaman login
    }
  }
}