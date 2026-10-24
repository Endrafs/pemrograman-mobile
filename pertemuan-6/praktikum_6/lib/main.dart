import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

final _temaMode = ValueNotifier<ThemeMode>(ThemeMode.system);
final _warnaUtama = ValueNotifier<Color>(Colors.indigo);
final _gayaTampilanGrid = ValueNotifier<bool>(false);

const _pilihanWarna = <Color>[
  Colors.indigo,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.orange,
  Colors.deepOrange,
  Colors.pink,
  Colors.purple,
];

ThemeData _buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
    ),
  );
}

Future<void> _muatPengaturan() async {
  final prefs = await SharedPreferences.getInstance();
  final indexWarna = prefs.getInt('indexWarna') ?? 0;
  final isGelap = prefs.getBool('modeGelap');
  final isGrid = prefs.getBool('tampilanGrid') ?? false;

  _warnaUtama.value = _pilihanWarna[indexWarna];
  _gayaTampilanGrid.value = isGrid;
  if (isGelap != null) {
    _temaMode.value = isGelap ? ThemeMode.dark : ThemeMode.light;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _muatPengaturan();
  runApp(const AplikasiKatalogModern());
}

class AplikasiKatalogModern extends StatelessWidget {
  const AplikasiKatalogModern({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_temaMode, _warnaUtama]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Katalog Modern',
          debugShowCheckedModeBanner: false,
          theme: _buatTema(_warnaUtama.value, Brightness.light),
          darkTheme: _buatTema(_warnaUtama.value, Brightness.dark).copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              centerTitle: true,
              elevation: 0,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF0A0A0A),
            ),
          ),
          themeMode: _temaMode.value,
          initialRoute: '/',
          routes: {
            '/': (context) => const HalamanUtama(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final item = settings.arguments as ItemKatalog;
              return PageRouteBuilder(
                pageBuilder: (context, anim, secondAnim) => HalamanDetail(item: item),
                transitionsBuilder: (context, anim, secondAnim, child) {
                  const begin = Offset(0.0, 0.05);
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;
                  final tweenPosition = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  final tweenOpacity = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
                  
                  return SlideTransition(
                    position: anim.drive(tweenPosition),
                    child: FadeTransition(
                      opacity: anim.drive(tweenOpacity),
                      child: child,
                    ),
                  );
                },
                settings: settings,
                transitionDuration: const Duration(milliseconds: 400),
              );
            }
            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Rute Hilang')),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image_outlined, size: 80, color: Theme.of(context).colorScheme.error),
                      const SizedBox(height: 16),
                      Text('Halaman tidak ditemukan', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ItemKatalog {
  final String id;
  final String nama;
  final String deskripsiPendek;
  final String deskripsiLengkap;
  final IconData ikon;
  final Color warna;
  final String kategori;
  final double rating;

  const ItemKatalog({
    required this.id,
    required this.nama,
    required this.deskripsiPendek,
    required this.deskripsiLengkap,
    required this.ikon,
    required this.warna,
    required this.kategori,
    required this.rating,
  });
}

const daftarKatalog = [
  ItemKatalog(
    id: '1',
    nama: 'Flutter Framework',
    deskripsiPendek: 'Toolkit UI lintas platform buatan Google.',
    deskripsiLengkap: 'Flutter adalah toolkit antarmuka pengguna sumber terbuka yang dibuat oleh Google. Digunakan untuk mengembangkan aplikasi yang dikompilasi secara asli untuk perangkat seluler, web, dan desktop dari satu basis kode. Arsitekturnya yang reaktif memungkinkan pembaruan antarmuka yang sangat cepat pada 60 hingga 120 frame per detik.',
    ikon: Icons.flutter_dash,
    warna: Colors.blue,
    kategori: 'Pengembangan',
    rating: 4.9,
  ),
  ItemKatalog(
    id: '2',
    nama: 'Kecerdasan Buatan',
    deskripsiPendek: 'Model bahasa dan jaringan saraf tiruan.',
    deskripsiLengkap: 'Kecerdasan Buatan (AI) mencakup pemrosesan bahasa alami, visi komputer, dan pembelajaran mesin. Sistem ini mampu menganalisis pola data dalam skala besar untuk menghasilkan teks, gambar, atau mengambil keputusan prediktif dengan tingkat akurasi yang mendekati atau bahkan melampaui kemampuan analisis manusia.',
    ikon: Icons.smart_toy,
    warna: Colors.purple,
    kategori: 'Teknologi',
    rating: 4.8,
  ),
  ItemKatalog(
    id: '3',
    nama: 'Keamanan Siber',
    deskripsiPendek: 'Perlindungan infrastruktur dan enkripsi data.',
    deskripsiLengkap: 'Keamanan siber berfokus pada praktik melindungi sistem, jaringan, dan program dari serangan digital. Ini melibatkan implementasi protokol enkripsi canggih, pengujian penetrasi, dan arsitektur zero-trust untuk memastikan kerahasiaan, integritas, dan ketersediaan data pengguna di era komputasi awan.',
    ikon: Icons.security,
    warna: Colors.teal,
    kategori: 'Keamanan',
    rating: 4.7,
  ),
  ItemKatalog(
    id: '4',
    nama: 'Komputasi Kuantum',
    deskripsiPendek: 'Pemrosesan data berbasis mekanika kuantum.',
    deskripsiLengkap: 'Komputasi kuantum memanfaatkan fenomena superposisi dan keterikatan kuantum untuk melakukan operasi pada data. Berbeda dengan bit biner konvensional, qubit memungkinkan penyelesaian masalah matematika kompleks, seperti pemodelan molekuler dan kriptografi tingkat lanjut, dalam waktu yang mustahil dicapai oleh superkomputer tradisional.',
    ikon: Icons.memory,
    warna: Colors.deepOrange,
    kategori: 'Penelitian',
    rating: 4.6,
  ),
  ItemKatalog(
    id: '5',
    nama: 'Desain Antarmuka',
    deskripsiPendek: 'Prinsip tata letak dan pengalaman pengguna.',
    deskripsiLengkap: 'UI/UX Design adalah seni dan sains dalam merancang interaksi antara manusia dan produk digital. Fokus utamanya mencakup hierarki visual, konsistensi tipografi, aksesibilitas kontras warna, serta alur navigasi yang intuitif untuk memaksimalkan retensi pengguna dan meminimalkan beban kognitif saat menggunakan aplikasi.',
    ikon: Icons.design_services,
    warna: Colors.pink,
    kategori: 'Kreatif',
    rating: 4.9,
  ),
];

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _indeksTab = 0;
  static const _halaman = [TabBeranda(), TabEksplorasi(), TabAnimasi(), TabPengaturan()];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warnaScheme = tema.colorScheme;
    
    return Scaffold(
      extendBody: true,
      drawer: Drawer(
        backgroundColor: tema.scaffoldBackgroundColor,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: warnaScheme.surfaceContainerHighest,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: warnaScheme.primary,
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              accountName: Text('Saelendra Farell', style: TextStyle(color: warnaScheme.onSurface, fontWeight: FontWeight.bold)),
              accountEmail: Text('NIM: 20240801168', style: TextStyle(color: warnaScheme.onSurfaceVariant)),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: _indeksTab == 0 ? warnaScheme.primary : null),
              title: Text('Dashboard', style: TextStyle(fontWeight: _indeksTab == 0 ? FontWeight.bold : null)),
              selected: _indeksTab == 0,
              onTap: () {
                setState(() => _indeksTab = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.explore, color: _indeksTab == 1 ? warnaScheme.primary : null),
              title: Text('Katalog Eksplorasi', style: TextStyle(fontWeight: _indeksTab == 1 ? FontWeight.bold : null)),
              selected: _indeksTab == 1,
              onTap: () {
                setState(() => _indeksTab = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.auto_awesome, color: _indeksTab == 2 ? warnaScheme.primary : null),
              title: Text('Studio Animasi', style: TextStyle(fontWeight: _indeksTab == 2 ? FontWeight.bold : null)),
              selected: _indeksTab == 2,
              onTap: () {
                setState(() => _indeksTab = 2);
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: _indeksTab == 3 ? warnaScheme.primary : null),
              title: Text('Pengaturan Sistem', style: TextStyle(fontWeight: _indeksTab == 3 ? FontWeight.bold : null)),
              selected: _indeksTab == 3,
              onTap: () {
                setState(() => _indeksTab = 3);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: IndexedStack(
        index: _indeksTab,
        children: _halaman,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeksTab,
        onDestinationSelected: (i) => setState(() => _indeksTab = i),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Eksplorasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
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

class TabBeranda extends StatelessWidget {
  const TabBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final isGelap = tema.brightness == Brightness.dark;
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          stretch: true,
          backgroundColor: isGelap ? Colors.black : tema.colorScheme.surface,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            title: Text(
              'Selamat Datang,\nSaelendra!',
              style: TextStyle(
                color: tema.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                height: 1.2,
                fontSize: 20,
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  right: -50,
                  top: -50,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tema.colorScheme.primary.withOpacity(isGelap ? 0.15 : 0.05),
                    ),
                  ),
                ),
                Positioned(
                  left: -30,
                  bottom: 50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tema.colorScheme.tertiary.withOpacity(isGelap ? 0.15 : 0.05),
                    ),
                  ),
                ),
              ],
            ),
          ),
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sorotan Inovasi',
                  style: tema.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, i) {
                      final item = daftarKatalog[i];
                      return Container(
                        width: 300,
                        margin: const EdgeInsets.only(right: 16),
                        child: Card(
                          color: isGelap ? const Color(0xFF121212) : tema.colorScheme.surfaceContainerHighest,
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
                            borderRadius: BorderRadius.circular(24),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: 'ikon-${item.id}-beranda',
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: item.warna.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(item.ikon, color: item.warna, size: 32),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    item.nama,
                                    style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.deskripsiPendek,
                                    style: tema.textTheme.bodyMedium?.copyWith(color: tema.colorScheme.onSurfaceVariant),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Ringkasan Aktivitas',
                  style: tema.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buatKartuStatistik(context, 'Total Item', '${daftarKatalog.length}', Icons.library_books),
                    const SizedBox(width: 16),
                    _buatKartuStatistik(context, 'Rata-rata Rating', '4.8', Icons.star_rate),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buatKartuStatistik(BuildContext context, String judul, String nilai, IconData ikon) {
    final tema = Theme.of(context);
    final isGelap = tema.brightness == Brightness.dark;
    
    return Expanded(
      child: Card(
        color: isGelap ? const Color(0xFF121212) : tema.colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Icon(ikon, size: 36, color: tema.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                nilai,
                style: tema.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: tema.colorScheme.primary),
              ),
              const SizedBox(height: 4),
              Text(
                judul,
                style: tema.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabEksplorasi extends StatelessWidget {
  const TabEksplorasi({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Tersedia'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          ListenableBuilder(
            listenable: _gayaTampilanGrid,
            builder: (context, _) {
              return IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => RotationTransition(turns: anim, child: child),
                  child: Icon(
                    _gayaTampilanGrid.value ? Icons.view_list_rounded : Icons.grid_view_rounded,
                    key: ValueKey(_gayaTampilanGrid.value),
                  ),
                ),
                onPressed: () async {
                  _gayaTampilanGrid.value = !_gayaTampilanGrid.value;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('tampilanGrid', _gayaTampilanGrid.value);
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: _gayaTampilanGrid,
        builder: (context, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _gayaTampilanGrid.value
                ? GridView.builder(
                    key: const ValueKey('grid_view'),
                    padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: daftarKatalog.length,
                    itemBuilder: (context, i) => _buatKartuGrid(context, daftarKatalog[i]),
                  )
                : ListView.builder(
                    key: const ValueKey('list_view'),
                    padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                    itemCount: daftarKatalog.length,
                    itemBuilder: (context, i) => _buatKartuList(context, daftarKatalog[i]),
                  ),
          );
        },
      ),
    );
  }

  Widget _buatKartuList(BuildContext context, ItemKatalog item) {
    final isGelap = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isGelap ? const Color(0xFF121212) : null,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Hero(
                tag: 'ikon-${item.id}',
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: item.warna.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(item.ikon, color: item.warna, size: 40),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.deskripsiPendek,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.kategori,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.star_rounded, size: 16, color: Colors.amber[600]),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buatKartuGrid(BuildContext context, ItemKatalog item) {
    final isGelap = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isGelap ? const Color(0xFF121212) : null,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'ikon-${item.id}',
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.warna.withOpacity(0.15),
                  ),
                  child: Icon(item.ikon, color: item.warna, size: 48),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                item.nama,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.kategori,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HalamanDetail extends StatelessWidget {
  final ItemKatalog item;
  const HalamanDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final isGelap = tema.brightness == Brightness.dark;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: isGelap ? Colors.black : tema.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      item.warna.withOpacity(0.3),
                      isGelap ? Colors.black : tema.colorScheme.surface,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'ikon-${item.id}',
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.warna.withOpacity(0.15),
                        boxShadow: [
                          BoxShadow(
                            color: item.warna.withOpacity(0.3),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(item.ikon, size: 120, color: item.warna),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: item.warna.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.kategori,
                          style: TextStyle(
                            color: item.warna,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber[500], size: 28),
                          const SizedBox(width: 6),
                          Text(
                            item.rating.toString(),
                            style: tema.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    item.nama,
                    style: tema.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: tema.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Ikhtisar',
                    style: tema.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.deskripsiPendek,
                    style: tema.textTheme.bodyLarge?.copyWith(
                      color: tema.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Informasi Detail',
                    style: tema.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.deskripsiLengkap,
                    style: tema.textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                      color: tema.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        backgroundColor: item.warna,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Tandai Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
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
  bool _statusAktif = false;
  int _tahapProses = 0;
  bool _modeRahasia = false;
  late final AnimationController _penggerakRadar;

  @override
  void initState() {
    super.initState();
    _penggerakRadar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _penggerakRadar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final isGelap = tema.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Komponen Interaktif'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24).copyWith(bottom: 100),
        children: [
          _buatGrupKomponen(
            context,
            '1. Kendali Status (AnimatedContainer)',
            'Mendemonstrasikan perubahan dimensi dan warna secara implisit saat interaksi pengguna terjadi.',
            GestureDetector(
              onTap: () => setState(() => _statusAktif = !_statusAktif),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                width: _statusAktif ? double.infinity : 160,
                height: 60,
                decoration: BoxDecoration(
                  color: _statusAktif ? tema.colorScheme.primary : (isGelap ? const Color(0xFF222222) : tema.colorScheme.surfaceContainerHighest),
                  borderRadius: BorderRadius.circular(_statusAktif ? 16 : 30),
                  boxShadow: _statusAktif ? [
                    BoxShadow(
                      color: tema.colorScheme.primary.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ] : [],
                ),
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _statusAktif ? 'SISTEM TERHUBUNG' : 'KONEKSIKAN',
                    key: ValueKey(_statusAktif),
                    style: TextStyle(
                      color: _statusAktif ? Colors.white : tema.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buatGrupKomponen(
            context,
            '2. Indikator Tahap (AnimatedSwitcher)',
            'Mengganti elemen antarmuka secara keseluruhan dengan transisi ukuran yang presisi.',
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: Container(
                    key: ValueKey(_tahapProses),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: tema.colorScheme.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$_tahapProses',
                      style: tema.textTheme.headlineLarge?.copyWith(
                        color: tema.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _tahapProses++),
                  icon: const Icon(Icons.arrow_upward_rounded),
                  label: const Text('Tingkatkan'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buatGrupKomponen(
            context,
            '3. Pemindai Radar (AnimationController)',
            'Animasi eksplisit berulang tanpa batas yang dikendalikan penuh melalui vsync ticker.',
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: tema.colorScheme.primary.withOpacity(0.3), width: 2),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _penggerakRadar,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _penggerakRadar.value * 2 * math.pi,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                Colors.transparent,
                                tema.colorScheme.primary.withOpacity(0.1),
                                tema.colorScheme.primary,
                              ],
                              stops: const [0.0, 0.8, 1.0],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Icon(Icons.radar_rounded, size: 40, color: tema.colorScheme.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buatGrupKomponen(
            context,
            '4. Akses Rahasia (AnimatedOpacity)',
            'Memudarkan elemen masuk atau keluar dari komposisi visual tanpa merusak tata letak.',
            Column(
              children: [
                SwitchListTile(
                  title: const Text('Tampilkan Kredensial', style: TextStyle(fontWeight: FontWeight.bold)),
                  value: _modeRahasia,
                  activeColor: tema.colorScheme.primary,
                  onChanged: (v) => setState(() => _modeRahasia = v),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                AnimatedOpacity(
                  opacity: _modeRahasia ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isGelap ? const Color(0xFF1E1E1E) : tema.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isGelap ? Colors.redAccent.withOpacity(0.5) : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.lock_open_rounded, size: 40, color: isGelap ? Colors.redAccent : tema.colorScheme.onErrorContainer),
                        const SizedBox(height: 12),
                        Text(
                          'Akses Administrator Diberikan',
                          style: TextStyle(
                            color: isGelap ? Colors.white : tema.colorScheme.onErrorContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatGrupKomponen(BuildContext context, String judul, String deskripsi, Widget komponen) {
    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(judul, style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(deskripsi, style: tema.textTheme.bodySmall?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 20),
        komponen,
      ],
    );
  }
}

class TabPengaturan extends StatelessWidget {
  const TabPengaturan({super.key});

  Future<void> _simpanTema(ThemeMode mode, int indexWarna) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', mode == ThemeMode.dark);
    await prefs.setInt('indexWarna', indexWarna);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferensi Sistem'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([_temaMode, _warnaUtama]),
        builder: (context, _) {
          final isGelap = tema.brightness == Brightness.dark;
          
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Card(
                color: isGelap ? const Color(0xFF121212) : null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SwitchListTile(
                    title: const Text('Mode AMOLED (Gelap)', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Menggunakan warna hitam pekat untuk efisiensi baterai.'),
                    secondary: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isGelap ? Colors.white24 : Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(isGelap ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
                    ),
                    value: isGelap,
                    onChanged: (v) {
                      _temaMode.value = v ? ThemeMode.dark : ThemeMode.light;
                      _simpanTema(_temaMode.value, _pilihanWarna.indexOf(_warnaUtama.value));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text('Spektrum Warna Utama', style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Pilih warna dasar untuk menyesuaikan seluruh antarmuka komponen.', style: tema.textTheme.bodySmall?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  for (int i = 0; i < _pilihanWarna.length; i++)
                    GestureDetector(
                      onTap: () {
                        _warnaUtama.value = _pilihanWarna[i];
                        _simpanTema(_temaMode.value, i);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _pilihanWarna[i],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _warnaUtama.value == _pilihanWarna[i] ? tema.colorScheme.onSurface : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: _warnaUtama.value == _pilihanWarna[i] ? [
                            BoxShadow(
                              color: _pilihanWarna[i].withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            )
                          ] : [],
                        ),
                        child: _warnaUtama.value == _pilihanWarna[i]
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 30)
                            : null,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}