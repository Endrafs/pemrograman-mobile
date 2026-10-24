import 'package:flutter/material.dart';
import '../state/pengaturan.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: PengaturanState.temaMode,
        builder: (context, mode, _) {
          final isGelap = mode == ThemeMode.dark || (mode == ThemeMode.system && Theme.of(context).brightness == Brightness.dark);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                title: const Text('Mode Gelap'),
                value: isGelap,
                onChanged: (v) {
                  PengaturanState.simpanTema(
                    v ? ThemeMode.dark : ThemeMode.light,
                    PengaturanState.pilihanWarna.indexOf(PengaturanState.warnaUtama.value),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text('Warna Tema', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: [
                  for (int i = 0; i < PengaturanState.pilihanWarna.length; i++)
                    GestureDetector(
                      onTap: () => PengaturanState.simpanTema(mode, i),
                      child: CircleAvatar(
                        backgroundColor: PengaturanState.pilihanWarna[i],
                        child: PengaturanState.warnaUtama.value == PengaturanState.pilihanWarna[i]
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                ],
              ),
              const Divider(height: 32),
              Text('Target Tabungan Harian', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ValueListenableBuilder<int>(
                valueListenable: PengaturanState.targetTabungan,
                builder: (context, target, _) {
                  return Column(
                    children: [
                      Text('Rp $target', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                      Slider(
                        value: target.toDouble(),
                        min: 0,
                        max: 100000,
                        divisions: 20,
                        label: 'Rp $target',
                        onChanged: (v) => PengaturanState.simpanTarget(v.toInt()),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}