import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_sholat.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.65)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Buat Akun Baru",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Field Nama
                    _buildTextField(
                      _nameController,
                      "Nama Lengkap",
                      Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Nama wajib diisi";
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Field Email dengan validasi format
                    _buildTextField(
                      _emailController,
                      "Email",
                      Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Email wajib diisi";
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return "Format email tidak valid (contoh: user@gmail.com)";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Field Password dengan minimal 6 karakter
                    _buildTextField(
                      _passwordController,
                      "Password",
                      Icons.lock,
                      isPass: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Password wajib diisi";
                        if (value.length < 6)
                          return "Password minimal 6 karakter";
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _handleRegister,
                        child: const Text(
                          "DAFTAR SEKARANG",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.tealAccent,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
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

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPass = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPass ? _isObscure : false,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: isPass
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              )
            : null,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        errorStyle: const TextStyle(color: Colors.yellowAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> userListRaw = prefs.getStringList('user_list') ?? [];
      String email = _emailController.text.trim();

      // Cek apakah email sudah terdaftar
      bool isEmailExists = userListRaw.any((item) {
        Map<String, dynamic> user = json.decode(item);
        return user['email'] == email;
      });

      if (isEmailExists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email ini sudah terdaftar! Gunakan email lain."),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // Simpan User Baru
      Map<String, String> newUser = {
        'email': email,
        'password': _passwordController.text.trim(),
        'name': _nameController.text.trim(),
      };

      userListRaw.add(json.encode(newUser));
      await prefs.setStringList('user_list', userListRaw);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi Berhasil! Silakan Login.")),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
