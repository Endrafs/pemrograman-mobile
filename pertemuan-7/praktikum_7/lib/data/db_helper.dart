import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/kegiatan.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;
  final versiData = ValueNotifier<int>(0);

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tabungku.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _buatTabel);
  }

  Future<void> _buatTabel(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kegiatan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        tanggal TEXT NOT NULL,
        selesai INTEGER NOT NULL,
        tipe TEXT NOT NULL,
        nominal INTEGER NOT NULL,
        kategori TEXT NOT NULL
      )
    ''');
  }

  void _notifikasi() => versiData.value++;

  Future<int> tambah(Kegiatan k) async {
    final db = await instance.database;
    final id = await db.insert('kegiatan', k.toMap());
    _notifikasi();
    return id;
  }

  Future<int> ubah(Kegiatan k) async {
    final db = await instance.database;
    final hasil = await db.update('kegiatan', k.toMap(), where: 'id = ?', whereArgs: [k.id]);
    _notifikasi();
    return hasil;
  }

  Future<int> hapus(int id) async {
    final db = await instance.database;
    final hasil = await db.delete('kegiatan', where: 'id = ?', whereArgs: [id]);
    _notifikasi();
    return hasil;
  }

  Future<List<Kegiatan>> padaTanggal(String tanggal) async {
    final db = await instance.database;
    final hasil = await db.query('kegiatan', where: 'tanggal = ?', whereArgs: [tanggal]);
    return hasil.map((m) => Kegiatan.fromMap(m)).toList();
  }

  Future<Ringkasan> ringkasan(String tanggal) async {
    final db = await instance.database;
    final hasil = await db.rawQuery('''
      SELECT COUNT(*) AS jumlah,
             COALESCE(SUM(selesai), 0) AS selesai,
             COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN nominal END), 0) AS masuk,
             COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal END), 0) AS keluar
      FROM kegiatan
      WHERE tanggal = ?
    ''', [tanggal]);
    
    final baris = hasil.first;
    return Ringkasan(
      jumlahKegiatan: baris['jumlah'] as int,
      selesai: baris['selesai'] as int,
      pemasukan: baris['masuk'] as int,
      pengeluaran: baris['keluar'] as int,
    );
  }

  Future<List<Map<String, dynamic>>> pengeluaranPerKategori(String tanggal) async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT kategori, SUM(nominal) as total
      FROM kegiatan
      WHERE tanggal = ? AND tipe = 'pengeluaran'
      GROUP BY kategori
      ORDER BY total DESC
    ''', [tanggal]);
  }
}