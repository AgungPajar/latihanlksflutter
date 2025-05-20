import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_bottom_bar.dart';
import '../utils/transaction_status.dart';
import '../utils/balance_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("silakan login terlebih dahulu"),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: Text("Login Sekarang"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text("Tidak ada data pengguna"));
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                physics: BouncingScrollPhysics(), // Agar smooth scroll
                children: [
                  // Header Profil
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          userData['profileImageUrl'] ??
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHhIplIVO-YexrO8Xc_X2m2ZAt_B-y9LX4kA&s',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${userData['username']}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Sambungkan E-Wallet"),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          // Navigasi ke halaman pengaturan
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ],
                  ),

                  // Transaksi
                  SizedBox(height: 24),
                  Text(
                    "Transaksi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TransactionStatus(icon: Icons.payment, label: "Bayar"),
                      TransactionStatus(
                        icon: Icons.local_shipping,
                        label: "Diproses",
                      ),
                      TransactionStatus(
                        icon: Icons.check_circle,
                        label: "Dikirim",
                      ),
                      TransactionStatus(icon: Icons.star, label: "Ulasan"),
                    ],
                  ),

                  // Saldo & Points
                  SizedBox(height: 24),
                  Text(
                    "Saldo & Points",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: BalanceCard(title: "Saldo", amount: "Rp0"),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: BalanceCard(
                          title: "Koin",
                          amount: "Rp0",
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: BalanceCard(
                          title: "Type",
                          amount: "Premium",
                        ),
                      ),
                    ],
                  ),

                  // Rekomendasi Produk
                  SizedBox(height: 24),
                  Text(
                    "Rekomendasi Untuk Anda",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 16 / 9,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        child: Image.network(
                          "https://i.pinimg.com/originals/f7/6d/44/f76d445d12cf0efed588a0fa0a4178ab.jpg",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      // Taskbar
      bottomNavigationBar: AppBottomBar(
        onHomePressed: () {
          Navigator.pushNamed(context, '/menu');
        },
        onCartPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        onProfilePressed: () {
          // Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }
}
