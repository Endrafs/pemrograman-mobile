# Pertemuan 1: Pengenalan Flutter, Instalasi, dan Aplikasi Pertama

**Nama:** Saelendra Farell Syahbana  
**NIM:** 20240801168  
**Prodi:** Teknik Informatika  

---

## 1. Rangkuman Modul & Praktikum

Pada praktikum Pertemuan 1 ini, dipelajari konsep dasar pengembangan aplikasi mobile berbasis Flutter dan Dart[cite: 3]:
- **Instalasi & Verifikasi**: Mengonfigurasi Flutter SDK, Android Studio, dan menjalankan `flutter doctor` untuk memastikan lingkungan siap[cite: 3].
- **Struktur Proyek**: Memahami direktori utama seperti `lib/main.dart` (titik masuk program), `pubspec.yaml` (dependensi & konfigurasi), serta folder platform native (`android/`, `ios/`)[cite: 4].
- **Widget Hierarchy**: Memahami susunan widget tree seperti `MaterialApp` -> `Scaffold` -> `AppBar` + `Center` -> `Column` / `Text`[cite: 4].
- **StatefulWidget & Hot Reload**: Menggunakan `StatefulWidget` untuk mengubah UI secara dinamis melalui `setState()` dan memanfaatkan fitur *hot reload*[cite: 3, 5].

---

## 2. Jawaban Pertanyaan Refleksi

### 1. Apa perbedaan StatelessWidget dan StatefulWidget?
* **StatelessWidget**: Widget yang bersifat imutabel (statis) di mana tampilannya tidak dapat berubah setelah di-build di layar[cite: 3]. Dipakai untuk komponen UI yang tidak menyimpan data dinamis.
* **StatefulWidget**: Widget yang memiliki objek `State` internal. Tampilannya dapat berubah secara dinamis selama aplikasi berjalan saat terjadi perubahan data/interaksi pengguna[cite: 3].

### 2. Mengapa perubahan variabel `_count` perlu dibungkus `setState()`?
Fungsi `setState()` memberitahu framework Flutter bahwa ada perubahan kondisi/data (*state*) internal pada widget[cite: 3]. Dengan memanggil `setState()`, Flutter akan memicu pemanggilan ulang fungsi `build()` untuk memperbarui (*re-render*) tampilan UI di layar sesuai dengan nilai variabel terbaru[cite: 3].

### 3. Apa keuntungan hot reload dibanding rebuild penuh?
* Hot reload mendinjeksikan file kode yang baru diperbarui langsung ke dalam VM Dart yang sedang berjalan tanpa perlu mengompilasi ulang seluruh aplikasi dari awal[cite: 3].
* Menjaga kondisi (*state*) aplikasi tetap bertahan (misal tidak kembali ke halaman awal).
* Mempercepat proses iterasi desain dan perbaikan bug (hanya membutuhkan waktu < 1-2 detik)[cite: 3].

---

## 3. Latihan Mandiri & Tugas

1. **Praktikum & Latihan Mandiri (`praktikum_1`)**:
   - Aplikasi Counter sederhana dengan kustomisasi warna `AppBar` dan `Text`[cite: 5].
   - Fitur tombol penambah (`+`), pengurang (`-`), dan tombol reset (`0`)[cite: 5].
   - Logika pencegahan nilai negatif (`_count < 0`)[cite: 5].

2. **Tugas Kartu Perkenalan (`aplikasi_pertama`)**:
   - Aplikasi satu halaman berisi profil personal yang disusun menggunakan `Column`, `Text`, `Icon`, `SizedBox`, dan `Card`[cite: 5].
   - Menampilkan Foto/Ikon, Nama, NIM, Jurusan, dan Hobi[cite: 5].