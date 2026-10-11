Pertemuan 5: Penyimpanan Lokal (SharedPreferences & SQLite)

Repositori ini berisi hasil pengerjaan praktikum dan tugas mandiri Pemrograman Mobile untuk Pertemuan 5, yang berfokus pada implementasi penyimpanan lokal (local storage) pada aplikasi Flutter.

🎯 Tujuan Pembelajaran

Sesuai dengan modul praktikum, proyek dalam direktori ini bertujuan agar mahasiswa mampu:

Memilih jenis penyimpanan lokal yang tepat (key-value, database, atau berkas).

Menyimpan dan membaca pengaturan sederhana menggunakan paket shared_preferences.

Merancang tabel dan membuat database SQLite menggunakan paket sqflite.

Mengimplementasikan operasi CRUD (Create, Read, Update, Delete) dan menghubungkannya dengan UI (Antarmuka Pengguna).

Memastikan persistensi data (data tetap ada setelah aplikasi ditutup dan dibuka kembali).

📁 Struktur Direktori

Proyek pada pertemuan ini dibagi menjadi dua bagian utama:

praktikum_5/
Berisi implementasi terpandu dari modul:

Bagian A: Penggunaan shared_preferences untuk menyimpan pengaturan sederhana (nama, preferensi tema gelap/terang, dan penghitung jumlah buka aplikasi).

Bagian B-D: Implementasi sqflite untuk membuat aplikasi "Catatan Saya" dengan operasi CRUD lengkap. Termasuk latihan mandiri (pencarian, konfirmasi hapus, dll).

tugas_pengeluaran/
Berisi tugas mandiri berupa aplikasi Pencatat Pengeluaran yang menerapkan operasi CRUD menggunakan SQLite, validasi form, perhitungan total, serta penyimpanan pengaturan dengan SharedPreferences.

🛠️ Paket yang Digunakan (Dependencies)

shared_preferences - Untuk penyimpanan data key-value.

sqflite - Plugin SQLite untuk Flutter.

path - Manipulasi path untuk direktori database.

🚀 Cara Menjalankan

Pastikan Anda sudah berada di dalam direktori proyek yang ingin dijalankan (praktikum_5 atau tugas_pengeluaran).

Jalankan perintah flutter pub get untuk mengunduh semua dependensi.

Jalankan aplikasi menggunakan perintah flutter run atau melalui Run/Debug di VS Code.