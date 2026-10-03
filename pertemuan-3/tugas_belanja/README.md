# Pertemuan 3: Form Input, Validasi, dan State Management Provider

**Nama:** Saelendra Farell Syahbana  
**NIM:** 20240801168  
**Prodi:** Teknik Informatika  

---

## 1. Rangkuman Praktikum & State Management

Pada praktikum Pertemuan 3 dipelajari:
1. **Input & Controllers**: Menggunakan `TextField`, `TextFormField`, dan `TextEditingController` serta pengelolaan siklus hidup memory lewat `dispose()`[cite: 19, 20].
2. **Form Validation**: Membuat form dinamis dengan `Form`, `GlobalKey<FormState>`, `DropdownButtonFormField`, dan `CheckboxListTile`[cite: 19, 21, 22].
3. **Provider State Management**: Memisahkan logika bisnis dan state aplikasi dari UI menggunakan `ChangeNotifier`, `ChangeNotifierProvider`, `context.watch`, dan `context.read`[cite: 19, 22, 23].

---

## 2. Jawaban Pertanyaan Refleksi

### 1. Mengapa `TextEditingController` harus di-`dispose()`?
`TextEditingController` mendaftarkan listener internal ke sistem Flutter. Jika tidak dihancurkan dengan `dispose()` saat widget tidak lagi digunakan (*unmounted*), objek tersebut akan tetap tersimpan di memori (*memory leak*), mengonsumsi RAM, dan dapat memicu penurunan performa atau error pada aplikasi[cite: 20, 25].

### 2. Kapan cukup memakai `setState`, dan kapan sebaiknya beralih ke `Provider`?
- **`setState`**: Cukup digunakan untuk **Ephemeral State** (state lokal yang hanya relevan untuk satu widget/halaman saja), seperti status centang checkbox sementara, input text sederhana, atau animasi lokal[cite: 19, 25].
- **`Provider`**: Digunakan saat terjadi **App State / Global State** (data yang perlu diakses atau diperbarui oleh banyak halaman/widget sekaligus), seperti keranjang belanja, status autentikasi user, atau daftar tugas/belanja inter-halaman[cite: 19, 22, 25].

### 3. Apa yang terjadi bila `notifyListeners()` lupa dipanggil? Mengapa?
Jika `notifyListeners()` lupa dipanggil, data di dalam kelas `ChangeNotifier` tetap terubah di memori, tetapi Flutter **tidak akan memperbarui (*re-build*) tampilan UI** pada layar[cite: 19, 25]. Hal ini terjadi karena `notifyListeners()` bertugas memancarkan sinyal pemberitahuan kepada seluruh widget pembaca (`context.watch` / `Consumer`) bahwa terjadi perubahan data[cite: 19, 25].

### 4. Mengapa di dalam `onPressed` kita memakai `context.read`, bukan `context.watch`?
- **`context.read`**: Hanya membaca data/metode *sekali* tanpa mendaftarkan widget sebagai listener[cite: 19, 25]. Ideal untuk *callback* tombol seperti `onPressed` agar tidak memicu re-build widget yang tidak perlu[cite: 19, 25].
- **`context.watch`**: Mendaftarkan widget agar selalu di-build ulang setiap kali data berubah[cite: 19, 25]. Jika ditempatkan di dalam fungsi *event handler* seperti `onPressed`, Flutter akan melemparkan error karena listener di-subscribe di luar siklus `build()`[cite: 19, 25].

---

## 3. Fitur Aplikasi Utama (Daftar Belanja)

- **Form Tambah dengan Validasi**:
  - Nama barang: wajib diisi[cite: 24].
  - Jumlah: wajib diisi angka lebih besar dari 0[cite: 24].
  - Kategori: wajib memilih opsi dropdown (Makanan, Minuman, Kebutuhan Rumah, Lainnya)[cite: 24].
- **Halaman Utama**:
  - Menampilkan indikator jumlah barang yang **belum dibeli** pada `AppBar`.
  - Checkbox untuk menandai status "sudah dibeli"[cite: 25].
  - Tombol hapus dan *Empty State* apabila daftar belanja kosong.