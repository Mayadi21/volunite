class Pencapaian {
  final int id;
  final String nama;
  final String? deskripsi;
  final String? thumbnail;
  
  final String? tanggalDidapat;

  Pencapaian({
    required this.id,
    required this.nama,
    this.deskripsi,
    this.thumbnail,
    this.tanggalDidapat,
  });

  factory Pencapaian.fromJson(Map<String, dynamic> json) {
    return Pencapaian(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      thumbnail: json['thumbnail'],
      tanggalDidapat: json['pivot'] != null 
          ? json['pivot']['created_at'] 
          : null,
    );
  }
}