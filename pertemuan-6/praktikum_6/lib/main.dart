import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _temaMode = ValueNotifier<ThemeMode>(ThemeMode.system);
final _warnaUtama = ValueNotifier<Color>(Colors.red);

const _pilihanWarna = <Color>[
  Colors.red,
  Colors.blue,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

ThemeData _buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

Future<void> _muatTema() async {
  final prefs = await SharedPreferences.getInstance();
  final indexWarna = prefs.getInt('warnaUtama') ?? 0;
  final isGelap = prefs.getBool('modeGelap');

  _warnaUtama.value = _pilihanWarna[indexWarna];
  if (isGelap != null) {
    _temaMode.value = isGelap ? ThemeMode.dark : ThemeMode.light;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _muatTema();
  runApp(const AplikasiPraktikum());
}

class AplikasiPraktikum extends StatelessWidget {
  const AplikasiPraktikum({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_temaMode, _warnaUtama]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Praktikum 6',
          debugShowCheckedModeBanner: false,
          theme: _buatTema(_warnaUtama.value, Brightness.light),
          darkTheme: _buatTema(_warnaUtama.value, Brightness.dark).copyWith(
            scaffoldBackgroundColor: Colors.black,
          ),
          themeMode: _temaMode.value,
          initialRoute: '/',
          routes: {
            '/': (context) => const HalamanUtama(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final item = settings.arguments as Item;
              return PageRouteBuilder(
                pageBuilder: (context, anim, secondAnim) => HalamanDetail(item: item),
                transitionsBuilder: (context, anim, secondAnim, child) {
                  return FadeTransition(opacity: anim, child: child);
                },
                settings: settings,
              );
            }
            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('404 - Halaman tidak ditemukan')),
                body: const Center(child: Text('Maaf, rute yang Anda tuju tidak tersedia.')),
              ),
            );
          },
        );
      },
    );
  }
}

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _indeks = 0;
  static const _halaman = [TabBeranda(), TabAnimasi(), TabPengaturan()];
  static const _judul = ['Beranda', 'Animasi', 'Pengaturan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_indeks])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: const Text('Menu Navigasi', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                setState(() => _indeks = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.animation),
              title: const Text('Animasi'),
              onTap: () {
                setState(() => _indeks = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                setState(() => _indeks = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _indeks, children: _halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeks,
        onDestinationSelected: (i) => setState(() => _indeks = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.animation),
            label: 'Animasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

class Item {
  final String nama;
  final IconData ikon;
  final Color warna;

  const Item(this.nama, this.ikon, this.warna);
}

const daftarItem = [
  Item('Flutter', Icons.flutter_dash, Colors.blue),
  Item('Musik', Icons.music_note, Colors.pink),
  Item('Kamera', Icons.camera_alt, Colors.orange),
  Item('Peta', Icons.map, Colors.green),
];

class TabBeranda extends StatelessWidget {
  const TabBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: daftarItem.length,
      itemBuilder: (context, i) {
        final item = daftarItem[i];
        return ListTile(
          leading: Hero(
            tag: 'ikon-${item.nama}',
            child: CircleAvatar(
              backgroundColor: item.warna,
              child: Icon(item.ikon, color: Colors.white),
            ),
          ),
          title: Text(item.nama),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
        );
      },
    );
  }
}

class HalamanDetail extends StatelessWidget {
  final Item item;
  const HalamanDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(item.nama)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'ikon-${item.nama}',
              child: CircleAvatar(
                radius: 64,
                backgroundColor: item.warna,
                child: Icon(item.ikon, size: 64, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(item.nama, style: tema.textTheme.headlineMedium),
            Text('Detail untuk ${item.nama}', style: tema.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class TabAnimasi extends StatefulWidget {
  const TabAnimasi({super.key});

  @override
  State<TabAnimasi> createState() => _TabAnimasiState();
}

class _TabAnimasiState extends State<TabAnimasi> with SingleTickerProviderStateMixin {
  bool _besar = false;
  int _hitung = 0;
  bool _terlihat = true;
  late final AnimationController _putar;

  @override
  void initState() {
    super.initState();
    _putar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _putar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('1. AnimatedContainer', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _besar ? 200 : 100,
            height: 100,
            decoration: BoxDecoration(
              color: _besar ? warna.primary : warna.tertiary,
              borderRadius: BorderRadius.circular(_besar ? 50 : 8),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _besar = !_besar),
          child: const Text('Ubah bentuk'),
        ),
        const Divider(),
        Text('2. AnimatedSwitcher', style: tema.textTheme.titleMedium),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: Text(
              '$_hitung',
              key: ValueKey(_hitung),
              style: tema.textTheme.displayMedium,
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _hitung++),
          child: const Text('Tambah'),
        ),
        const Divider(),
        Text('3. AnimationController', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: RotationTransition(
            turns: _putar,
            child: Icon(Icons.settings, size: 64, color: warna.primary),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_putar.isAnimating) {
              _putar.stop();
            } else {
              _putar.repeat();
            }
            setState(() {});
          },
          child: Text(_putar.isAnimating ? 'Berhenti' : 'Putar'),
        ),
        const Divider(),
        Text('4. AnimatedOpacity (Latihan Mandiri)', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: AnimatedOpacity(
            opacity: _terlihat ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: 100,
              height: 100,
              color: warna.secondary,
              alignment: Alignment.center,
              child: const Text('Kartu', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _terlihat = !_terlihat),
          child: const Text('Pudar / Muncul'),
        ),
      ],
    );
  }
}

class TabPengaturan extends StatelessWidget {
  const TabPengaturan({super.key});

  Future<void> _simpanTema(ThemeMode mode, int indexWarna) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', mode == ThemeMode.dark);
    await prefs.setInt('warnaUtama', indexWarna);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_temaMode, _warnaUtama]),
      builder: (context, _) {
        final isGelap = Theme.of(context).brightness == Brightness.dark;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Mode gelap'),
              value: isGelap,
              onChanged: (v) {
                _temaMode.value = v ? ThemeMode.dark : ThemeMode.light;
                _simpanTema(_temaMode.value, _pilihanWarna.indexOf(_warnaUtama.value));
              },
            ),
            const SizedBox(height: 8),
            Text('Warna tema', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                for (int i = 0; i < _pilihanWarna.length; i++)
                  GestureDetector(
                    onTap: () {
                      _warnaUtama.value = _pilihanWarna[i];
                      _simpanTema(_temaMode.value, i);
                    },
                    child: CircleAvatar(
                      backgroundColor: _pilihanWarna[i],
                      child: _warnaUtama.value == _pilihanWarna[i]
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}