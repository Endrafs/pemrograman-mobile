import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/comment.dart';

class ApiService {
  static Future<List<Postingan>> ambilDaftarPostingan() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final respon = await http.get(uri).timeout(const Duration(seconds: 10));

    if (respon.statusCode != 200) {
      throw Exception('Gagal memuat data postingan (kode ${respon.statusCode})');
    }

    final List<dynamic> data = jsonDecode(respon.body);
    return data.map((e) => Postingan.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<Komentar>> ambilDaftarKomentar(int idPostingan) async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/$idPostingan/comments');
    final respon = await http.get(uri).timeout(const Duration(seconds: 10));

    if (respon.statusCode != 200) {
      throw Exception('Gagal memuat komentar (kode ${respon.statusCode})');
    }

    final List<dynamic> data = jsonDecode(respon.body);
    return data.map((e) => Komentar.fromJson(e as Map<String, dynamic>)).toList();
  }
}