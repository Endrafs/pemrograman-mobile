import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _temaMode = ValueNotifier<ThemeMode>(ThemeMode.dark);
final _warnaUtama = ValueNotifier<Color>(Colors.red);

const _pilihanWarna = <Color>[
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
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
  final isGelap = prefs.getBool('modeGelap') ?? true;

  _warnaUtama.value = _pilihanWarna[indexWarna];
  _temaMode.value = isGelap ? ThemeMode.dark : ThemeMode.light;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _muatTema();
  runApp(const AplikasiKatalog());
}

class AplikasiKatalog extends StatelessWidget {
  const AplikasiKatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_temaMode, _warnaUtama]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Katalog Musik',
          debugShowCheckedModeBanner: false,
          theme: _buatTema(_warnaUtama.value, Brightness.light),
          darkTheme: _buatTema(_warnaUtama.value, Brightness.dark).copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              centerTitle: true,
            ),
          ),
          themeMode: _temaMode.value,
          initialRoute: '/',
          routes: {
            '/': (context) => const HalamanUtama(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final item = settings.arguments as ItemMusik;
              return PageRouteBuilder(
                pageBuilder: (context, anim, secondAnim) => HalamanDetail(item: item),
                transitionsBuilder: (context, anim, secondAnim, child) {
                  return FadeTransition(opacity: anim, child: child);
                },
              );
            }
            return null;
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
  static const _halaman = [TabBeranda(), TabKatalog(), TabPengaturan()];
  static const _judul = ['Beranda', 'Katalog Musik', 'Pengaturan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_indeks])),
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
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music),
            label: 'Katalog',
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

class ItemMusik {
  final String id;
  final String artis;
  final String lagu;
  final IconData ikon;

  const ItemMusik(this.id, this.artis, this.lagu, this.ikon);
}

const daftarMusik = [
  ItemMusik('1', 'The Weeknd', 'Blinding Lights', Icons.album),
  ItemMusik('2', 'Perunggu', 'Sesuatu Yang Abadi', Icons.speaker),
  ItemMusik('3', 'Kenny G', 'The Moment', Icons.music_note),
  ItemMusik('4', 'LE SSERAFIM', 'Boompa', Icons.headphones),
];

class TabBeranda extends StatefulWidget {
  const TabBeranda({super.key});

  @override
  State<TabBeranda> createState() => _TabBerandaState();
}

class _TabBerandaState extends State<TabBeranda> with SingleTickerProviderStateMixin {
  bool _diperbesar = false;
  late final AnimationController _kontrolPutar;

  @override
  void initState() {
    super.initState();
    _kontrolPutar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _kontrolPutar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _kontrolPutar,
            child: Icon(Icons.album, size: 100, color: tema.colorScheme.primary),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => setState(() => _diperbesar = !_diperbesar),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(_diperbesar ? 24.0 : 16.0),
              decoration: BoxDecoration(
                color: tema.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(_diperbesar ? 30 : 12),
              ),
              child: Text(
                'Selamat Datang di Katalog Musik\n(Ketuk untuk interaksi)',
                textAlign: TextAlign.center,
                style: tema.textTheme.titleMedium?.copyWith(
                  color: tema.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabKatalog extends StatelessWidget {
  const TabKatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: daftarMusik.length,
      itemBuilder: (context, i) {
        final item = daftarMusik[i];
        final isGelap = Theme.of(context).brightness == Brightness.dark;
        return Card(
          color: isGelap ? const Color(0xFF1E1E1E) : null,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Hero(
              tag: 'cover-${item.id}',
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(item.ikon, color: Colors.white, size: 28),
              ),
            ),
            title: Text(item.artis, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.lagu),
            trailing: const Icon(Icons.play_circle_fill, size: 32),
            onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
          ),
        );
      },
    );
  }
}

class HalamanDetail extends StatelessWidget {
  final ItemMusik item;
  const HalamanDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(item.artis)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'cover-${item.id}',
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: tema.colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: tema.colorScheme.primary.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(item.ikon, size: 100, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            Text(item.lagu, style: tema.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(item.artis, style: tema.textTheme.titleLarge?.copyWith(color: tema.colorScheme.primary)),
          ],
        ),
      ),
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
              title: const Text('Mode Gelap / AMOLED'),
              value: isGelap,
              onChanged: (v) {
                _temaMode.value = v ? ThemeMode.dark : ThemeMode.light;
                _simpanTema(_temaMode.value, _pilihanWarna.indexOf(_warnaUtama.value));
              },
            ),
            const SizedBox(height: 24),
            Text('Warna Aksen', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              children: [
                for (int i = 0; i < _pilihanWarna.length; i++)
                  GestureDetector(
                    onTap: () {
                      _warnaUtama.value = _pilihanWarna[i];
                      _simpanTema(_temaMode.value, i);
                    },
                    child: CircleAvatar(
                      radius: 24,
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