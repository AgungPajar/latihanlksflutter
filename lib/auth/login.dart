import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../menu/menu_page.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // x-api-key akan diberikan saat lomba mulai
  final String apiKey = "YOUR_X_API_KEY"; // Ganti nanti saat lomba
  final String loginUrl = "https://lks.makeredu.id/auth/login"; 

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> body = {
        "username": _usernameController.text.trim(),
        "password": _passwordController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(loginUrl),
          headers: {
            "Content-Type": "application/json",
            "x-api-key": apiKey,
          },
          body: jsonEncode(body),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Login berhasil, ambil token
          final String token = responseData['data']['token'];

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuPage(token: token)),
            );
          }
        } else if (response.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${responseData['message']}")),
          );
        } else if (response.statusCode == 404) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${responseData['message']}")),
          );
        } else if (response.statusCode == 400) {
          final List<dynamic> errors = responseData['data']['validation'];
          String errorMessage = "Validasi gagal:\n";
          for (var error in errors) {
            errorMessage += "- $error\n";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login gagal: ${responseData['message']}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goToRegister() {
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
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Username"),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username tidak boleh kosong";
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
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
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
                  const Text("Tampilkan Password"),
                ],
              ),
              SizedBox(height: 8),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40),
                      ),
                      child: Text("Login"),
                    ),
              TextButton(
                onPressed: _goToRegister,
                child: Text("Belum punya akun? Daftar di sini"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}