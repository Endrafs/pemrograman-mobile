import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tugas {
  String judul;
  bool selesai;

  Tugas(this.judul, {this.selesai = false});
}

class TugasModel extends ChangeNotifier {
  final List<Tugas> _items = [];

  List<Tugas> get items => List.unmodifiable(_items);
  int get jumlahSelesai => _items.where((t) => t.selesai).length;

  void tambah(String judul) {
    _items.add(Tugas(judul));
    notifyListeners();
  }

  void toggle(int index) {
    _items[index].selesai = !_items[index].selesai;
    notifyListeners();
  }

  void hapus(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TugasModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Tugas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          surface: Color(0xFF121212),
        ),
      ),
      home: const TugasPage(),
    );
  }
}

class TugasPage extends StatelessWidget {
  const TugasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TugasModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Tugas (${model.jumlahSelesai}/${model.items.length})'),
        backgroundColor: const Color(0xFF121212),
        centerTitle: true,
      ),
      body: model.items.isEmpty
          ? const Center(
              child: Text(
                'Belum ada tugas',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: model.items.length,
              itemBuilder: (context, i) {
                final t = model.items[i];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      activeColor: Colors.redAccent,
                      value: t.selesai,
                      onChanged: (_) => context.read<TugasModel>().toggle(i),
                    ),
                    title: Text(
                      t.judul,
                      style: TextStyle(
                        color: Colors.white,
                        decoration: t.selesai ? TextDecoration.lineThrough : null,
                        decorationColor: Colors.redAccent,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => context.read<TugasModel>().hapus(i),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _simpan() {
    final judul = _controller.text.trim();
    if (judul.isEmpty) return;
    context.read<TugasModel>().tambah(judul);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tambah Tugas'),
        backgroundColor: const Color(0xFF121212),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Judul tugas',
                labelStyle: const TextStyle(color: Colors.redAccent),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                ),
              ),
              onSubmitted: (_) => _simpan(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: _simpan,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}