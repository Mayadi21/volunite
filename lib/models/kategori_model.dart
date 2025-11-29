class Kategori {
  final int id;
  final String namaKategori;
  final String? deskripsi;
  final String? thumbnail;

  Kategori({
    required this.id,
    required this.namaKategori,
    this.deskripsi,
    this.thumbnail,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      namaKategori: json['nama_kategori'],
      deskripsi: json['deskripsi'],
      thumbnail: json['thumbnail'],
    );
  }
}