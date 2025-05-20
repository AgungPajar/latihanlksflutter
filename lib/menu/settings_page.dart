import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("Pengaturan Akun")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Ubah Profile
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Ubah Profile"),
            subtitle: Text("Atur Identas dan foto profil kamu"),
            onTap: () {
              // Navigasi ke halaman ubah profile
              Navigator.pushNamed(context, '/edit-profile');
            },
          ),

          // Daftar Alamat
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text("Daftar Alamat"),
            subtitle: Text("Atur Alamat pengiriman belanjaan"),
            onTap: () {
              // Navigasi kehalaman daftar alamat
            },
          ),

          // Keamanan Akun
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Keamanan Akun"),
            subtitle: Text("Kata sandi, PIN & verifikasi data diri"),
            onTap: () {
              // Navigasi kehalaman keamanan
            },
          ),

          // Notifikasi
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifikasi"),
            subtitle: Text("Atur segala jenis pesan notifikasi"),
            onTap: () {
              // Navigasi kehalaman notif
            },
          ),

          // Privasi Akun
          ExpansionTile(
            leading: Icon(Icons.privacy_tip),
            title: Text("Keamanan Akun"),
            subtitle: Text("Kata sandi, PIN & verifikasi data diri"),
            children: [
              ListTile(
                title: Text("Pengaturan privasi"),
                onTap: () {
                  // Navigasi kehalaman privasi
                },
              ),
            ],
          ),

          // Separator
          Divider(),

          // Keluar Akun
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Keluar Akun"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (_) => false,
              );
            },
          ),

          // Versi Aplikasi
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Versi Develop",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
