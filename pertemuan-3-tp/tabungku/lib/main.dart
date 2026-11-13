import 'package:flutter/material.dart';

void main() {
  runApp(const TabungKuApp());
}

class TabungKuApp extends StatelessWidget {
  const TabungKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabungKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        scaffoldBackgroundColor: const Color(0xFFF4F7F4),
        useMaterial3: true,
      ),
      home: const RingkasanPage(),
    );
  }
}

// Model sederhana untuk menampung data transaksi statis.
class Transaksi {
  final String judul;
  final String tanggal;
  final int nominal;
  final bool masuk;

  const Transaksi({
    required this.judul,
    required this.tanggal,
    required this.nominal,
    required this.masuk,
  });
}

class RingkasanPage extends StatelessWidget {
  const RingkasanPage({super.key});

  // Data contoh yang ditulis langsung di kode.
  static const List<Transaksi> _daftarTransaksi = [
    Transaksi(
      judul: 'Menabung mingguan',
      tanggal: '12 Nov 2026',
      nominal: 250000,
      masuk: true,
    ),
    Transaksi(
      judul: 'Beli buku kuliah',
      tanggal: '09 Nov 2026',
      nominal: 185000,
      masuk: false,
    ),
    Transaksi(
      judul: 'Bonus proyek kecil',
      tanggal: '05 Nov 2026',
      nominal: 400000,
      masuk: true,
    ),
    Transaksi(
      judul: 'Isi ulang e-wallet',
      tanggal: '01 Nov 2026',
      nominal: 100000,
      masuk: false,
    ),
  ];

  // Format angka menjadi rupiah tanpa memakai paket tambahan.
  String _formatRupiah(int nilai) {
    final teks = nilai.toString();
    final hasil = StringBuffer();

    for (int i = 0; i < teks.length; i++) {
      final sisa = teks.length - i;
      hasil.write(teks[i]);
      if (sisa > 1 && sisa % 3 == 1) {
        hasil.write('.');
      }
    }

    return 'Rp $hasil';
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold menjadi kerangka utama halaman ringkasan.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Tabungan'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        // ListView dipakai agar isi halaman tetap bisa digulir
        // dan tidak overflow pada layar yang pendek.
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ConstrainedBox menjaga lebar konten saat dibuka di tablet.
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildKartuTabungan(),
                    const SizedBox(height: 24),
                    _buildBarisKategori(),
                    const SizedBox(height: 24),
                    _buildDaftarTransaksi(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kartu utama berisi nama tabungan, saldo, dan target.
  Widget _buildKartuTabungan() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris pertama: ikon dan identitas tabungan.
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.savings_outlined,
                    color: Color(0xFF2E7D32),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tabungan Umum',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Target: Rp 10.000.000',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Saldo ditampilkan lebih besar agar mudah dibaca.
            const Text(
              'Saldo saat ini',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            const Text(
              'Rp 6.450.000',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 16),
            // Baris kedua: rincian target dan dana yang sudah terkumpul.
            Row(
              children: [
                Expanded(
                  child: _buildInfoKartu('Terkumpul', 'Rp 6.450.000'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoKartu('Sisa target', 'Rp 3.550.000'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Kotak kecil di dalam kartu untuk menampilkan angka pendukung.
  Widget _buildInfoKartu(String label, String nilai) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            nilai,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Tiga tombol kategori disusun sejajar dengan Row dan Expanded.
  Widget _buildBarisKategori() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildTombolKategori(
            Icons.add_card_outlined,
            'Menabung',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTombolKategori(
            Icons.account_balance_wallet_outlined,
            'Tarik',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTombolKategori(
            Icons.history,
            'Riwayat',
          ),
        ),
      ],
    );
  }

  // Satu tombol kategori berisi ikon dan label.
  Widget _buildTombolKategori(IconData ikon, String label) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          // Aksi tombol belum dihubungkan ke halaman lain.
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(ikon, color: const Color(0xFF2E7D32), size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Daftar transaksi terakhir beserta judul, tanggal, dan nominal.
  Widget _buildDaftarTransaksi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Text(
                'Transaksi Terakhir',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${_daftarTransaksi.length} transaksi',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._daftarTransaksi.map(
          (transaksi) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildItemTransaksi(transaksi),
          ),
        ),
      ],
    );
  }

  // Satu baris transaksi: ikon, judul dan tanggal, lalu nominal.
  Widget _buildItemTransaksi(Transaksi transaksi) {
    final warnaNominal =
        transaksi.masuk ? const Color(0xFF2E7D32) : Colors.red.shade700;
    final tanda = transaksi.masuk ? '+' : '-';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: transaksi.masuk
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFDECEA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaksi.masuk ? Icons.south_west : Icons.north_east,
              size: 20,
              color: warnaNominal,
            ),
          ),
          const SizedBox(width: 12),
          // Expanded membuat judul menyesuaikan ruang yang tersedia.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaksi.judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  transaksi.tanggal,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$tanda ${_formatRupiah(transaksi.nominal)}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: warnaNominal,
            ),
          ),
        ],
      ),
    );
  }
}
