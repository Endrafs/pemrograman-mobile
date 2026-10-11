import 'package:flutter/material.dart';
import '../models/post.dart';
import '../service/api_service.dart';
import 'post_detail_page.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  late Future<List<Postingan>> _masaDepanPostingan;

  @override
  void initState() {
    super.initState();
    _masaDepanPostingan = ApiService.ambilDaftarPostingan();
  }

  void _muatUlang() {
    setState(() {
      _masaDepanPostingan = ApiService.ambilDaftarPostingan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: FutureBuilder<List<Postingan>>(
          future: _masaDepanPostingan,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Daftar Postingan (${snapshot.data!.length})');
            }
            return const Text('Daftar Postingan');
          },
        ),
        backgroundColor: const Color(0xFF121212),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.redAccent),
            onPressed: _muatUlang,
          ),
        ],
      ),
      body: FutureBuilder<List<Postingan>>(
        future: _masaDepanPostingan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 8),
                    Text(
                      'Terjadi kesalahan:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _muatUlang,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final daftarPostingan = snapshot.data!;

          if (daftarPostingan.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => _muatUlang(),
              color: Colors.redAccent,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 300),
                  Center(
                    child: Text(
                      'Tidak ada data',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _muatUlang(),
            color: Colors.redAccent,
            child: ListView.builder(
              itemCount: daftarPostingan.length,
              itemBuilder: (context, i) {
                final item = daftarPostingan[i];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      child: Text(item.id.toString()),
                    ),
                    title: Text(
                      item.judul,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      item.isi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.redAccent),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HalamanDetail(postingan: item),
                        ),
                      );
                    },
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