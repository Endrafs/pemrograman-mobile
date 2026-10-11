class Komentar {
  final int id;
  final String nama;
  final String email;
  final String isi;

  const Komentar({
    required this.id,
    required this.nama,
    required this.email,
    required this.isi,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      id: json['id'] as int,
      nama: json['name'] as String,
      email: json['email'] as String,
      isi: json['body'] as String,
    );
  }
}