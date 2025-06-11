import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

// Providers
import '../providers/auth_provider.dart';

// Widgets
import '../utils/app_bottom_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  Map<String, dynamic>? userData;

  Future<void> fetchProfile(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    String token = authProvider.token!;

    try {
      final response = await http.get(
        Uri.parse('https://lks.makeredu.id/auth/profile'), 
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'];

        setState(() {
          userData = responseData;
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        authProvider.clearToken();
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat profil")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProfile(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Pengguna"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.clearToken();

              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : userData == null
                  ? Center(child: Text("Tidak ada data profil"))
                  : ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        // Informasi Profil
                        Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nama Lengkap",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(userData!['fullname'] ?? '-'),
                                SizedBox(height: 8),
                                Text(
                                  "Username",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(userData!['username'] ?? '-'),
                                SizedBox(height: 8),
                                Text(
                                  "Alamat",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(userData!['address'] ?? '-'),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 24),

                        // Status Transaksi (Dummy)
                        Text(
                          "Transaksi",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTransactionStatus(Icons.payment, "Bayar"),
                            _buildTransactionStatus(Icons.local_shipping, "Diproses"),
                            _buildTransactionStatus(Icons.check_circle, "Dikirim"),
                            _buildTransactionStatus(Icons.star, "Ulasan"),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Saldo & Points (Placeholder)
                        Text(
                          "Saldo & Points",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildBalanceCard("Saldo", "Rp0"),
                            SizedBox(width: 8),
                            _buildBalanceCard("Koin", "100"),
                            SizedBox(width: 8),
                            _buildBalanceCard("Type", "Premium"),
                          ],
                        ),
                      ],
                    ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        onHomePressed: () {
          Navigator.pushReplacementNamed(context, '/menu');
        },
        onCartPressed: () {
          Navigator.pushReplacementNamed(context, '/cart');
        },
        onProfilePressed: () {
          // Tetap di halaman profile
        },
      ),
    );
  }

  Widget _buildTransactionStatus(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildBalanceCard(String title, String amount) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}