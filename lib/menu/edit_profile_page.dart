import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Gambar Profil
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user?.photoURL ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHhIplIVO-YexrO8Xc_X2m2ZAt_B-y9LX4kA&s'),

            ),
            SizedBox(height: 16,),

            // Ubah foto profil
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman up foto
              },
              child: Text("Ubah foto Profil"),
            ),

            // Info Profil
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Nama"),
              subtitle: Text("Agung Pajar"),
              trailing: Icon(Icons.edit),
              onTap: () {
                // Navigasi Ke halaman ubah nama
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Username"),
              subtitle: Text("agungpajar084@gmail.com"),
              trailing: Icon(Icons.edit),
              onTap: () {
                // Navigasi Ke halaman ubah username
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Bio"),
              subtitle: Text("Tulis bio tentangmu"),
              trailing: Icon(Icons.edit),
              onTap: () {
                // Navigasi Ke halaman ubah nama
              },
            ),
            // separator
            Divider(),
            // Info pribadi
            ListTile(
              leading: Icon(Icons.info),
              title: Text("User ID"),
              subtitle: Text(user?.uid ?? ""),
              trailing: Icon(Icons.edit),
              onTap: () {
                // Salin User ID ke Clipboard
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("E-mail"),
              subtitle: Text(user?.email?? ""),
              trailing: Icon(Icons.edit),
              onTap: () {
                // Navigasi Ke halaman ubah Email
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("Nomor HP"),
              subtitle: Text("6282354464454"),
              trailing: Icon(Icons.edit),
              onTap: () {
                // Navigasi Ke halaman ubah nama
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Jenis Kelamin"),
              subtitle: Text("Pilih"),
              trailing: Icon(Icons.edit),
              onTap: () {
                // Navigasi Ke halaman ubah nama
              },
            ),
            ListTile(
              leading: Icon(Icons.cake),
              title: Text("Tanggal lahir"),
              subtitle: Text("pilih"),
              trailing: Icon(Icons.edit),
              onTap: () {
                // Navigasi Ke halaman ubah nama
              },
            ),

            // Tombol hapus akun
            ElevatedButton(
              onPressed: () {
                // Navigasi ke konfirmasi tutup akun
              },
              child: Text("Tutup Akun"),
            ),
          ],
        ),
      ),
    );
  }
}
