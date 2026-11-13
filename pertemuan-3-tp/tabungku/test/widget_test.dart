import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabungku_layout/main.dart';

void main() {
  // Mengatur ukuran layar virtual agar bisa diuji di beberapa perangkat.
  Future<void> aturUkuranLayar(WidgetTester tester, Size ukuran) async {
    tester.view.physicalSize = ukuran;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('layout ringkasan tampil di layar ponsel tanpa overflow',
      (tester) async {
    await aturUkuranLayar(tester, const Size(390, 844));
    await tester.pumpWidget(const TabungKuApp());
    await tester.pumpAndSettle();

    expect(find.text('Ringkasan Tabungan'), findsOneWidget);
    expect(find.text('Tabungan Umum'), findsOneWidget);
    expect(find.text('Rp 6.450.000'), findsNWidgets(2));
    expect(find.text('Menabung'), findsOneWidget);
    expect(find.text('Tarik'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);

    // Gulir ke bawah untuk memastikan transaksi terakhir ikut tampil.
    await tester.scrollUntilVisible(
      find.text('Isi ulang e-wallet'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Isi ulang e-wallet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('layout ringkasan tampil di layar tablet tanpa overflow',
      (tester) async {
    await aturUkuranLayar(tester, const Size(1024, 1366));
    await tester.pumpWidget(const TabungKuApp());
    await tester.pumpAndSettle();

    expect(find.text('Ringkasan Tabungan'), findsOneWidget);
    expect(find.text('Tabungan Umum'), findsOneWidget);
    expect(find.text('Menabung mingguan'), findsOneWidget);
    expect(find.text('Beli buku kuliah'), findsOneWidget);
    expect(find.text('Bonus proyek kecil'), findsOneWidget);
    expect(find.text('Isi ulang e-wallet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
