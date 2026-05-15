# Bacaan sholat & doa

**Tujuan** aplikasi : Aplikasi ini adalah platform mobile edukasi yang dirancang untuk membantu pengguna mempelajari, menghafal, dan mengakses kumpulan niat ibadah serta doa-doa secara praktis.

## Fokus pengembangan

- Arsitektur Dasar & Navigasi
- UI login & Register
- Slicing UI Beranda (Dashboard)
- Content & List Data (Menu Sholat & Doa)
- Finishing, Bug Fixing & Dokumentasi

## Fitur Utama & Fitur Pengguna

1. Manajemen Akun Personal: Mendukung multi-user dalam satu perangkat tanpa tumpang tindih data.

2. Autentikasi Keamanan: Login menggunakan email/password dengan fitur "Lihat Password".

3. rofil Pengguna: Menampilkan identitas personal seperti Nama dan Program Studi (Informatics Engineering).

4. Dashboard Ibadah:
   Menu Sholat: Navigasi lengkap untuk kategori Wajib dan Sunnah dengan tampilan kartu yang elegan.
   Menu Doa: Area khusus yang telah disiapkan untuk kumpulan doa harian aktivitas.

5. Offline Data Persistence: Akses data tetap tersedia tanpa koneksi internet menggunakan

## Komponen Teknis

- Bahasa Pemrograman: Dart

- Framework: Flutter (Material 3)

- Penyimpanan Lokal: shared_preferences (Serialisasi JSON untuk data user)

- Navigasi: Named Routes dan BottomNavigationBar untuk perpindahan antar menu (Sholat, Doa, Profil).

## Struktur Direktori (Susunan File)

/
├── assets/
│ └── images/
│ └── bg_sholat.png # Gambar latar belakang aplikasi
├── lib/
│ ├── main.dart # Konfigurasi rute utama
│ ├── login_page.dart # Logika verifikasi akun
│ ├── register_page.dart # Logika pendaftaran user baru
│ └── home_page.dart # Dashboard utama (Sholat, Doa, Profil)
├── pubspec.yaml # Dependensi & deklarasi aset
└── README.md # Dokumentasi & Blueprint proyek

## Cara Menjalankan Program

1. Persiapan: Pastikan Flutter SDK sudah terinstal.

2. Instalasi Dependensi: Jalankan flutter pub get di terminal proyek.

3. Pastikan file assets/images/bg_sholat.png sudah tersedia di folder proyek agar gambar latar belakang muncul dengan benar.

4. Menjalankan Aplikasi: Ketik flutter run di terminal atau tekan F5 di VS Code.
