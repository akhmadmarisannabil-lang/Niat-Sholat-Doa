# Bacaan sholat & doa

**Tujuan** aplikasi : Aplikasi ini adalah platform mobile edukasi yang dirancang untuk membantu pengguna mempelajari, menghafal, dan mengakses kumpulan niat ibadah serta doa-doa secara praktis.

## Fitur Utama & Fitur Pengguna

1. **Manajemen Akun Personal (Multi-User)**:
   - Pengguna dapat mendaftarkan akun lebih dari satu dalam satu perangkat.
   - Akun bersifat permanen dan tidak akan saling menimpa data satu sama lain.
2. **Autentikasi Keamanan**:
   - Pengguna dapat masuk (Login) menggunakan email dan password yang telah didaftarkan.
   - Fitur "Lihat Password" untuk memastikan ketepatan input saat login/daftar.
3. **Profil Pengguna**:
   - Pengguna dapat menginput Nama Lengkap (menggunakan teks bebas/angka) sebagai identitas profil di dalam aplikasi.
4. **Offline Data Persistence**:
   - Pengguna tetap dapat mengakses aplikasi meskipun tanpa koneksi internet karena data tersimpan di memori lokal HP.
5. **UI Interaktif**:
   - Pengalaman membaca yang nyaman dengan latar belakang religi dan overlay gelap untuk mengurangi kelelahan mata.

## Komponen Teknis

- **Bahasa Pemrograman**: Dart
- **Framework**: Flutter (Material 3)
- **Penyimpanan Lokal**: `shared_preferences` (Menyimpan daftar user dalam format JSON string).
- **Format Data**: JSON (`dart:convert`) untuk serialisasi objek user.
- **Navigasi**: Named Routes untuk perpindahan antar halaman.

## Struktur Direktori (Susunan File)

```text
/
├── assets/
│   └── images/
│       └── bg_sholat.png      # Gambar latar belakang aplikasi
├── lib/
│   ├── main.dart              # Titik masuk aplikasi & konfigurasi rute
│   ├── login_page.dart        # Halaman masuk & logika verifikasi akun
│   ├── register_page.dart     # Halaman daftar & logika simpan JSON List
│   └── home_page.dart         # Dashboard utama setelah berhasil login
├── pubspec.yaml               # Deklarasi dependensi & aset gambar
└── README.md                  # Dokumentasi blueprint
```

## Cara Menjalankan Program

1. Persiapan: Pastikan Flutter SDK sudah terinstal.

2. Instalasi Dependensi: Jalankan flutter pub get di terminal proyek.

3. Pendaftaran Aset: Pastikan assets/images/bg_sholat.png sudah terdaftar di pubspec.yaml.

4. Menjalankan Aplikasi: Ketik flutter run di terminal atau tekan F5 di VS Code.
