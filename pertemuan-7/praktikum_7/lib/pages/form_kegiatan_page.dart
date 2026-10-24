import 'package:flutter/material.dart';
import '../models/kegiatan.dart';
import '../data/db_helper.dart';
import '../utils/format.dart';

class FormKegiatanPage extends StatefulWidget {
  const FormKegiatanPage({super.key});

  @override
  State<FormKegiatanPage> createState() => _FormKegiatanPageState();
}

class _FormKegiatanPageState extends State<FormKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _nominalCtrl = TextEditingController();
  
  String _tanggal = FormatData.hariIni();
  Tipe _tipe = Tipe.tanpa;
  String _kategori = 'Lainnya';
  bool _isInit = false;
  Kegiatan? _kegiatanLama;

  final _pilihanKategori = ['Makan', 'Transport', 'Belajar', 'Hiburan', 'Lainnya'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Kegiatan) {
        _kegiatanLama = args;
        _judulCtrl.text = args.judul;
        _tanggal = args.tanggal;
        _tipe = args.tipe;
        _kategori = args.kategori.isEmpty ? 'Lainnya' : args.kategori;
        if (args.nominal > 0) {
          _nominalCtrl.text = args.nominal.toString();
        }
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _nominalCtrl.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final awal = DateTime.parse(_tanggal);
    final pilih = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pilih != null) {
      setState(() {
        _tanggal = pilih.toString().split(' ')[0];
      });
    }
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      int nominal = 0;
      if (_tipe != Tipe.tanpa) {
        nominal = int.tryParse(_nominalCtrl.text) ?? 0;
      }

      final kBaru = Kegiatan(
        id: _kegiatanLama?.id,
        judul: _judulCtrl.text,
        tanggal: _tanggal,
        selesai: _kegiatanLama?.selesai ?? false,
        tipe: _tipe,
        nominal: nominal,
        kategori: _tipe == Tipe.pengeluaran ? _kategori : '-',
      );

      if (_kegiatanLama == null) {
        DbHelper.instance.tambah(kBaru);
      } else {
        DbHelper.instance.ubah(kBaru);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final isUbah = _kegiatanLama != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isUbah ? 'Ubah Kegiatan' : 'Tambah Kegiatan', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: InputDecoration(
                labelText: 'Nama Kegiatan',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: tema.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Nama kegiatan wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: tema.colorScheme.outlineVariant),
              ),
              leading: const Icon(Icons.calendar_today),
              title: const Text('Tanggal Kegiatan'),
              subtitle: Text(FormatData.tampilTanggal(_tanggal), style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.edit),
              onTap: _pilihTanggal,
            ),
            const SizedBox(height: 24),
            Text('Jenis Keuangan', style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SegmentedButton<Tipe>(
              segments: const [
                ButtonSegment(value: Tipe.tanpa, label: Text('Tidak Ada'), icon: Icon(Icons.money_off)),
                ButtonSegment(value: Tipe.pemasukan, label: Text('Pemasukan'), icon: Icon(Icons.download)),
                ButtonSegment(value: Tipe.pengeluaran, label: Text('Pengeluaran'), icon: Icon(Icons.upload)),
              ],
              selected: {_tipe},
              onSelectionChanged: (set) {
                setState(() {
                  _tipe = set.first;
                  if (_tipe == Tipe.tanpa) {
                    _nominalCtrl.clear();
                  }
                });
              },
            ),
            const SizedBox(height: 24),
            if (_tipe != Tipe.tanpa) ...[
              TextFormField(
                controller: _nominalCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nominal (Rp)',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: tema.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                ),
                validator: (v) {
                  if (_tipe != Tipe.tanpa) {
                    if (v == null || v.isEmpty) return 'Nominal wajib diisi';
                    final angka = int.tryParse(v);
                    if (angka == null || angka <= 0) return 'Nominal harus lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
            ],
            if (_tipe == Tipe.pengeluaran) ...[
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: InputDecoration(
                  labelText: 'Kategori Pengeluaran',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: tema.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                ),
                items: _pilihanKategori.map((k) {
                  return DropdownMenuItem(value: k, child: Text(k));
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _kategori = v);
                },
              ),
              const SizedBox(height: 20),
            ],
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _simpan,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.save),
              label: const Text('Simpan Kegiatan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}