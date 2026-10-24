import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiProfil());
}

class AplikasiProfil extends StatelessWidget {
  const AplikasiProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Pengembang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          surface: Color(0xFF121212),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const HalamanProfil(),
    );
  }
}

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.redAccent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.flutter_dash,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Saelendra Farell Syahbana',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                ),
                child: const Text(
                  'NIM: 20240801168',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Mahasiswa Teknik Informatika Universitas Esa Unggul. Berfokus pada pengembangan aplikasi mobile, merancang antarmuka bersih berbasis AMOLED, dan bereksplorasi dengan lingkungan terminal WSL.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buatLabelKeahlian('Flutter & Dart', Icons.code),
                  _buatLabelKeahlian('UI/UX Design', Icons.color_lens),
                  _buatLabelKeahlian('Terminal Linux', Icons.terminal),
                  _buatLabelKeahlian('Mendengarkan Musik', Icons.headphones),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buatLabelKeahlian(String teks, IconData ikon) {
    return Chip(
      avatar: Icon(ikon, size: 18, color: Colors.white),
      label: Text(teks),
      backgroundColor: const Color(0xFF121212),
      side: const BorderSide(color: Colors.redAccent, width: 1),
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}