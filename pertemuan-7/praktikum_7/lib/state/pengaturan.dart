import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengaturanState {
  static final temaMode = ValueNotifier<ThemeMode>(ThemeMode.system);
  static final warnaUtama = ValueNotifier<Color>(Colors.teal);
  static final targetTabungan = ValueNotifier<int>(20000);

  static const pilihanWarna = <Color>[
    Colors.teal,
    Colors.indigo,
    Colors.deepOrange,
    Colors.pink,
    Colors.blue,
  ];

  static Future<void> muat() async {
    final prefs = await SharedPreferences.getInstance();
    final isGelap = prefs.getBool('modeGelap');
    final idxWarna = prefs.getInt('indexWarna') ?? 0;
    final target = prefs.getInt('targetTabungan') ?? 20000;

    if (isGelap != null) temaMode.value = isGelap ? ThemeMode.dark : ThemeMode.light;
    warnaUtama.value = pilihanWarna[idxWarna];
    targetTabungan.value = target;
  }

  static Future<void> simpanTema(ThemeMode mode, int idxWarna) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', mode == ThemeMode.dark);
    await prefs.setInt('indexWarna', idxWarna);
    temaMode.value = mode;
    warnaUtama.value = pilihanWarna[idxWarna];
  }

  static Future<void> simpanTarget(int target) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('targetTabungan', target);
    targetTabungan.value = target;
  }
}