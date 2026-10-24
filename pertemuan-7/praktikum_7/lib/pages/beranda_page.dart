import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';
import '../state/pengaturan.dart';

class DataHariIni {
  final Ringkasan ringkasan;
  final List<Kegiatan> daftarKegiatan;
  DataHariIni(this.ringkasan, this.daftarKegiatan);
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late Future<DataHariIni> _futureData;

  @override
  void initState() {
    super.initState();
    _muatUlang();
    DbHelper.instance.versiData.addListener(_muatUlang);
  }

  @override
  void dispose() {
    DbHelper.instance.versiData.removeListener(_muatUlang);
    super.dispose();
  }

  void _muatUlang() {
    setState(() {
      _futureData = _ambilData();
    });
  }

  Future<DataHariIni> _ambilData() async {
    final tanggal = FormatData.hariIni();
    final ringkasan = await DbHelper.instance.ringkasan(tanggal);
    final kegiatan = await DbHelper.instance.padaTanggal(tanggal);
    return DataHariIni(ringkasan, kegiatan);
  }

  void _konfirmasiHapus(Kegiatan k) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kegiatan?'),
        content: Text('Apakah Anda yakin ingin menghapus "${k.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              DbHelper.instance.hapus(k.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hari Ini', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<DataHariIni>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final r = data.ringkasan;
          final kegiatan = data.daftarKegiatan;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: KartuRingkasan(ringkasan: r),
                ),
              ),
              if (kegiatan.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_note, size: 80, color: tema.colorScheme.surfaceContainerHighest),
                        const SizedBox(height: 16),
                        Text('Belum ada kegiatan hari ini', style: tema.textTheme.titleMedium?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final k = kegiatan[i];
                      return Dismissible(
                        key: ValueKey(k.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: tema.colorScheme.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          _konfirmasiHapus(k);
                          return false;
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            leading: Checkbox(
                              value: k.selesai,
                              onChanged: (v) {
                                final kBaru = Kegiatan(
                                  id: k.id,
                                  judul: k.judul,
                                  tanggal: k.tanggal,
                                  selesai: v ?? false,
                                  tipe: k.tipe,
                                  nominal: k.nominal,
                                  kategori: k.kategori,
                                );
                                DbHelper.instance.ubah(kBaru);
                              },
                            ),
                            title: Text(
                              k.judul,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: k.selesai ? TextDecoration.lineThrough : null,
                                color: k.selesai ? tema.colorScheme.onSurfaceVariant : null,
                              ),
                            ),
                            subtitle: k.tipe == Tipe.tanpa
                                ? const Text('Tidak melibatkan uang')
                                : Text(
                                    FormatData.rupiah(k.nominal),
                                    style: TextStyle(
                                      color: k.tipe == Tipe.pemasukan ? Colors.green : tema.colorScheme.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => Navigator.pushNamed(context, '/form', arguments: k),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: kegiatan.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/form'),
        icon: const Icon(Icons.add),
        label: const Text('Kegiatan'),
      ),
    );
  }
}

class KartuRingkasan extends StatelessWidget {
  final Ringkasan ringkasan;
  const KartuRingkasan({super.key, required this.ringkasan});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final target = PengaturanState.targetTabungan.value;
    final progres = (target > 0) ? (ringkasan.tabungan / target).clamp(0.0, 1.0) : 0.0;
    final isMinus = ringkasan.tabungan < 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isMinus
              ? [tema.colorScheme.errorContainer, tema.colorScheme.error.withOpacity(0.2)]
              : [tema.colorScheme.primaryContainer, tema.colorScheme.primary.withOpacity(0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tabungan Hari Ini', style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: tema.colorScheme.surface, borderRadius: BorderRadius.circular(12)),
                child: Text('${ringkasan.selesai} / ${ringkasan.jumlahKegiatan} Selesai', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            FormatData.rupiah(ringkasan.tabungan),
            style: tema.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isMinus ? tema.colorScheme.error : tema.colorScheme.primary,
            ),
          ),
          if (isMinus)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Peringatan: Pengeluaran melebihi pemasukan!', style: TextStyle(color: tema.colorScheme.error, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pemasukan', style: TextStyle(fontSize: 12)),
                  Text(FormatData.rupiah(ringkasan.pemasukan), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Pengeluaran', style: TextStyle(fontSize: 12)),
                  Text(FormatData.rupiah(ringkasan.pengeluaran), style: TextStyle(color: tema.colorScheme.error, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progres,
              minHeight: 10,
              backgroundColor: tema.colorScheme.surface,
              color: progres >= 1.0 ? Colors.green : tema.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            progres >= 1.0 ? '🎉 Target tercapai!' : 'Target: ${FormatData.rupiah(target)}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: tema.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}