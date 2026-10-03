# Pertemuan 2: Layout, ListView, dan Navigasi Antar Halaman

**Nama:** Saelendra Farell Syahbana  
**NIM:** 20240801168  
**Prodi:** Teknik Informatika  

---

## 1. Rangkuman Praktikum & Latihan Mandiri

Pada praktikum Pertemuan 2 dipelajari:
1. **Layouting**: Menyusun widget menggunakan `Container`, `Padding`, `Row`, `Column`, dan `Expanded`[cite: 10].
2. **ListView.builder & Data Model**: Menampilkan data dinamis secara efisien menggunakan class `Makanan` dan `ListView.builder`[cite: 10, 11].
3. **Navigasi Halaman**: Mengirim data antar halaman menggunakan `Navigator.push` dan menutup halaman menggunakan `Navigator.pop`[cite: 10, 12].
4. **Latihan Mandiri**:
   - Menambahkan 7 variasi menu[cite: 13].
   - Menambahkan field `deskripsi` pada class `Makanan`[cite: 13].
   - Mengganti `Card` dengan `Container` bersudut membulat (*custom OLED style*)[cite: 13].
   - Format harga otomatis ribuan (contoh: `15.000`)[cite: 13].

---

## 2. Jawaban Pertanyaan Refleksi

### 1. Apa perbedaan ListView biasa dengan ListView.builder?
- **ListView biasa**: Merender seluruh elemen (*child*) di dalam list secara langsung sekaligus ke dalam memori. Kurang efisien jika jumlah data sangat banyak atau dinamis.
- **ListView.builder**: Merender elemen secara *lazy* (hanya membuat widget yang sedang terlihat di layar). Sangat efisien dalam penggunaan memori untuk daftar data berukuran sedang hingga besar[cite: 10].

### 2. Mengapa Row yang berisi teks panjang dapat menyebabkan overflow, dan bagaimana Expanded membantu?
- **Penyebab Overflow**: `Row` memberikan lebar tak terbatas (*unconstrained width*) ke widget anaknya. Jika teks melebihi lebar layar, Flutter tidak otomatis memotongnya sehingga memicu garis kuning-hitam (*overflow*)[cite: 13].
- **Peran Expanded**: `Expanded` memaksa widget anaknya untuk hanya mengambil sisa ruang kosong yang tersedia pada sumbu utama `Row`, sehingga teks secara otomatis melakukan pemotongan/pembungkusan (*text wrapping*)[cite: 10].

### 3. Bagaimana data dikirim dari halaman daftar ke halaman detail pada praktikum ini?
Data dikirim melalui **Constructor Injection**[cite: 12]. Saat item daftar ditekan (`onTap`), objek data (`makanan` atau `kontak`) dimasukkan sebagai parameter argumen saat instansiasi kelas `DetailPage(makanan: item)` di dalam fungsi `Navigator.push()`[cite: 12].

---

## 3. Dokumentasi Tugas Utama (Daftar Kontak)

Aplikasi **Daftar Kontak** memenuhi seluruh kriteria tugas[cite: 13]:
- Menyimpan 6+ data kontak (Nama, Telepon, Email) dalam `List<Kontak>`[cite: 13].
- Menampilkan avatar berbentuk lingkaran dengan huruf pertama nama kontak[cite: 13].
- Menggunakan `ListView.builder` dan `ListTile`[cite: 13].
- Navigasi ke Halaman Detail Kontak beserta tombol Kembali (`Navigator.pop`)[cite: 12, 13].