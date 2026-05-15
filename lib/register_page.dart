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
                    const Text(
                      "Buat Akun Baru",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      _nameController,
                      "Nama Lengkap",
                      Icons.person,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(_emailController, "Email", Icons.email),
                    const SizedBox(height: 15),
                    _buildTextField(
                      _passwordController,
                      "Password",
                      Icons.lock,
                      isPass: true,
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
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Sudah punya akun? Login",
                        style: TextStyle(color: Colors.white70),
                      ),
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
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPass ? _isObscure : false,
      style: const TextStyle(color: Colors.white),
      validator: (value) =>
          value == null || value.isEmpty ? "Bidang ini wajib diisi" : null,
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

      bool isEmailExists = userListRaw.any((item) {
        Map<String, dynamic> user = json.decode(item);
        return user['email'] == email;
      });

      if (isEmailExists) {
        // Cek apakah widget masih aktif sebelum menggunakan context (perbaikan async gap)
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email ini sudah terdaftar!")),
        );
        return;
      }

      Map<String, String> newUser = {
        'email': email,
        'password': _passwordController.text.trim(),
        'name': _nameController.text.trim(),
      };

      userListRaw.add(json.encode(newUser));
      await prefs.setStringList('user_list', userListRaw);

      // Cek apakah widget masih aktif sebelum navigasi (perbaikan async gap)
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi Berhasil! Silakan Login.")),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
