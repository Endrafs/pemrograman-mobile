import 'package:intl/intl.dart';

class FormatData {
  static String rupiah(int angka) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(angka);
  }

  static String hariIni() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static String tampilTanggal(String tanggal) {
    final dt = DateTime.parse(tanggal);
    return DateFormat('dd MMM yyyy', 'id_ID').format(dt);
  }
}