import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ppp/menu/edit_profile_page.dart';
import 'package:ppp/menu/product_detail_page.dart';
import 'package:provider/provider.dart';

//screens
import 'auth/auth_wrapper.dart';
import 'auth/login.dart';
import 'menu/menu_page.dart';
import 'menu/settings_page.dart';
import 'cart/cart_page.dart';
import 'profile/profile_page.dart';

// Provider
import '../providers/cart_provider.dart';

void main() async {
  // runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: AuthWrapper(),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/login': (context) => LoginPage(),
        '/menu': (context) => MenuPage(),
        '/cart': (context) => CartPage(),
        '/profile': (context) => ProfilePage(),
        '/settings': (context) => SettingsPage(),
        '/edit-profile': (context) => EditProfilePage(),
        '/product-detail': (context) => ProductDetailPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
