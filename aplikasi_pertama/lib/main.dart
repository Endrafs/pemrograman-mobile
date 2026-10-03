import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ---------------------------------------------------
// FUNGSI FORMAT HARGA RUPIAH
// ---------------------------------------------------
String formatRupiah(int harga) {
  String hargaStr = harga.toString();
  String result = '';
  int count = 0;
  for (int i = hargaStr.length - 1; i >= 0; i--) {
    result = hargaStr[i] + result;
    count++;
    if (count % 3 == 0 && i != 0) {
      result = '.$result';
    }
  }
  return 'Rp $result';
}

// ---------------------------------------------------
// MODEL DATA MAKANAN
// ---------------------------------------------------
class Makanan {
  final String nama;
  final int harga;
  final String deskripsi;

  const Makanan(this.nama, this.harga, this.deskripsi);
}

const daftarMenu = [
  Makanan('Nasi Goreng', 15000, 'Nasi digoreng lezat dengan bumbu rahasia dan telur mata sapi.'),
  Makanan('Mie Ayam', 12000, 'Mie kenyal dengan potongan ayam kecap dan pangsit renyah.'),
  Makanan('Es Teh', 4000, 'Teh manis dingin yang menyegarkan dahaga.'),
  Makanan('Ayam Bakar', 20000, 'Ayam bakar bumbu kecap dengan sambal terasi pedas.'),
  Makanan('Sate Kambing', 25000, 'Sate daging kambing muda dengan bumbu kecap dan irisan tomat.'),
  Makanan('Soto Ayam', 15000, 'Soto ayam berkuah kuning gurih segar dengan taburan koya.'),
  Makanan('Jus Alpukat', 10000, 'Jus alpukat kental dengan tambahan susu cokelat.'),
];

// ---------------------------------------------------
// WIDGET UTAMA (AMOLED Theme)
// ---------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 2 - AMOLED Red',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Hitam pekat AMOLED
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.red,
        ),
        useMaterial3: true,
      ),
      home: const MenuPage(),
    );
  }
}

// ---------------------------------------------------
// HALAMAN 1: DAFTAR MENU
// ---------------------------------------------------
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Menu Red OLED', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final item = daftarMenu[index];
          
          // Container dengan latar hitam pekat dan border tipis merah
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F), // Hitam sedikit di atas murni agar kontras
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: ListTile(
              leading: const Icon(Icons.restaurant, color: Colors.red),
              title: Text(
                item.nama, 
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
              ),
              subtitle: Text(
                formatRupiah(item.harga), 
                style: const TextStyle(color: Colors.redAccent)
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailPage(makanan: item)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------
// HALAMAN 2: DETAIL MENU
// ---------------------------------------------------
class DetailPage extends StatelessWidget {
  final Makanan makanan;

  const DetailPage({super.key, required this.makanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(makanan.nama)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_menu, size: 100, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                makanan.nama, 
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)
              ),
              const SizedBox(height: 8),
              Text(
                formatRupiah(makanan.harga), 
                style: const TextStyle(fontSize: 22, color: Colors.redAccent, fontWeight: FontWeight.w600)
              ),
              const SizedBox(height: 16),
              Text(
                makanan.deskripsi,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 32),
              
              // Tombol Kembali beraksen merah
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}