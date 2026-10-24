import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';
import 'beranda_page.dart'; 

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String _tanggalPilih = FormatData.hariIni();
  late Future<Ringkasan> _futureRingkasan;
  late Future<List<Map<String, dynamic>>> _futureKategori;

  @override
  void initState() {
    super.initState();
    _muatData();
    DbHelper.instance.versiData.addListener(_muatData);
  }

  @override
  void dispose() {
    DbHelper.instance.versiData.removeListener(_muatData);
    super.dispose();
  }

  void _muatData() {
    setState(() {
      _futureRingkasan = DbHelper.instance.ringkasan(_tanggalPilih);
      _futureKategori = DbHelper.instance.pengeluaranPerKategori(_tanggalPilih);
    });
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final awal = DateTime.parse(_tanggalPilih);
    final pilih = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pilih != null) {
      setState(() {
        _tanggalPilih = pilih.toString().split(' ')[0];
        _muatData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _pilihTanggal(context),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([_futureRingkasan, _futureKategori]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Galat: ${snapshot.error}'));
          }

          final ringkasan = snapshot.data![0] as Ringkasan;
          final kategori = snapshot.data![1] as List<Map<String, dynamic>>;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Text(
                  FormatData.tampilTanggal(_tanggalPilih),
                  style: tema.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              KartuRingkasan(ringkasan: ringkasan),
              const SizedBox(height: 32),
              Text('Pengeluaran per Kategori', style: tema.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (kategori.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(color: tema.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
                  child: const Center(child: Text('Tidak ada data pengeluaran')),
                )
              else
                ...kategori.map((k) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: tema.colorScheme.primaryContainer,
                        child: Icon(Icons.pie_chart, color: tema.colorScheme.primary),
                      ),
                      title: Text(k['kategori'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(
                        FormatData.rupiah(k['total']),
                        style: TextStyle(fontWeight: FontWeight.bold, color: tema.colorScheme.error, fontSize: 16),
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}