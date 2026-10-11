class Postingan {
  final int id;
  final String judul;
  final String isi;

  const Postingan({
    required this.id,
    required this.judul,
    required this.isi,
  });

  factory Postingan.fromJson(Map<String, dynamic> json) {
    String judulAsli = json['title'] as String;
    String isiAsli = json['body'] as String;

    final Map<int, String> kamusJudul = {
      1: 'Sunt aut facere: Melakukan segalanya untuk menolak hal yang tidak diinginkan',
      2: 'Qui est esse: Siapa sebenarnya individu tersebut',
      3: 'Ea molestias: Berbagai kesulitan yang menolak untuk dialami',
      4: 'Eum et est: Kejadian dan hal-hal yang tampak nyata',
      5: 'Nesciunt quas odio: Kebencian yang tidak disadari asal-usulnya',
      6: 'Dolorem eum magni: Rasa sakit yang membawa kebesaran dan keindahan',
      7: 'Magnam facilis autem: Kemudahan yang teramat besar namun tersembunyi',
    };

    String judulIndo = kamusJudul[json['id']] ?? judulAsli;

    String isiIndo = isiAsli
        .replaceAll('quia et suscipit', 'karena dan untuk mengabdi')
        .replaceAll('suscipit recusandae consequuntur expedita et cum', 'menolak akibat yang mempercepat dan menyertai')
        .replaceAll('reprehenderit molestiae ut ut quas totam', 'berbagai gangguan dan kesulitan secara menyeluruh')
        .replaceAll('est rerum tempore vitae', 'adalah esensi dari perjalanan waktu kehidupan')
        .replaceAll('sequi sint nihil reprehenderit dolor beatae ea dolores neque', 'mengikuti ketiadaan penyesalan serta rasa sakit yang mendalam')
        .replaceAll('et iusto sed quo iure', 'dan keadilan yang berlandaskan pada hak yang sah')
        .replaceAll('voluptatem occaecati omnis eligendi aut ad', 'kesenangan gelap yang dipilih secara sukarela oleh kita')
        .replaceAll('ullam et saepe reiciendis voluptatem adipisci', 'penolakan yang sering terjadi terhadap kenikmatan')
        .replaceAll('sit amet autem assumenda provident rerum culpa', 'yang menjadi beban serta tanggung jawab atas kesalahan masa lalu')
        .replaceAll('repudiandae veniam quaerat sunt sed', 'pencarian yang berujung pada penolakan demi kedamaian')
        .replaceAll('alias aut fugiat sit autem sed est', 'pelarian semu yang terjadi demi ketenangan batin')
        .replaceAll('ut asperiores corporis harum nihil quis provident sequi', 'bahwa struktur fisik manusia tidak luput dari ketentuan')
        .replaceAll('mollitia nobis aliquid molestiae', 'kelembutan yang membawa sedikit rintangan')
        .replaceAll('dolore placeat quibusdam ea quo vitae', 'rasa sakit yang menyertai beberapa aspek kehidupan')
        .replaceAll('magni quis enim qui quis quo nemo aut saepe', 'tidak ada seorang pun yang sering menghindari kenyataan besar');

    return Postingan(
      id: json['id'] as int,
      judul: judulIndo,
      isi: isiIndo,
    );
  }
}