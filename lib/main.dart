import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

//screens
import 'auth/auth_wrapper.dart';

// Provider
// import 'providers/cart_provider.dart';

void main() async {
  // runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}