import 'package:flutter/material.dart'; //Ini adalah import paling dasar dan wajib di Flutter.
import 'login_page.dart'; //Menghubungkan file utama dengan halaman Login.
import 'register_page.dart'; //Menghubungkan file utama dengan halaman Pendaftaran (Register).
import 'home_page.dart'; //menghubungkan file utama dengan halaman Beranda (Home).

void main() {
  // Fungsi utama yang menjalankan aplikasi Flutter pertama kali
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Niat & Doa',
      debugShowCheckedModeBanner:
          false, // Menghilangkan tulisan "Debug" di pojok kanan atas
      theme: ThemeData(
        // Mengatur warna dasar aplikasi menggunakan warna Teal
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true, // Mengaktifkan komponen desain Material 3 terbaru
      ),
      // Menentukan halaman yang pertama kali muncul saat aplikasi dibuka
      home: const LoginPage(),
      // Daftar rute (alamat) halaman untuk navigasi antar layar
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
