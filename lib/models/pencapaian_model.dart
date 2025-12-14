class Pencapaian {
  final int id;
  final String nama;
  final String? deskripsi;
  final String? thumbnail;
  final String? tanggalDidapat;
  final bool isUnlocked; 

  Pencapaian({
    required this.id,
    required this.nama,
    this.deskripsi,
    this.thumbnail,
    this.tanggalDidapat,
    this.isUnlocked = false, 
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
      isUnlocked: json['is_unlocked'] ?? false,
    );
  }
}