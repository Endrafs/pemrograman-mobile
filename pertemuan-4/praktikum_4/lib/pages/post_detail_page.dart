import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../service/api_service.dart';

class HalamanDetail extends StatefulWidget {
  final Postingan postingan;

  const HalamanDetail({super.key, required this.postingan});

  @override
  State<HalamanDetail> createState() => _HalamanDetailState();
}

class _HalamanDetailState extends State<HalamanDetail> {
  late Future<List<Komentar>> _masaDepanKomentar;

  @override
  void initState() {
    super.initState();
    _masaDepanKomentar = ApiService.ambilDaftarKomentar(widget.postingan.id);
  }

  void _muatUlangKomentar() {
    setState(() {
      _masaDepanKomentar = ApiService.ambilDaftarKomentar(widget.postingan.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Detail Postingan #${widget.postingan.id}'),
        backgroundColor: const Color(0xFF121212),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF121212),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.postingan.judul,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.postingan.isi,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.redAccent, height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.black,
            child: const Text(
              'Komentar:',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Komentar>>(
              future: _masaDepanKomentar,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.redAccent, size: 36),
                          const SizedBox(height: 8),
                          Text(
                            'Gagal memuat komentar:\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _muatUlangKomentar,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final daftarKomentar = snapshot.data!;

                if (daftarKomentar.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada data', style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  itemCount: daftarKomentar.length,
                  itemBuilder: (context, i) {
                    final itemKomentar = daftarKomentar[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.redAccent.withOpacity(0.2),
                          foregroundColor: Colors.redAccent,
                          child: Text(itemKomentar.nama[0].toUpperCase()),
                        ),
                        title: Text(
                          itemKomentar.email,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        subtitle: Text(
                          itemKomentar.isi,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}