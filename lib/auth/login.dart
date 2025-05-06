import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../menu/menu_page.dart'; // Ganti dengan path sesuai struktur project kamu
import 'register.dart'; // Halaman registrasi

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text;

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = "Terjadi kesalahan";
        if (e.code == 'user-not-found') {
          message = 'User tidak ditemukan.';
        } else if (e.code == 'wrong-password') {
          message = 'Password salah.';
        } else {
          message = e.message ?? "Error";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message))
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login gagal: $e")));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _register() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email tidak boleh kosong";
                  }
                  if (!value.contains("@")) {
                    return "Email tidak valid!";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: !_obscurePassword,
                    onChanged: (value) {
                      setState(() {
                        _obscurePassword = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  const Text("Tampilkan Password"),
                ],
              ),
              SizedBox(height: 8),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _login,
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40),
                    ),
                  ),
              TextButton(
                onPressed: _register,
                child: Text("Belum punya akun? Daftar di sini"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
