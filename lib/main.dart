import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'auth/login.dart';
import 'auth/register.dart';
import 'menu/menu_page.dart';
import 'invoice/invoice_page.dart';
import 'profile/profile_page.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LKS Mart Mobile',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/menu': (context) => MenuPage(),
        '/invoice': (context) => InvoicePage(),
        '/profile': (context) => ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}