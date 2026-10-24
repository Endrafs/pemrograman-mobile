TabungKu - Mini Proyek Terpadu 🚀

TabungKu adalah aplikasi To-Do List sekaligus Manajemen Keuangan sederhana yang dibangun menggunakan Flutter. Aplikasi ini dirancang khusus untuk membantu mahasiswa mencatat kegiatan sehari-hari (kuliah, nongkrong, kerja paruh waktu) sekaligus melacak arus kas (pemasukan dan pengeluaran) dari kegiatan tersebut guna membangun kebiasaan menabung yang baik.

Aplikasi ini merupakan tugas akhir untuk Praktikum 7 Flutter Fundamental, menggabungkan seluruh materi mulai dari tata letak dasar, validasi form, navigasi, animasi, hingga penyimpanan lokal (SQLite & Shared Preferences).

✨ Daftar Fitur

Aplikasi ini telah memenuhi seluruh kriteria wajib (F1 - F8) dari modul praktikum:

Manajemen Kegiatan (CRUD): Tambah, lihat, ubah, dan hapus kegiatan (dengan dialog konfirmasi) serta centang status selesai.

Formulir Cerdas & Tervalidasi: Form input yang secara dinamis menampilkan kolom nominal dan kategori hanya jika jenis keuangan diatur ke "Pemasukan" atau "Pengeluaran".

Penyimpanan Lokal (SQLite): Semua data kegiatan tersimpan secara permanen di perangkat menggunakan arsitektur tabel yang rapi.

Ringkasan Hari Ini: Kartu dashboard beranimasi yang menampilkan total kegiatan, pemasukan, pengeluaran, dan tabungan bersih hari ini.

Laporan Keuangan Dinamis: Halaman khusus untuk melihat ringkasan berdasarkan tanggal pilihan pengguna, lengkap dengan distribusi pengeluaran per kategori.

Indikator Target Tabungan: Progress bar beranimasi yang membandingkan tabungan bersih hari ini dengan target harian yang bisa disesuaikan pengguna.

Personalisasi (AMOLED Dark Mode): Pengaturan Pure Black Dark Mode dan warna aksen tema yang tersimpan secara lokal menggunakan shared_preferences.

Navigasi Terpusat: Menggunakan NavigationBar, IndexedStack (agar state tab tidak hilang), dan Named Routes untuk transisi halaman form.

📂 Struktur Folder

Kode aplikasi disusun secara modular untuk memudahkan pengembangan dan pemeliharaan:

lib/
├── data/
│   └── db_helper.dart         # Logika SQLite (CRUD, Query agregasi laporan)
├── models/
│   └── kegiatan.dart          # Kelas model data (Kegiatan, Ringkasan, Enum Tipe)
├── pages/
│   ├── beranda_page.dart      # Tab 1: Hari Ini (Daftar kegiatan & Ringkasan)
│   ├── form_kegiatan_page.dart# Halaman form tambah/ubah data
│   ├── laporan_page.dart      # Tab 2: Laporan & Filter Tanggal
│   ├── pengaturan_page.dart   # Tab 3: Pengaturan tema & target
│   └── shell_page.dart        # Kerangka NavigationBar & IndexedStack
├── state/
│   └── pengaturan.dart        # ValueNotifier global (Tema, Warna, Target)
├── utils/
│   └── format.dart            # Utilitas format Rupiah & Tanggal
└── main.dart                  # Titik masuk, inisialisasi tema, dan routing


🛠️ Teknologi yang Digunakan

Flutter / Dart (SDK UI Lintas Platform)

sqflite (Database Lokal relasional)

shared_preferences (Penyimpanan konfigurasi sederhana)

intl (Format tanggal dan mata uang lokal)

Material 3 (Panduan desain antarmuka modern)

🚀 Cara Menjalankan Aplikasi

Pastikan Anda telah menginstal Flutter SDK dan menyiapkan emulator Android/iOS atau perangkat fisik (dengan USB/Wireless Debugging).

Kloning atau unduh repositori ini.

Buka terminal dan arahkan ke direktori proyek (cd tabung_ku).

Unduh semua dependensi paket dengan perintah:

flutter pub get


Jalankan aplikasi menggunakan perintah:

flutter run


💡 Catatan Pengembangan

Aplikasi ini menggunakan pendekatan ValueNotifier sebagai mekanisme manajemen state reaktif (Observer Pattern). Ketika terjadi perubahan data di database (tambah/ubah/hapus), DbHelper akan menaikkan nilai versiData, yang kemudian didengarkan (addListener) oleh halaman terkait untuk secara otomatis memuat ulang (setState) tampilan tanpa perlu me-restart aplikasi. Desain visual dioptimalkan untuk perangkat layar OLED/AMOLED dengan latar belakang hitam pekat (pure black).