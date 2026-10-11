# Pertemuan 6: Tema, Routing dan Navigasi, serta Animasi

Repositori ini berisi implementasi kode untuk **Pertemuan 6** mata kuliah Pemrograman Mobile. Fokus pada modul ini adalah pengelolaan tema aplikasi secara dinamis, sistem navigasi dan *routing* antar halaman, pengelolaan tab bawah, serta penerapan berbagai jenis animasi di ekosistem Flutter.

## Struktur Direktori

* **`praktikum_6/`**: Proyek utama praktikum yang mencakup demonstrasi implementasi `ThemeData`, *Named Routes*, navigasi dasar, dan simulasi animasi. Proyek ini juga sudah mencakup pengerjaan **Latihan Mandiri** (penyimpanan tema, menu *Drawer*, halaman 404, dan penambahan `AnimatedOpacity`).
* **`tugas_katalog/`**: Proyek penugasan mandiri berupa aplikasi **Katalog Musik** interaktif. Proyek ini mematuhi semua prasyarat tugas: navigasi minimal 3 tab, transisi *Hero* pada *named routes*, animasi implisit & eksplisit, serta penyimpanan pengaturan tema UI berbasis *pure black* AMOLED.

## Fitur & Pencapaian Modul

1. **Tema Dinamis (Dynamic Theming)**
   * Mendukung perpindahan antara Mode Terang dan Mode Gelap.
   * Pemilihan warna aksen utama (*primary seed color*) secara dinamis.
   * Pemanggilan warna selalu menggunakan parameter `Theme.of(context)` tanpa ada variabel warna yang ditulis secara manual (*hard-coded*).
   * Nilai pengaturan tema secara otomatis disimpan menggunakan paket `shared_preferences` sehingga preferensi pengguna tidak hilang meskipun aplikasi ditutup sepenuhnya.

2. **Routing & Navigasi**
   * Integrasi *Named Routes* untuk manajemen rute yang lebih rapi menggunakan blok `onGenerateRoute`.
   * Navigasi tab utama menggunakan antarmuka `NavigationBar`.
   * Pencegahan muat ulang tab (*state retention*) dengan membungkus halaman di dalam `IndexedStack`.
   * Mitigasi akses *routing* tak terdaftar melalui fungsi `onUnknownRoute` (Halaman 404).

3. **Animasi & Efek Visual**
   * **Transisi Hero**: Ikon secara mulus terbang dan membesar dari *list view* menuju halaman detail (*detail page*).
   * **Animasi Implisit**: Menggunakan `AnimatedContainer`, `AnimatedSwitcher`, dan `AnimatedOpacity` untuk mengubah dimensi, ukuran, dan transparansi komponen tanpa perlu mendefinisikan *controller*.
   * **Animasi Eksplisit**: Menggunakan kombinasi `AnimationController` dan `SingleTickerProviderStateMixin` untuk merender animasi perputaran (*RotationTransition*) tanpa henti (*loop*).

## Cara Menjalankan Proyek

Pastikan Anda telah memasang dependensi pendukung sebelum menjalankan aplikasi. Akses proyek melalui terminal WSL dan eksekusi perintah berikut:

```bash
# Menjalankan Praktikum 6
cd praktikum_6
flutter pub get
flutter run

# Menjalankan Tugas Katalog Musik
cd ../tugas_katalog
flutter pub get
flutter run