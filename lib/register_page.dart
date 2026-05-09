import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk menangkap teks dari kolom input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Kunci unik untuk mengontrol status validasi seluruh Form
  final _formKey = GlobalKey<FormState>();

  // Status untuk menyembunyikan atau menampilkan teks password
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Latar belakang gambar utama aplikasi
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_sholat.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Lapisan gelap agar teks input tetap terbaca jelas
          Container(color: Colors.black.withValues(alpha: 0.65)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey, // Menghubungkan Form dengan GlobalKey
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Buat Akun Baru",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- INPUT EMAIL DENGAN VALIDASI FORMAT ---
                    _buildTextField(
                      controller: _emailController,
                      hint: "Email",
                      icon: Icons.email_outlined,
                      isPasswordField: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        // Aturan Regex untuk memastikan format user@email.com
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Gunakan format email valid (contoh: user@gmail.com)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // --- INPUT PASSWORD CAMPURAN HURUF & ANGKA ---
                    _buildTextField(
                      controller: _passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      isPasswordField: true,
                      obscureText: _isObscure,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        // Syarat minimal 6 karakter
                        if (value.length < 6) {
                          return 'Password minimal harus 6 karakter';
                        }
                        // Regex untuk mendeteksi minimal 1 huruf dan 1 angka
                        if (!RegExp(
                          r'^(?=.*[A-Za-z])(?=.*\d)',
                        ).hasMatch(value)) {
                          return 'Password harus campuran huruf dan angka';
                        }
                        return null;
                      },
                      toggleVisibility: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // --- INPUT NOMOR HP HANYA ANGKA ---
                    _buildTextField(
                      controller:
                          _phoneController, // Anda bisa mengganti nama variabel ini nanti jika mau
                      hint: "Nama Lengkap", // Nama kolom berubah jadi Nama
                      icon: Icons.person_outline, // Icon berubah jadi orang
                      type: TextInputType
                          .text, // 'text' memungkinkan input Huruf dan Angka (Bebas)
                      isPasswordField: false,
                      validator: (value) => value == null || value.isEmpty
                          ? "Nama wajib diisi"
                          : null,
                    ),
                    const SizedBox(height: 30),

                    // Tombol untuk mengirim data form
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        // Di dalam tombol DAFTAR (onPressed):
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            // 1. Ambil daftar akun yang sudah ada (kalau belum ada, buat list kosong)
                            List<String> userListRaw =
                                prefs.getStringList('user_list') ?? [];

                            // 2. Buat data user baru
                            Map<String, String> newUser = {
                              'email': _emailController.text.trim(),
                              'password': _passwordController.text.trim(),
                            };

                            // 3. Cek apakah email sudah terdaftar sebelumnya
                            bool isExist = userListRaw.any((item) {
                              Map<String, dynamic> user = json.decode(item);
                              return user['email'] == newUser['email'];
                            });

                            if (isExist) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Email ini sudah terdaftar!"),
                                ),
                              );
                              return;
                            }

                            // 4. Masukkan ke dalam list dan simpan secara permanen
                            userListRaw.add(json.encode(newUser));
                            await prefs.setStringList('user_list', userListRaw);

                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Akun berhasil dibuat!",
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "DAFTAR",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Navigasi untuk kembali ke halaman login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Masuk di sini",
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

  // --- FUNGSI HELPER TEXTFIELD (MODULAR) ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isPasswordField,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPasswordField ? obscureText : false,
      keyboardType: type,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: toggleVisibility,
              )
            : null,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.2),
        // Pesan peringatan berwarna kuning sesuai permintaan
        errorStyle: const TextStyle(color: Colors.yellowAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
