import 'dart:convert'; // WAJIB TAMBAH INI
import 'package:flutter/material.dart';
// ... import yang sudah ada
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller: Digunakan untuk mengambil teks yang diketik user di kolom input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // GlobalKey: Digunakan untuk memvalidasi apakah form sudah diisi atau belum
  final _formKey = GlobalKey<FormState>();

  // Variabel untuk mengatur apakah password disembunyikan (true) atau diperlihatkan (false)
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background: Menampilkan gambar latar belakang dari folder assets
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_sholat.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay: Memberikan lapisan warna gelap agar teks di atas gambar terlihat jelas
          Container(color: Colors.black.withValues(alpha: 0.6)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey, // Menghubungkan Form dengan kunci validasi
                child: Column(
                  children: [
                    // Menampilkan ikon buku di bagian atas
                    const Icon(
                      Icons.menu_book_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    // Judul Aplikasi
                    const Text(
                      "Bacaan sholat & Doa",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Input Email
                    TextFormField(
                      controller: _emailController,
                      // --- TAMBAHKAN VALIDATOR DI SINI ---
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        // Regex untuk mengecek format email yang valid
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Masukkan format email yang valid (contoh: user@gmail.com)';
                        }
                        return null;
                      },
                      // -----------------------------------
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.white70,
                        ),
                        hintText: "Email",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                        errorStyle: const TextStyle(color: Colors.yellowAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Input Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      // --- TAMBAHKAN VALIDATOR DI SINI ---
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        // Cek apakah mengandung huruf DAN angka
                        if (!RegExp(
                          r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
                        ).hasMatch(value)) {
                          return 'Password harus campuran huruf dan angka';
                        }
                        return null;
                      },
                      // -----------------------------------
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        hintText: "Password",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                        errorStyle: const TextStyle(color: Colors.yellowAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // tombol LOGIN
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        // Di dalam tombol LOGIN (onPressed):
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            // 1. Ambil daftar semua akun yang tersimpan
                            List<String> userListRaw =
                                prefs.getStringList('user_list') ?? [];

                            String inputEmail = _emailController.text.trim();
                            String inputPass = _passwordController.text.trim();

                            // 2. Cari apakah ada email dan password yang cocok di dalam list
                            bool loginSuccess = false;
                            for (String item in userListRaw) {
                              Map<String, dynamic> user = json.decode(item);
                              if (user['email'] == inputEmail &&
                                  user['password'] == inputPass) {
                                loginSuccess = true;
                                break;
                              }
                            }

                            if (!mounted) return;

                            if (loginSuccess) {
                              // Login Berhasil
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              // Login Gagal
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Email atau Password salah/tidak ditemukan!",
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Teks untuk menuju halaman daftar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Belum punya akun? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            "Daftar Sekarang",
                            style: TextStyle(
                              color: Colors.tealAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
