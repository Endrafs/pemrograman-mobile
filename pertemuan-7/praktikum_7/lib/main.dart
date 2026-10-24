import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'state/pengaturan.dart';
import 'pages/shell_page.dart';
import 'pages/form_kegiatan_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await PengaturanState.muat();
  runApp(const TabungKuApp());
}

class TabungKuApp extends StatelessWidget {
  const TabungKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: PengaturanState.temaMode,
      builder: (context, mode, _) {
        return ValueListenableBuilder<Color>(
          valueListenable: PengaturanState.warnaUtama,
          builder: (context, warna, _) {
            return MaterialApp(
              title: 'TabungKu',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: warna,
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: warna,
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF121212),
              ),
              themeMode: mode,
              initialRoute: '/',
              routes: {
                '/': (context) => const ShellPage(),
                '/form': (context) => const FormKegiatanPage(),
              },
            );
          },
        );
      },
    );
  }
}