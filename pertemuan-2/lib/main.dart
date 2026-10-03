import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Makanan {
  final String nama;
  final int harga;
  final String deskripsi;

  const Makanan({
    required this.nama,
    required this.harga,
    required this.deskripsi,
  });
}

String formatRibuan(int harga) {
  return harga.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
}

final List<Makanan> daftarMenu = [
  const Makanan(
    nama: 'Nasi Goreng',
    harga: 15000,
    deskripsi: 'Nasi goreng dengan telur, rempah pilihan, dan suwiran ayam.',
  ),
  const Makanan(
    nama: 'Mie Ayam',
    harga: 12000,
    deskripsi: 'Mie kenyal dipadu kecap asin gurih dan potongan ayam empuk.',
  ),
  const Makanan(
    nama: 'Es Teh',
    harga: 4000,
    deskripsi: 'Es teh manis segar racikan daun teh pilihan.',
  ),
  const Makanan(
    nama: 'Ayam Bakar',
    harga: 20000,
    deskripsi: 'Ayam bakar bumbu kecap gurih lengkap dengan sambal lalapan.',
  ),
  const Makanan(
    nama: 'Sate Kambing',
    harga: 25000,
    deskripsi: 'Sate kambing empuk dengan irisan cabai dan bumbu kecap.',
  ),
  const Makanan(
    nama: 'Soto Ayam',
    harga: 15000,
    deskripsi: 'Soto ayam kuah kuning hangat dengan soun dan koya.',
  ),
  const Makanan(
    nama: 'Jus Alpukat',
    harga: 10000,
    deskripsi: 'Jus alpukat murni dengan siraman susu cokelat legit.',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          surface: Color(0xFF121212),
        ),
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Daftar Menu'),
        backgroundColor: const Color(0xFF121212),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final item = daftarMenu[index];
          return Card(
            color: const Color(0xFF121212),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.restaurant, color: Colors.redAccent),
              title: Text(
                item.nama,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Rp ${formatRibuan(item.harga)}',
                style: const TextStyle(color: Colors.redAccent),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.redAccent),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(makanan: item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Makanan makanan;

  const DetailPage({super.key, required this.makanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(makanan.nama),
        backgroundColor: const Color(0xFF121212),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_menu, size: 80, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                makanan.nama,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Rp ${formatRibuan(makanan.harga)}',
                style: const TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
              const SizedBox(height: 16),
              Text(
                makanan.deskripsi,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}