import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Pastikan package http sudah diinstal
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // x-api-key akan diberikan saat lomba dimulai
  final String apiKey = "YOUR_X_API_KEY"; // Ganti nanti saat lomba
  final String registerUrl = "https://lks.makeredu.id/auth/register"; 

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> body = {
        "username": _usernameController.text.trim(),
        "fullname": _fullnameController.text,
        "address": _addressController.text,
        "password": _passwordController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(registerUrl),
          headers: {
            "Content-Type": "application/json",
            "x-api-key": apiKey,
          },
          body: jsonEncode(body),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Registrasi berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registrasi berhasil")),
          );
          Navigator.pop(context); // Kembali ke halaman login
        } else if (response.statusCode == 409) {
          // Username sudah ada
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${responseData['message']}")),
          );
        } else if (response.statusCode == 400) {
          // Validasi gagal
          final List<dynamic> errors = responseData['data']['validation'];
          String errorMessage = "Validasi gagal:\n";
          for (var error in errors) {
            errorMessage += "- $error\n";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        } else {
          // Server error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registrasi gagal: ${responseData['message']}")),
          );
        }
      } catch (e) {
        // Error network / exception
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar")),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _fullnameController,
                decoration: InputDecoration(labelText: "Nama Lengkap"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama lengkap tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Alamat"),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Alamat harus diisi";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
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
                  if (value.length < 4) {
                    return "Password minimal 4 karakter";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Konfirmasi Password",
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
                    return "Ulangi password";
                  }
                  if (value != _passwordController.text) {
                    return "Password tidak sama";
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
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40),
                      ),
                      child: Text("Daftar"),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Sudah punya akun? Masuk disini"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}