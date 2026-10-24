import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class TaskItem {
  final String id; // Tambahkan ID unik untuk Dismissible Key
  final String soal;
  final String waktu;
  final String deskripsi;

  TaskItem({
    required this.id,
    required this.soal,
    required this.waktu,
    required this.deskripsi,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Tugas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          secondary: Colors.redAccent,
          surface: Color(0xFF1A1A1A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.red,
          elevation: 1,
          shadowColor: Colors.redAccent,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Daftar Tugas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<TaskItem> _tasks = [];

  final TextEditingController _soalController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  @override
  void dispose() {
    _soalController.dispose();
    _waktuController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text('Tambah Tugas Baru', style: TextStyle(color: Colors.red)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _soalController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Tugas / Soal',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Field Waktu menggunakan TimePicker
                TextField(
                  controller: _waktuController,
                  readOnly: true, // Mencegah keyboard muncul
                  onTap: () async {
                    // Memanggil Time Picker bawaan Flutter
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      // Format waktu ke dalam string dan set ke controller
                      final String formattedTime = pickedTime.format(context);
                      _waktuController.text = formattedTime;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Waktu',
                    suffixIcon: Icon(Icons.access_time, color: Colors.redAccent),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _deskripsiController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Tambahan',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_soalController.text.isNotEmpty) {
                  setState(() {
                    _tasks.add(
                      TaskItem(
                        id: DateTime.now().toString(), // Generate ID unik
                        soal: _soalController.text,
                        waktu: _waktuController.text,
                        deskripsi: _deskripsiController.text,
                      ),
                    );
                  });
                  _soalController.clear();
                  _waktuController.clear();
                  _deskripsiController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                'Belum ada tugas. Tekan + untuk menambah.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final task = _tasks[index];
                // Bungkus Card dengan Dismissible untuk fitur hapus
                return Dismissible(
                  key: Key(task.id), // Key wajib dan harus unik
                  direction: DismissDirection.endToStart, // Geser dari kanan ke kiri
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.red.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  onDismissed: (direction) {
                    // Simpan nama tugas untuk ditampilkan di SnackBar
                    final deletedTask = task.soal;
                    
                    // Hapus data dari state
                    setState(() {
                      _tasks.removeAt(index);
                    });

                    // Tampilkan notifikasi kecil di bawah
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$deletedTask telah dihapus'),
                        backgroundColor: const Color(0xFF1A1A1A),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.redAccent, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        task.soal,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: Colors.redAccent),
                              const SizedBox(width: 4),
                              Text(
                                task.waktu.isEmpty ? 'Tidak ada waktu' : task.waktu, 
                                style: const TextStyle(color: Colors.redAccent)
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(task.deskripsi, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Tugas',
        child: const Icon(Icons.add),
      ),
    );
  }
}