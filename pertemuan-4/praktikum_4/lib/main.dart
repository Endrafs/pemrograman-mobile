import 'package:flutter/material.dart';
import 'pages/post_list_page.dart';

void main() => runApp(const AplikasiUtama());

class AplikasiUtama extends StatelessWidget {
  const AplikasiUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Postingan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          surface: Color(0xFF121212),
        ),
      ),
      home: const HalamanUtama(),
    );
  }
}