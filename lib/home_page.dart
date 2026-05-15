import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("Konfirmasi Keluar"),
          content: const Text("Apakah anda ingin Keluar dari beranda?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Batal",
                style: TextStyle(color: Color.fromARGB(255, 14, 11, 11)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                ); // Pindah ke Login
              },
              child: const Text(
                "Keluar",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // List halaman untuk navigasi
    final List<Widget> pages = [
      _buildSholatMenu(),
      _buildDoaMenu(),
      _buildProfileCard(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Beranda",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: "Sholat",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.mosque), label: "Doa"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          ],
        ),
      ),
    );
  }

  // --- MENU SHOLAT ---
  Widget _buildSholatMenu() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeaderSection(
          "Bacaan Sholat",
          "Pilih kategori fardu atau sunnah",
        ),
        const SizedBox(height: 25),
        const Text(
          "SHOLAT WAJIB",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
        const Divider(),
        _buildCategoryCard(
          "Fardu 'Ain",
          "Wajib individu (5 Waktu)",
          Icons.person,
          Colors.teal,
        ),
        _buildCategoryCard(
          "Fardu Kifayah",
          "Wajib kelompok (Jenazah)",
          Icons.group,
          Colors.teal.shade700,
        ),
        const SizedBox(height: 25),
        const Text(
          "SHOLAT SUNNAH",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
        const Divider(),
        _buildCategoryCard(
          "Sunnah Muakkad",
          "Sangat dianjurkan",
          Icons.auto_awesome,
          Colors.orange,
        ),
        _buildCategoryCard(
          "Sunnah Ghairu Muakkad",
          "Sunnah pelengkap",
          Icons.wb_sunny_outlined,
          Colors.orange.shade700,
        ),
      ],
    );
  }

  // --- MENU DOA  ---
  Widget _buildDoaMenu() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeaderSection(
          "Kumpulan Doa",
          "Area ini akan diisi dengan daftar doa nanti",
        ),
        const SizedBox(height: 80),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty_rounded,
                size: 80,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                "Kumpulan doa dikosongkan sementara.\nSiap untuk dikerjakan nanti.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- PROFIL PENGGUNA ---
  Widget _buildProfileCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(30),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 15),
              ],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Akhmad",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Informatics Engineering",
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(),
                ),
                _buildInfoRow(Icons.email, "akhmad@student.com"),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.location_on, "Surabaya, Indonesia"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildHeaderSection(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
      ],
    );
  }

  Widget _buildCategoryCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(top: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        onTap: () {
          // Navigasi detail bisa ditambahkan di sini nanti
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal.shade300, size: 22),
        const SizedBox(width: 15),
        Text(text, style: const TextStyle(fontSize: 15, color: Colors.black54)),
      ],
    );
  }
}
